import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { updateRecord } from 'lightning/uiRecordApi';
import JOB_APPLICATION_OBJECT from '@salesforce/schema/Job_Application__c';
import PAY_FREQUENCY_FIELD from '@salesforce/schema/Job_Application__c.Pay_Frequency__c';
import TAKE_HOME_SALARY_FIELD from '@salesforce/schema/Job_Application__c.Take_Home_Salary__c';
import ID_FIELD from '@salesforce/schema/Job_Application__c.Id';

export default class TakeHomePayCalculator extends LightningElement {
    @track jobApplication = {
        Gross_Paycheck__c: 0,
        Pay_Frequency__c: '',
        File_Status__c: '',
        Number_of_children_under_age_17__c: 0,
        Number_of_other_dependents__c: 0,
        Pretax_Deductions_Withheld__c: 0,
        State_Income_Tax_Rate__c: 0,
        City_Income_Tax_Rate__c: 0
    };

    @track takeHomePay = 0;
    @track socialSecurityTax = 0;
    @track medicareTax = 0;
    @track federalTax = 0;
    @track showBreakdown = false;
    @api recordId; // Store Job Application record Id

    // Pay frequency options
    payFrequencyOptions = [
        { label: 'Weekly', value: 'Weekly' },
        { label: 'Bi-Weekly', value: 'Bi-Weekly' },
        { label: 'Semi-Monthly', value: 'Semi-Monthly' },
        { label: 'Monthly', value: 'Monthly' },
        { label: 'Six Month', value: 'Six Month' }
    ];

    // File status options
    fileStatusOptions = [
        { label: 'Single', value: 'Single' },
        { label: 'Married', value: 'Married' },
        { label: 'Head of Household', value: 'Head of Household' }
    ];

    // Handle input changes
    handleInputChange(event) {
        const field = event.target.name;
        const value = event.target.type === 'number' ? parseFloat(event.target.value) || 0 : event.target.value;
        this.jobApplication[field] = value;
    }

    // Handle slider change for salary
    handleSliderChange(event) {
        this.jobApplication.Gross_Paycheck__c = parseFloat(event.detail.value);
    }

    // Calculate Federal Tax
    calculateFederalTax(salary) {
        let federalTax = 0;

        if (salary <= 11000) {
            federalTax = salary * 0.10;
        } else if (salary <= 44725) {
            federalTax = (11000 * 0.10) + ((salary - 11000) * 0.12);
        } else if (salary <= 95375) {
            federalTax = (11000 * 0.10) + (33625 * 0.12) + ((salary - 44725) * 0.22);
        } else if (salary <= 182100) {
            federalTax = (11000 * 0.10) + (33625 * 0.12) + (50650 * 0.22) + ((salary - 95375) * 0.24);
        } else if (salary <= 231250) {
            federalTax = (11000 * 0.10) + (33625 * 0.12) + (50650 * 0.22) + (86725 * 0.24) + ((salary - 182100) * 0.32);
        } else if (salary <= 578125) {
            federalTax = (11000 * 0.10) + (33625 * 0.12) + (50650 * 0.22) + (86725 * 0.24) + (49150 * 0.32) + ((salary - 231250) * 0.35);
        } else {
            federalTax = (11000 * 0.10) + (33625 * 0.12) + (50650 * 0.22) + (86725 * 0.24) + (49150 * 0.32) + (346875 * 0.35) + ((salary - 578125) * 0.37);
        }

        return federalTax;
    }

    // Calculate taxes and take-home pay
    handleCalculateTaxes() {
        let salary = this.jobApplication.Gross_Paycheck__c || 0;
        let payFrequency = this.jobApplication.Pay_Frequency__c;

        if (salary <= 0 || !payFrequency) {
            this.showToast('Error', 'Please enter a valid salary and select a pay frequency.', 'error');
            return;
        }

        let grossPay;
        switch (payFrequency) {
            case 'Weekly':
                grossPay = salary / 52;
                break;
            case 'Bi-Weekly':
                grossPay = salary / 26;
                break;
            case 'Semi-Monthly':
                grossPay = salary / 24;
                break;
            case 'Monthly':
                grossPay = salary / 12;
                break;
            case 'Six Month':
                grossPay = salary / 2;
                break;
            default:
                grossPay = 0;
        }

        this.socialSecurityTax = parseFloat((grossPay * 0.062).toFixed(2));
        this.medicareTax = parseFloat((grossPay * 0.0145).toFixed(2));
        this.federalTax = parseFloat((this.calculateFederalTax(grossPay * 12) / 12).toFixed(2));


        let stateTax = parseFloat((grossPay * (this.jobApplication.State_Income_Tax_Rate__c / 100 || 0)).toFixed(2));
        let cityTax = parseFloat((grossPay * (this.jobApplication.City_Income_Tax_Rate__c / 100 || 0)).toFixed(2));

        let totalDeductions = this.socialSecurityTax + this.medicareTax + stateTax + cityTax + this.federalTax;
        this.takeHomePay = Math.max(0, parseFloat((grossPay - totalDeductions).toFixed(0)));

        this.showBreakdown = true; // Show breakdown after calculating
        this.showToast('Success', 'Take-home pay calculated!', 'success');
    }

    // Save the Pay_Frequency__c and Take_Home_Salary__c fields
    handleSave() {
        if (!this.recordId) {
            this.showToast('Error', 'Please load a valid Job Application record.', 'error');
            return;
        }

        const fields = {};
        fields[ID_FIELD.fieldApiName] = this.recordId;
        fields[PAY_FREQUENCY_FIELD.fieldApiName] = this.jobApplication.Pay_Frequency__c;
        fields[TAKE_HOME_SALARY_FIELD.fieldApiName] = this.takeHomePay;

        const recordInput = { fields };

        updateRecord(recordInput)
            .then(() => {
                this.showToast('Success', 'Job Application updated successfully!', 'success');
            })
            .catch(error => {
                this.showToast('Error', 'Failed to update Job Application. ' + error.body.message, 'error');
            });
    }

    // Show toast notifications
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(event);
    }
}
