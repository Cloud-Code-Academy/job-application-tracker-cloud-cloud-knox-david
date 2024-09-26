public with sharing class eventTriggerHandler {
    public static void checkForEvents(List<Event> newEvents) {
        
        if(newEvents == null || newEvents.isEmpty()){
                return;
        }
        
        Set<Id> ownerIds = new Set<Id>();

        for(Event newEvent : newEvents) {
            ownerIds.add(newEvent.OwnerId);
        }

        List<Event> conflictingEvents = [SELECT Id, 
                                            Subject, 
                                            StartDateTime, 
                                            EndDateTime,
                                            OwnerId
                                        FROM Event
                                        WHERE OwnerId IN :ownerIds
                                        AND (
                                          (StartDateTime <= :newEvents[0].StartDateTime AND
                                            EndDateTime >= :newEvents[0].StartDateTime)
                                        OR
                                            (StartDateTime <= :newEvents[0].EndDateTime AND
                                            EndDateTime >= :newEvents[0].EndDateTime)
                                            )
                                        ];
        
        for(Event newEvent : newEvents){
            for(Event existingEvent : conflictingEvents){
                if(newEvent.OwnerId == existingEvent.OwnerId){
                    if(existingEvent.OwnerId == existingEvent.OwnerId &&
                       newEvent.StartDateTime >= existingEvent.StartDateTime &&
                       newEvent.StartDateTime <= existingEvent.EndDateTime) {
                       
                       newEvent.addError('An event already exists around this timeframe.');

                 }
              }
           }
        }
    }
}