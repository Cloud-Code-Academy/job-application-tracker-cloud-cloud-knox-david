@isTest
private class eventReminderSchedulerTest {
    @isTest
    static void testSendEventReminders() {
        // Get User...
        User testUser = [SELECT Id FROM User WHERE Username = :UserInfo.getUserName()];

        // Create a test event...
        Event testEvent = new Event(
            Subject = 'Test Event',
            StartDateTime = System.now().addDays(1).addHours(9),
            EndDateTime = System.now().addDays(1).addHours(10),
            OwnerId = testUser.Id
        );

        insert testEvent;

        // Create the event reminder scheduler instance...
        eventReminderScheduler scheduler = new eventReminderScheduler();

        // Call the sendEventReminders method...
        Test.startTest();
        scheduler.execute(null);
         // Verify that an email was sent....
        Integer invocations = Limits.getEmailInvocations();
        System.Assert.areEqual(1, invocations, 'An Email has not been sent or too many have been sent');
        Test.stopTest();      
        
        
    }
}


