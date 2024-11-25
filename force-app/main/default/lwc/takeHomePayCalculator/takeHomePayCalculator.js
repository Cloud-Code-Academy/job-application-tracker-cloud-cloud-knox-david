import { LightningElement, track, api, wire } from 'lwc';
import calculateTakeHomePay from '@salesforce/apex/takeHomePayController.calculateTakeHomePay';
import { getRecord, updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Add fields to retrieve from Job_Application__c
const FIELDS = [
    'Job_Application__c.Name',
    'Job_Application__c.Salary__c',
    'Job_Application__c.Pay_Frequency__c'
];

export default class TakeHomePayEnhanced extends LightningElement {
    @api recordId;
    @track salary;
    @track payFrequency = '';
    @track filingStatus = '';
    @track childrenUnder17 = 0;
    @track otherDependents = 0;
    @track pretaxDeductions = 0;
    @track stateTaxRate = 0;
    @track cityTaxRate = 0;
    @track socialSecurityTax;
    @track medicareTax;
    @track federalTax;
    @track takeHomePay;
    @track isLoading = false;
    @track error;

    payFrequencyOptions = [
        { label: 'Weekly', value: 'Weekly' },
        { label: 'Bi-Weekly', value: 'Bi-Weekly' },
        { label: 'Semi-Monthly', value: 'Semi-Monthly' },
        { label: 'Monthly', value: 'Monthly' },
        { label: 'Six Month', value: 'Six Month' }
    ];

    filingStatusOptions = [
        { label: 'Single', value: 'Single' },
        { label: 'Married', value: 'Married' },
        { label: 'Head of Household', value: 'Head of Household' }
    ];

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredJobApplication({ error, data }) {
        if (data) {
            this.salary = data.fields.Salary__c.value;
            this.payFrequency = data.fields.Pay_Frequency__c.value;
            this.error = null;
        } else if (error) {
            this.error = 'Failed to load job application data.';
        }
    }

    handleInputChange(event) {
        const field = event.target.name;
        const value = event.target.type === 'number' ? parseFloat(event.target.value) || 0 : event.target.value;
        this[field] = value;
    }

    async handleCalculate() {
        this.isLoading = true; // Show spinner while calculating
        try {
            const result = await calculateTakeHomePay({
                salary: this.salary,
                payFrequency: this.payFrequency,
                filingStatus: this.filingStatus,
                childrenUnder17: this.childrenUnder17,
                otherDependents: this.otherDependents,
                pretaxDeductions: this.pretaxDeductions,
                stateTaxRate: this.stateTaxRate,
                cityTaxRate: this.cityTaxRate
            });

            this.socialSecurityTax = result.socialSecurityTax;
            this.medicareTax = result.medicareTax;
            this.federalTax = result.federalTax;
            this.takeHomePay = result.takeHomePay;
        } catch (error) {
            this.error = 'Error calculating take-home pay.';
        } finally {
            this.isLoading = false; // Hide spinner after calculation
        }
    }

    async handleSave() {
        const fields = {
            Id: this.recordId,
            Salary__c: this.salary,
            Pay_Frequency__c: this.payFrequency,
            Social_Security_Tax__c: this.socialSecurityTax,
            Medicare_Income_Tax__c: this.medicareTax,
            Federal_Income_Tax__c: this.federalTax,
            Take_Home_Salary__c: this.takeHomePay
        };

        try {
            await updateRecord({ fields });
            this.showToast('Celebrate!', 'Job application updated successfully! 🎉', 'success'); // Celebrate toast
        } catch (error) {
            this.showToast('Error', 'Failed to save job application.', 'error');
        }
    }

    showToast(title, message, variant = 'success') {
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message + " 🎉", // Add celebration emoji
            variant: variant
        });
        this.dispatchEvent(toastEvent);
    }
}