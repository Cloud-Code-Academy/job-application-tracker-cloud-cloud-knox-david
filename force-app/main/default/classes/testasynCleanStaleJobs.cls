@isTest
private class testasynCleanStaleJobs {
    @isTest
    static void testBatchExecution() {
        // Step 1: Insert test job applications with varying statuses and creation dates
        List<Job_Application__c> testJobs = new List<Job_Application__c>();
        
        // Insert records with varying statuses
        testJobs.add(new Job_Application__c(
            Current_Status__c = 'Saved',
            Notes__c = null
        )); // Should be updated
        
        testJobs.add(new Job_Application__c(
            Current_Status__c = 'Accepted',
            Notes__c = null
        )); // Should NOT be updated
        
        testJobs.add(new Job_Application__c(
            Current_Status__c = 'Saved',
            Notes__c = null
        )); // Should NOT be updated
        
        // Insert the records
        insert testJobs;

        // Step 2: Simulate CreatedDate using Test.setCreatedDate
        Test.setCreatedDate(testJobs[0].Id, System.today().addDays(-31)); // Older than 30 days
        Test.setCreatedDate(testJobs[1].Id, System.today().addDays(-31)); // Older than 30 days
        Test.setCreatedDate(testJobs[2].Id, System.today().addDays(-10)); // Less than 30 days

        // Step 3: Execute the batch class
        asynCleanStaleJobs batchInstance = new asynCleanStaleJobs();

        Test.startTest();
        Database.executeBatch(batchInstance, 100);
        Test.stopTest();

        // Step 4: Query and validate results
        // Validate jobs that were updated
        List<Job_Application__c> updatedJobs = [SELECT Id, Current_Status__c, Notes__c
                                                FROM Job_Application__c
                                                WHERE Current_Status__c = 'Closed'];
        System.assertEquals(1, updatedJobs.size(), 'Only one job application should be closed.');
        System.assertEquals(
            'Automatically closed if job is not updated after 30 days',
            updatedJobs[0].Notes__c,
            'Notes should indicate the job was automatically closed.'
        );

        // Validate jobs that were not updated
        List<Job_Application__c> unaffectedJobs = [SELECT Id, Current_Status__c
                                                   FROM Job_Application__c
                                                   WHERE Current_Status__c != 'Closed'];
        System.assertEquals(2, unaffectedJobs.size(), 'Two jobs should remain unaffected.');
    }
}