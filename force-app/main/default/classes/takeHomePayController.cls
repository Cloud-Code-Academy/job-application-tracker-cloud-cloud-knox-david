public with sharing class takeHomePayController {
    public static void calSocialSecurity(Decimal salary) {
            // These don't change
            final Decimal socialSecurity = 0.062; 
            final Decimal medicare = 0.0145; 
    
            // Fetching Job Application records 
            List<Job_Application__c> job = [SELECT Id, Pay_Frequency__c, Social_Security__c,Gross_Paycheck__c FROM Job_Application__c]; // Fetch records
             
            for (Job_Application__c jb : job) {
                if (jb.Pay_Frequency__c == 'Bi-Weekly') {
                    // Calculating Social Security deduction
                    Decimal result = jb.Gross_Paycheck__c * socialSecurity;
                    jb.Social_Security__c = result; // Assigning the result to the field
                    System.debug('Social Security Calculation: ' + result);
                }
            }
        }


    public static void calMedicare(){

    }
    public static void calTakeHomePay(){

    }
}