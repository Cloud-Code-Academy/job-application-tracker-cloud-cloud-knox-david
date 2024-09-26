trigger eventTrigger on Event (before insert) {
    eventTriggerHandler.checkForEvents(Trigger.New);

}