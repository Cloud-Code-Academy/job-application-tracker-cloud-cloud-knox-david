trigger jobApplicationTrigger on Job_Application__c (before update) {
    // Trigger when the application status changes....
    if (Trigger.isBefore && Trigger.isUpdate) {
        taskTriggerHandler.appStatus(Trigger.new);
    }
}