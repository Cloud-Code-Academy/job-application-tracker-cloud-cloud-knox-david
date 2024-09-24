@isTest
public class eventTriggerHandlerTest {
    
    @testSetup
    static void setupData() {
        // Create a test user for event ownership...
        User testUser = [SELECT Id FROM User WHERE Username = :UserInfo.getUserName()];
        
        // Create an existing event to create a conflict...
        Event existingEvent = new Event(
            OwnerId = testUser.Id,
            Subject = 'Existing Event',
            StartDateTime = DateTime.now().addDays(1),
            EndDateTime = DateTime.now().addDays(1).addHours(1)
        );
        insert existingEvent;
    }
    
    @isTest
    static void testEventConflict() {
        // Query the test user created in setup...
        User testUser = [SELECT Id FROM User WHERE Username = :UserInfo.getUserName()];
        
        // Create a new event that overlaps with the existing event...
        Event conflictingEvent = new Event(
            OwnerId = testUser.Id,
            Subject = 'Conflicting Event',
            StartDateTime = DateTime.now().addDays(1).addMinutes(30),
            EndDateTime = DateTime.now().addDays(1).addHours(2)
        );

        Test.startTest();
        try {
            insert conflictingEvent;
            System.assert(false, 'An error should have been thrown due to conflicting events');
        } catch (DmlException e) {
            // Ensure the error is thrown because of the event conflict...
            System.assert(e.getMessage().contains('An event already exists around this timeframe.'));
        }
        Test.stopTest();
    }
    
    @isTest
    static void testNonConflictingEvent() {
        // Query the test user created in setup...
        User testUser = [SELECT Id FROM User WHERE Username = :UserInfo.getUserName()];
        
        // Create a new event that does NOT overlap with the existing event...
        Event nonConflictingEvent = new Event(
            OwnerId = testUser.Id,
            Subject = 'Non-Conflicting Event',
            StartDateTime = DateTime.now().addDays(2),
            EndDateTime = DateTime.now().addDays(2).addHours(1)
        );

        Test.startTest();
        insert nonConflictingEvent; // This should succeed without any conflict...
        Test.stopTest();
        
        // Verify that the event was inserted successfully...
        List<Event> insertedEvents = [SELECT Id FROM Event WHERE Id = :nonConflictingEvent.Id];
        System.assertEquals(1, insertedEvents.size(), 'The non-conflicting event should have been inserted.');
    }
}
