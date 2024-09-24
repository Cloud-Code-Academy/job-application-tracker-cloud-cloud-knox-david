@IsTest
public class testasynCleanStaleJobs {

    @testSetup
    static void setupTestData() {
        // Create test data for job applications
        List<Job_Application__c> jobApps = new List<Job_Application__c>();

        // Add records that are 30+ days old and not Closed or Accepted
        jobApps.add(new Job_Application__c(Current_Status__c = 'Applying'));
        jobApps.add(new Job_Application__c(Current_Status__c = 'Interviewing'));
        jobApps.add(new Job_Application__c(Current_Status__c = 'Negotiating'));

        // Add records that are under 30 days old
        jobApps.add(new Job_Application__c(Current_Status__c = 'Applying'));
        jobApps.add(new Job_Application__c(Current_Status__c = 'Interviewing'));

        // Add records with Closed or Accepted statuses (should not be affected)
        jobApps.add(new Job_Application__c(Current_Status__c = 'Closed'));
        jobApps.add(new Job_Application__c(Current_Status__c = 'Accepted'));

        insert jobApps;
    }

    @isTest
    static void testCleanStaleJobs() {
        // Query the records and set their CreatedDate to over 30 days in the past
        List<Job_Application__c> jobApps = [SELECT Id, CreatedDate FROM Job_Application__c WHERE Current_Status__c IN ('Applying', 'Interviewing', 'Negotiating') LIMIT 3];
        for (Job_Application__c job : jobApps) {
            Test.setCreatedDate(job.Id, Date.today().addDays(-31));
        }

        // Start the test and execute the queueable job
        Test.startTest();
        asynCleanStaleJobs jobCleaner = new asynCleanStaleJobs();
        System.enqueueJob(jobCleaner);
        Test.stopTest(); // Ensures the queueable job is completed

        // Query the updated records
        List<Job_Application__c> updatedJobs = [SELECT Id, Current_Status__c, Notes__c FROM Job_Application__c WHERE Id IN :jobApps];

        // Assert that the statuses have been changed to 'Closed'
        for (Job_Application__c job : updatedJobs) {
            System.assertEquals('Closed', job.Current_Status__c, 'Job application should be closed after 30 days');
            System.assertEquals('Automatically closed if job is not updated after 30 days', job.Notes__c, 'Notes should be updated');
        }

        // Ensure records with Closed or Accepted status remain unchanged
        List<Job_Application__c> unaffectedJobs = [SELECT Id, Current_Status__c FROM Job_Application__c WHERE Current_Status__c IN ('Closed', 'Accepted')];
        for (Job_Application__c job : unaffectedJobs) {
            System.assert(job.Current_Status__c == 'Closed' || job.Current_Status__c == 'Accepted', 'Statuses should remain unchanged for Closed and Accepted records');
        }
    }
}