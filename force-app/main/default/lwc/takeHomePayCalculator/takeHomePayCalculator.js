import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


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
    @track federalTax = 0; // Track federal tax
   


    payFrequencyOptions = [
        { label: 'Weekly', value: 'Weekly' },
        { label: 'Bi-Weekly', value: 'Bi-Weekly' },
        { label: 'Semi-Monthly', value: 'Semi-Monthly' },
        { label: 'Monthly', value: 'Monthly' },
        { label: 'Six Month', value: 'Six Month' }
    ];

    fileStatusOptions = [
        { label: 'Single', value: 'Single' },
        { label: 'Married', value: 'Married' },
        { label: 'Head of Household', value: 'Head of Household' }
    ];

    handleInputChange(event) {
        const field = event.target.name;
        const value = event.target.type === 'number' ? parseFloat(event.target.value) || 0 : event.target.value;
        this.jobApplication[field] = value;
    }

    calculateFederalTax(salary) {
       let federalTax = 0;
         
        // Calculate federal tax rate based on salary
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

    handleCalculateTaxes() {
        let salary = this.jobApplication.Gross_Paycheck__c || 0;
        let payFrequency = this.jobApplication.Pay_Frequency__c;
    
        console.log('Salary:', salary);
        console.log('Pay Frequency:', payFrequency);
    
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
    
        console.log('Gross Pay:', this.formatCurrency(grossPay));
    
        this.socialSecurityTax = parseFloat((grossPay * 0.062).toFixed(2));
        this.medicareTax = parseFloat((grossPay * 0.0145).toFixed(2));
        this.federalTax = (this.calculateFederalTax(grossPay * 12)) / 12;
    
        // Format federal tax using formatCurrency method
        console.log("Formatted Federal Tax: " + this.formatCurrency(this.federalTax));
    
        let stateTax = parseFloat((grossPay * (this.jobApplication.State_Income_Tax_Rate__c / 100 || 0)).toFixed(2));
        let cityTax = parseFloat((grossPay * (this.jobApplication.City_Income_Tax_Rate__c / 100 || 0)).toFixed(2));
    
        console.log('State Tax:', stateTax);
        console.log('City Tax:', cityTax);
    
        let totalDeductions = this.socialSecurityTax + this.medicareTax + stateTax + cityTax + this.federalTax;
        console.log("Total Deductions: " + totalDeductions);
    
        this.takeHomePay = Math.max(0, parseFloat((grossPay - totalDeductions).toFixed(0)));
    
        console.log('Take-Home Pay:', this.formatCurrency(this.takeHomePay));
    
        this.showToast('Success', 'Take-home pay calculated!', 'success');
    }
    
    formatCurrency(value) {
        return new Intl.NumberFormat('en-US', { style: 'decimal', minimumFractionDigits: 0 }).format(value);
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
