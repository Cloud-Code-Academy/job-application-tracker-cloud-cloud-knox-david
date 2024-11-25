@isTest
public class takeHomePayControllerTest {

    @isTest
    static void testCalculateTakeHomePay_ValidInput() {
        Decimal salary = 120000; // Annual salary
        String payFrequency = 'Monthly';
        Decimal stateTaxRate = 5;
        Decimal cityTaxRate = 3;

        Map<String, Decimal> result = takeHomePayController.calculateTakeHomePay(salary, payFrequency, stateTaxRate, cityTaxRate);

        System.assert(result != null, 'Result should not be null');
        System.assert(result.containsKey('takeHomePay'), 'Take Home Pay should be included in the result');
        System.assert(result.get('takeHomePay') > 0, 'Take-home pay should be greater than zero');
    }

    @isTest
    static void testCalculateTakeHomePay_ZeroSalary() {
        Decimal salary = 0; // Zero salary
        String payFrequency = 'Monthly';
        Decimal stateTaxRate = 5;
        Decimal cityTaxRate = 3;

        Map<String, Decimal> result = takeHomePayController.calculateTakeHomePay(salary, payFrequency, stateTaxRate, cityTaxRate);

        System.assert(result != null, 'Result should not be null');
        System.assertEquals(0, result.get('takeHomePay'), 'Take-home pay should be zero for zero salary');
    }

    @isTest
    static void testCalculateTakeHomePay_NoFrequencyMatch() {
        Decimal salary = 120000; // Annual salary
        String payFrequency = 'Invalid'; // Unsupported frequency
        Decimal stateTaxRate = 5;
        Decimal cityTaxRate = 3;

        Test.startTest();
        Map<String, Decimal> result = takeHomePayController.calculateTakeHomePay(salary, payFrequency, stateTaxRate, cityTaxRate);
        Test.stopTest();

        System.assert(result != null, 'Result should not be null');
        System.assertEquals(0, result.get('takeHomePay'), 'Take-home pay should be zero for unsupported frequency');
    }

    @isTest
    static void testSavePayFrequency_ValidRecord() {
        Job_Application__c jobApp = new Job_Application__c(Pay_Frequency__c = 'Weekly');
        insert jobApp;

        Test.startTest();
        takeHomePayController.savePayFrequency(jobApp.Id, 'Monthly');
        Test.stopTest();

        Job_Application__c updatedJobApp = [SELECT Pay_Frequency__c FROM Job_Application__c WHERE Id = :jobApp.Id];
        System.assertEquals('Monthly', updatedJobApp.Pay_Frequency__c, 'Pay Frequency should be updated to Monthly');
    }

    @isTest
    static void testCalculateTakeHomePay_WeeklyFrequency() {
        Decimal salary = 52000; // Annual salary
        String payFrequency = 'Weekly';
        Decimal stateTaxRate = 5; // 5% state tax...
        Decimal cityTaxRate = 3; // 3% city tax

        Map<String, Decimal> result = takeHomePayController.calculateTakeHomePay(salary, payFrequency, stateTaxRate, cityTaxRate);

        System.assert(result != null, 'Result should not be null');
        System.assert(result.get('takeHomePay') > 0, 'Take-home pay should be greater than zero for weekly frequency');
    }

    @isTest
    static void testCalculateTakeHomePay_HighTaxRates() {
        Decimal salary = 100000; // Annual salary
        String payFrequency = 'Monthly';
        Decimal stateTaxRate = 90; // Extremely high state tax
        Decimal cityTaxRate = 90; // Extremely high city tax

        Map<String, Decimal> result = takeHomePayController.calculateTakeHomePay(salary, payFrequency, stateTaxRate, cityTaxRate);

        System.assert(result != null, 'Result should not be null');
        System.assertEquals(0, result.get('takeHomePay'), 'Take-home pay should be zero when taxes are excessively high');
    }
}