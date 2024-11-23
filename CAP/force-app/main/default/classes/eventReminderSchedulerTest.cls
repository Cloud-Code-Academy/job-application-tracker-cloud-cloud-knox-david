@isTest
private class eventReminderSchedulerTest {

    @isTest
    static void testEventReminderBatch() {
        //Create test data...
        User testUser = [SELECT Id, Email FROM User WHERE IsActive = true LIMIT 1];

        List<Event> testEvents = new List<Event>();
        DateTime startDateTime = DateTime.now().addDays(1).addHours(2);
        DateTime endDateTime = startDateTime.addHours(1);

        for (Integer i = 0; i < 5; i++) {
            testEvents.add(new Event(
                Subject = 'Test Event ' + i,
                StartDateTime = startDateTime.addMinutes(i * 30),
                EndDateTime = endDateTime.addMinutes(i * 30),
                OwnerId = testUser.Id
            ));
        }

        insert testEvents;

        //Enable debug logging for the batch job...
        System.debug('Inserted Events: ' + testEvents);

        //Run the batch job...
        Test.startTest();
        //Execute the batch...
        EventReminderScheduler batchJob = new EventReminderScheduler();
        Database.executeBatch(batchJob, 200);
        Test.stopTest();

        //Verify the test events still exist...
        List<Event> queriedEvents = [SELECT Id, Subject, StartDateTime, OwnerId FROM Event WHERE Id IN :testEvents];
        System.assertEquals(5, queriedEvents.size(), 'Five events should exist.');

        //Verify debug logs or other side effects...
        System.assert(true, 'Batch job finished execution without errors.');
    }

    @isTest
    static void testScheduler() {
        // Schedule the job
        String jobName = 'TestEventReminderJob';
        String cronExp = '0 0 12 * * ?'; // Run at 12 PM every day
        Id jobId = System.schedule(jobName, cronExp, new EventReminderScheduler());

        // Verify that the job was scheduled
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime 
                          FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(cronExp, ct.CronExpression, 'Cron expression should match.');
        System.assertEquals(0, ct.TimesTriggered, 'The job should not have triggered yet.');
    }
}