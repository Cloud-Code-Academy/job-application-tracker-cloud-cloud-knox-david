public with sharing class takeHomePayController {
   
    //NOTE - Social Security  Calculation
    @AuraEnabled(cacheable=false)
    public static void calSocialSecurity(List<Job_Application__c> jobs) {
        // Social Security rate
        final Decimal socialSecurity = 0.062;
        // Iterating over the Job Application and querying necessary fields
        for (Job_Application__c jb : jobs) {
            if (jb.Pay_Frequency__c == 'Bi-Weekly') {
                // Calculating Social Security deduction
                Decimal result = jb.Gross_Paycheck__c * socialSecurity;
                jb.Social_Security__c = result;
                System.debug('Social Security Calculation: ' + result);

            } else if (jb.Pay_Frequency__c == 'Weekly') {
                // Gross Pay / 52 Weeks
                Decimal result1 = jb.Gross_Paycheck__c / 52;
                jb.Social_Security__c = result1;
                System.debug('Weekly: ' + result1);

            } else if (jb.Pay_Frequency__c == 'Monthly') {
                // Gross Pay / 12 Months
                Decimal result2 = jb.Gross_Paycheck__c / 12;
                jb.Social_Security__c = result2;
                System.debug('Monthly: ' + result2);

            } else if (jb.Pay_Frequency__c == 'Six Month') {
                // Gross Pay / Six Months
                Decimal result3 = jb.Gross_Paycheck__c / 6;
                jb.Social_Security__c = result3;
                System.debug('Six Month: ' + result3);

            } else if (jb.Pay_Frequency__c == 'Semi-Monthly') {
                // Gross Pay / 24 Semi-Monthly periods
                Decimal result4 = jb.Gross_Paycheck__c / 24;
                jb.Social_Security__c = result4;
                System.debug('Semi-Monthly: ' + result4);
            }
        }
        update jobs;
    }

    //NOTE - Medicare Calculation
    @AuraEnabled(cacheable=false)
    public static void calMedicare(List<Job_Application__c> jobs) {
        // Medicare rate
        final Decimal medicare = 0.0145;

        // Iterating over the Job Application and querying necessary fields
        for (Job_Application__c jb : jobs) {
            if (jb.Pay_Frequency__c == 'Bi-Weekly') {
                Decimal result5 = jb.Gross_Paycheck__c * medicare;
                jb.Medicare__c = result5;

            } else if (jb.Pay_Frequency__c == 'Weekly') {
                Decimal result6 = jb.Gross_Paycheck__c * medicare / 52;
                jb.Medicare__c = result6;

            } else if (jb.Pay_Frequency__c == 'Monthly') {
                Decimal result7 = jb.Gross_Paycheck__c * medicare / 12;
                jb.Medicare__c = result7;

            } else if (jb.Pay_Frequency__c == 'Six Month') {
                Decimal result8 = jb.Gross_Paycheck__c * medicare / 6;
                jb.Medicare__c = result8;

            } else if (jb.Pay_Frequency__c == 'Semi-Monthly') {
                Decimal result9 = jb.Gross_Paycheck__c * medicare / 24;
                jb.Medicare__c = result9;
            }
        }
        update jobs;
    }
     //NOTE - Federal Tax Calculation
     @AuraEnabled(cacheable=false)
     public static void calFederalTax(List<Job_Application__c> jobs){
        final Integer numberOfChildrenUnder17 = 2000;
        final Integer numberOfOtherDependents = 500;
    
        for (Job_Application__c jb : jobs) {
            Decimal dep1 = 0;
            Decimal dep2 = 0;
            Decimal total = 0;
    
            // Calculate deductions based on Pay Frequency
            if (jb.Pay_Frequency__c == 'Bi-Weekly') {
                dep1 = numberOfChildrenUnder17 / 26;
                dep2 = numberOfOtherDependents / 26;
                total = dep1 + dep2;
                jb.Federal_Income_Tax__c = jb.Ded__c - total;
            } else if (jb.Pay_Frequency__c == 'Weekly') {
                dep1 = numberOfChildrenUnder17 / 52;
                dep2 = numberOfOtherDependents / 52;
                total = dep1 + dep2;
                jb.Federal_Income_Tax__c = jb.Ded__c - total;
            } else if (jb.Pay_Frequency__c == 'Semi-Monthly') {
                dep1 = numberOfChildrenUnder17 / 24;
                dep2 = numberOfOtherDependents / 24;
                total = dep1 + dep2;
                jb.Federal_Income_Tax__c = jb.Ded__c - total;
            } else if (jb.Pay_Frequency__c == 'Six Month') {
                dep1 = numberOfChildrenUnder17 / 6;
                dep2 = numberOfOtherDependents / 6;
                total = dep1 + dep2;
                jb.Federal_Income_Tax__c = jb.Ded__c - total;
            } else if (jb.Pay_Frequency__c == 'Monthly') {
                dep1 = numberOfChildrenUnder17 / 12;
                dep2 = numberOfOtherDependents / 12;
                total = dep1 + dep2;
                jb.Federal_Income_Tax__c = jb.Ded__c - total;
            }
            
        
        }
        update jobs;
     }
     @AuraEnabled(cacheable=false)
     public static void calDeductionWithheld(List<Job_Application__c> jobs){
        for (Job_Application__c jb : jobs) {
            // Calculate the pre-tax deductions withheld based on the Pay Frequency
            if (jb.Pay_Frequency__c == 'Bi-Weekly') {
                jb.Pretax_Deductions_Withheld__c = jb.Pretax_Deductions_Withheld__c / 26;
            } else if (jb.Pay_Frequency__c == 'Weekly') {
                jb.Pretax_Deductions_Withheld__c = jb.Pretax_Deductions_Withheld__c / 52;
            } else if (jb.Pay_Frequency__c == 'Semi-Monthly') {
                jb.Pretax_Deductions_Withheld__c = jb.Pretax_Deductions_Withheld__c / 24;
            } else if (jb.Pay_Frequency__c == 'Six Month') {
                jb.Pretax_Deductions_Withheld__c = jb.Pretax_Deductions_Withheld__c / 6;
            } else if (jb.Pay_Frequency__c == 'Monthly') {
                jb.Pretax_Deductions_Withheld__c = jb.Pretax_Deductions_Withheld__c / 12;
            }
    
            System.debug('Pretax Deductions Withheld Calculation for ' + jb.Id + ': ' + jb.Pretax_Deductions_Withheld__c);
        }
        update jobs;
     }

  

        // Method to calculate State and City Income Tax based on provided tax rates
        @AuraEnabled(cacheable=false)
        public static void calStateAndCityTax(List<Job_Application__c> jobs) {
            for (Job_Application__c jb : jobs) {
                Decimal stateTax = 0;
                Decimal cityTax = 0;
    
                // Calculate State Income Tax based on the State Income Tax Rate
                if (jb.State_Income_Tax_Rate__c != null) {
                    stateTax = jb.Gross_Paycheck__c * (jb.State_Income_Tax_Rate__c / 100); // Converting percent to decimal
                    jb.State_Income_Tax__c = stateTax;
                }
    
                // Calculate City Income Tax based on the City Income Tax Rate
                if (jb.City_Income_Tax_Rate__c != null) {
                    cityTax = jb.Gross_Paycheck__c * (jb.City_Income_Tax_Rate__c / 100); // Converting percent to decimal
                    jb.City_Income_Tax__c = cityTax;
                }
    
        
            }
            update jobs; // Update records with calculated values
        }
    
    

    // Method to calculate take-home pay based on job applications
    @AuraEnabled(cacheable=false)
    public static void calTakeHomePay(List<Job_Application__c> jobs) {


        // Calculate Social Security and Medicare first
        calSocialSecurity(jobs);
        calMedicare(jobs);
        calFederalTax(jobs);
        calStateAndCityTax(jobs);
        calDeductionWithheld(jobs);

        for (Job_Application__c jb : [SELECT Id, Pay_Frequency__c, Pretax_deductions_withheld__c, 	Final_Pay_Check__c, Social_Security__c, Medicare__c, Gross_Paycheck__c, Federal_Income_Tax__c, State_Income_Tax__c, City_Income_Tax__c, Ded__c, Number_of_children_under_age_17__c, Number_of_other_dependents__c FROM Job_Application__c]) {
           jb.Final_Pay_Check__c = jb.Gross_Paycheck__c - jb.Federal_Income_Tax__c - jb.Social_Security__c - jb.Medicare__c - jb.State_Income_Tax__c - jb.City_Income_Tax__c - jb.ded__c;
            
            System.debug('Your Final after taxes ' + jb.Final_Pay_Check__c);
            System.debug('Your gross pay ' + jb.Gross_Paycheck__c);
            System.debug('Your Federal Income Tax ' + jb.Federal_Income_Tax__c);
            // Perform calculations or handle the tanke-home pay logic here
            //jb.Final_Pay_Check__c = jb.Gross_Paycheck__c - jb.Federal_Icome_Tax__c - jb.
            // Add calculations and updates as needed
        }
        update jobs;
    }
}
