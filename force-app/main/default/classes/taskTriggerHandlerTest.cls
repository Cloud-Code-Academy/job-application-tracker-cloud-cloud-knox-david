@isTest
public class taskTriggerHandlerTest {
    @testSetup
    static void setupData() {
        // Create sample job applications with different statuses...
        List<Job_Application__c> jobApps = new List<Job_Application__c>();
        
        jobApps.add(new Job_Application__c(Name = 'Salesforce Developer 1', Current_Status__c = 'Saved'));
        jobApps.add(new Job_Application__c(Name = 'Salesforce Developer 2', Current_Status__c = 'Applying'));
        jobApps.add(new Job_Application__c(Name = 'Salesforce Developer 3', Current_Status__c = 'Applied'));
        jobApps.add(new Job_Application__c(Name = 'Salesforce Developer 4', Current_Status__c = 'Interviewing'));
        jobApps.add(new Job_Application__c(Name = 'Salesforce Developer 5', Current_Status__c = 'Negotiating'));
        jobApps.add(new Job_Application__c(Name = 'Salesforce Developer 6', Current_Status__c = 'Accepted'));
        jobApps.add(new Job_Application__c(Name = 'Salesforce Developer 7', Current_Status__c = 'Closed'));
        
        // Insert job applications...
        insert jobApps;
    }

    @isTest
    static void testTaskCreation() {
        // Query the Job Applications created in the testSetup...
        List<Job_Application__c> jobApps = [SELECT Id, Current_Status__c, CreatedById FROM Job_Application__c];

        // Call the handler method...
        Test.startTest();
        taskTriggerHandler.appStatus(jobApps);
        Test.stopTest();

        // Verify tasks were created for each status...
        List<Task> tasks = [SELECT Id, Subject, WhatId, CreatedById FROM Task];

        System.assertEquals(25, tasks.size(), 'There should be 25 tasks created'); // 25 tasks across all statuses...

        // Verify specific task subjects...
        for (Task t : tasks) {
            System.assert(
                t.Subject.contains('Check if the Job description') ||
                t.Subject.contains('Research the company or role') ||
                t.Subject.contains('Follow up on your application') ||
                t.Subject.contains('Practice answering behavioral') ||
                t.Subject.contains('Prepare your negotiation scripts') ||
                t.Subject.contains('Send a follow-up email thanking') ||
                t.Subject.contains('Review the highlighted skills to see if the role is a good fit') ||
                t.Subject.contains('Review your notes and reflect on areas of improvement') ||
                t.Subject.contains('Identify and save similar job opportunities') ||
                t.Subject.contains('Practice answering behavioral interview questions') ||
                t.Subject.contains('Research the company and your interviewers') ||
                t.Subject.contains('Follow up on your application via email weekly') ||
                t.Subject.contains('Review your notes and reflect on areas of improvement') ||
                t.Subject.contains('Work achievements using the job description keywordsCustomize your') ||
                t.Subject.contains('Move forward the status of the application to') ||
                t.Subject.contains('Add the task to your calendar') ||
                t.Subject.contains('Find and research someone who works at the company and add them as a contacts') ||
                t.Subject.contains('Set up an informational interview') ||
                t.Subject.contains('Identify potential referrals') ||
                t.Subject.contains('Reach out to the') ||
                t.Subject.contains('Continue identifying') ||
                t.Subject.contains('Set up weekly networking') ||
                t.Subject.contains('Prepare your blurb') ||
                t.Subject.contains('Set up your virtual') ||
                t.Subject.contains('Send thank you emails') ||
                t.Subject.contains('Research your market value') ||
                t.Subject.contains('Plan your resignation') ||
                t.Subject.contains('Submit your application') ||
                t.Subject.contains('Prepare for your first day') ||
                t.Subject.contains('Take some time to relax'),
                'Task subject mismatch: ' + t.Subject
            );
        }
    }
}
