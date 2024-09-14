public with sharing class takeHomePayController {

    // Method to calculate Social Security based on Job Application data
    public static void calSocialSecurity(List<Job_Application__c> job) {
        // Social Security rate
        final Decimal socialSecurity = 0.062;

        // Iterating over the Job Application and querying necessary fields
        for (Job_Application__c jb : job = [SELECT Id, Pay_Frequency__c, Social_Security__c, Gross_Paycheck__c FROM Job_Application__c]) {
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
    }

    // Method to calculate Medicare based on Job Application data
    public static void calMedicare(List<Job_Application__c> job) {
        // Medicare rate
        final Decimal medicare = 0.0145;

        // Iterating over the Job Application and querying necessary fields
        for (Job_Application__c jb : job = [SELECT Id, Pay_Frequency__c, Medicare__c, Gross_Paycheck__c FROM Job_Application__c]) {
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
    }

    // Placeholder for the method to calculate Take Home Pay
   

        // Method to calculate take-home pay based on job applications
        public static void calTakeHomePay(List<Job_Application__c> jobs) {
            // Loop through each job application
            for (Job_Application__c jb : jobs) {
                Decimal tax = 0;
    
                // Tax calculation for Single filers
                if (jb.Filing_Status__c == 'Single') {
                    if (jb.Salary__c <= 11600) {
                        tax = jb.Salary__c * 0.10;
                    } else if (jb.Salary__c > 11600 && jb.Salary__c <= 47150) {
                        tax = 11600 * 0.10 + (jb.Salary__c - 11600) * 0.12;
                    } else if (jb.Salary__c > 47150 && jb.Salary__c <= 100525) {
                        tax = 11600 * 0.10 + (47150 - 11600) * 0.12 + (jb.Salary__c - 47150) * 0.22;
                    } else if (jb.Salary__c > 100525 && jb.Salary__c <= 191950) {
                        tax = 11600 * 0.10 + (47150 - 11600) * 0.12 + (100525 - 47150) * 0.22 + (jb.Salary__c - 100525) * 0.24;
                    } else if (jb.Salary__c > 191950 && jb.Salary__c <= 243725) {
                        tax = 11600 * 0.10 + (47150 - 11600) * 0.12 + (100525 - 47150) * 0.22 + (191950 - 100525) * 0.24 + (jb.Salary__c - 191950) * 0.32;
                    } else if (jb.Salary__c > 243725 && jb.Salary__c <= 609350) {
                        tax = 11600 * 0.10 + (47150 - 11600) * 0.12 + (100525 - 47150) * 0.22 + (191950 - 100525) * 0.24 + (243725 - 191950) * 0.32 + (jb.Salary__c - 243725) * 0.35;
                    } else {
                        tax = 11600 * 0.10 + (47150 - 11600) * 0.12 + (100525 - 47150) * 0.22 + (191950 - 100525) * 0.24 + (243725 - 191950) * 0.32 + (609350 - 243725) * 0.35 + (jb.Salary__c - 609350) * 0.37;
                    }
                }
    
                // Tax calculation for Married Filing Jointly
                else if (jb.Filing_Status__c == 'Married') {
                    if (jb.Salary__c <= 23200) {
                        tax = jb.Salary__c * 0.10;
                    } else if (jb.Salary__c > 23200 && jb.Salary__c <= 94300) {
                        tax = 23200 * 0.10 + (jb.Salary__c - 23200) * 0.12;
                    } else if (jb.Salary__c > 94300 && jb.Salary__c <= 201050) {
                        tax = 23200 * 0.10 + (94300 - 23200) * 0.12 + (jb.Salary__c - 94300) * 0.22;
                    } else if (jb.Salary__c > 201050 && jb.Salary__c <= 383900) {
                        tax = 23200 * 0.10 + (94300 - 23200) * 0.12 + (201050 - 94300) * 0.22 + (jb.Salary__c - 201050) * 0.24;
                    } else if (jb.Salary__c > 383900 && jb.Salary__c <= 487450) {
                        tax = 23200 * 0.10 + (94300 - 23200) * 0.12 + (201050 - 94300) * 0.22 + (383900 - 201050) * 0.24 + (jb.Salary__c - 383900) * 0.32;
                    } else if (jb.Salary__c > 487450 && jb.Salary__c <= 731200) {
                        tax = 23200 * 0.10 + (94300 - 23200) * 0.12 + (201050 - 94300) * 0.22 + (383900 - 201050) * 0.24 + (487450 - 383900) * 0.32 + (jb.Salary__c - 487450) * 0.35;
                    } else {
                        tax = 23200 * 0.10 + (94300 - 23200) * 0.12 + (201050 - 94300) * 0.22 + (383900 - 201050) * 0.24 + (487450 - 383900) * 0.32 + (731200 - 487450) * 0.35 + (jb.Salary__c - 731200) * 0.37;
                    }
                }
    
                // Tax calculation for Head of Household
                else if (jb.Filing_Status__c == 'Head of Household') {
                    if (jb.Salary__c <= 16550) {
                        tax = jb.Salary__c * 0.10;
                    } else if (jb.Salary__c > 16550 && jb.Salary__c <= 63100) {
                        tax = 16550 * 0.10 + (jb.Salary__c - 16550) * 0.12;
                    } else if (jb.Salary__c > 63100 && jb.Salary__c <= 100500) {
                        tax = 16550 * 0.10 + (63100 - 16550) * 0.12 + (jb.Salary__c - 63100) * 0.22;
                    } else if (jb.Salary__c > 100500 && jb.Salary__c <= 191950) {
                        tax = 16550 * 0.10 + (63100 - 16550) * 0.12 + (100500 - 63100) * 0.22 + (jb.Salary__c - 100500) * 0.24;
                    } else if (jb.Salary__c > 191950 && jb.Salary__c <= 243700) {
                        tax = 16550 * 0.10 + (63100 - 16550) * 0.12 + (100500 - 63100) * 0.22 + (191950 - 100500) * 0.24 + (jb.Salary__c - 191950) * 0.32;
                    } else if (jb.Salary__c > 243700 && jb.Salary__c <= 609350) {
                        tax = 16550 * 0.10 + (63100 - 16550) * 0.12 + (100500 - 63100) * 0.22 + (191950 - 100500) * 0.24 + (243700 - 191950) * 0.32 + (jb.Salary__c - 243700) * 0.35;
                    } else {
                        tax = 16550 * 0.10 + (63100 - 16550) * 0.12 + (100500 - 63100) * 0.22 + (191950 - 100500) * 0.24 + (243700 - 191950) * 0.32 + (609350 - 243700) * 0.35 + (jb.Salary__c - 609350) * 0.37;
                    }
                }
    
                // Log or handle the calculated tax for the job application record
                System.debug('Calculated Tax for ' + jb.Id + ': ' + tax.setScale(2));
            }
        }
    }
    
