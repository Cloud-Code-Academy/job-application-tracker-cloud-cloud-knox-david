public with sharing class takeHomePayController {
    @AuraEnabled(cacheable=false)
    public static Map<String, Decimal> calculateTakeHomePay(
        Decimal salary,
        String payFrequency,
        Decimal stateTaxRate,
        Decimal cityTaxRate
    ) {
        Map<String, Decimal> result = new Map<String, Decimal>();

        // Pay frequency adjustments
        Decimal grossPay;
        if (payFrequency == 'Weekly') {
            grossPay = salary / 52;
        } else if (payFrequency == 'Bi-Weekly') {
            grossPay = salary / 26;
        } else if (payFrequency == 'Semi-Monthly') {
            grossPay = salary / 24;
        } else if (payFrequency == 'Monthly') {
            grossPay = salary / 12;
        } else if (payFrequency == 'Six Month') {
            grossPay = salary / 2;
        } else {
            grossPay = 0;
        }

        // Federal tax brackets
        Decimal federalTax = 0;
        if (grossPay <= 11000 / 12) {
            federalTax = grossPay * 0.10;
        } else if (grossPay <= 44725 / 12) {
            federalTax = (11000 / 12 * 0.10) + ((grossPay - (11000 / 12)) * 0.12);
        } else if (grossPay <= 95375 / 12) {
            federalTax = (11000 / 12 * 0.10) + (33625 / 12 * 0.12) + ((grossPay - (44725 / 12)) * 0.22);
        } else if (grossPay <= 182100 / 12) {
            federalTax = (11000 / 12 * 0.10) + (33625 / 12 * 0.12) + (50650 / 12 * 0.22) + ((grossPay - (95375 / 12)) * 0.24);
        } else if (grossPay <= 231250 / 12) {
            federalTax = (11000 / 12 * 0.10) + (33625 / 12 * 0.12) + (50650 / 12 * 0.22) + (86725 / 12 * 0.24) + ((grossPay - (182100 / 12)) * 0.32);
        } else if (grossPay <= 578125 / 12) {
            federalTax = (11000 / 12 * 0.10) + (33625 / 12 * 0.12) + (50650 / 12 * 0.22) + (86725 / 12 * 0.24) + (49150 / 12 * 0.32) + ((grossPay - (231250 / 12)) * 0.35);
        } else {
            federalTax = (11000 / 12 * 0.10) + (33625 / 12 * 0.12) + (50650 / 12 * 0.22) + (86725 / 12 * 0.24) + (49150 / 12 * 0.32) + (346875 / 12 * 0.35) + ((grossPay - (578125 / 12)) * 0.37);
        }

        // Social Security and Medicare taxes
        Decimal socialSecurityTax = grossPay * 0.062;
        Decimal medicareTax = grossPay * 0.0145;

        // State and City taxes
        Decimal stateTax = grossPay * (stateTaxRate / 100);
        Decimal cityTax = grossPay * (cityTaxRate / 100);

        // Total deductions and take-home pay
        Decimal totalDeductions = socialSecurityTax + medicareTax + federalTax + stateTax + cityTax;
        Decimal takeHomePay = Math.max(0, grossPay - totalDeductions);

        // Add to result
        result.put('socialSecurityTax', socialSecurityTax.setScale(2));
        result.put('medicareTax', medicareTax.setScale(2));
        result.put('federalTax', federalTax.setScale(2));
        result.put('stateTax', stateTax.setScale(2));
        result.put('cityTax', cityTax.setScale(2));
        result.put('takeHomePay', takeHomePay.setScale(2));

        return result;
    }

    @AuraEnabled
public static void savePayFrequency(String recordId, String payFrequency) {
    if (String.isBlank(recordId)) {
        throw new AuraHandledException('Record ID is required.');
    }
    try {
        // Query and update Pay Frequency field
        Job_Application__c jobApplication = [
            SELECT Id, Pay_Frequency__c 
            FROM Job_Application__c 
            WHERE Id = :recordId 
            LIMIT 1
        ];
        jobApplication.Pay_Frequency__c = payFrequency;
        update jobApplication;
    } catch (Exception e) {
        throw new AuraHandledException('Failed to update Pay Frequency: ' + e.getMessage());
    }
}
}