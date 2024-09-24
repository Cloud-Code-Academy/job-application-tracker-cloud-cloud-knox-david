trigger jobApplicationTrigger on Job_Application__c (before update, before Insert) {
    // Trigger when the application status changes
    if (Trigger.isBefore && Trigger.isUpdate) {
        taskTriggerHandler.appStatus(Trigger.new);
    }
    if(Trigger.isBefore && Trigger.isInsert){
        primaryContactAssignment.setPrimaryContactAssignment(Trigger.new);
    }
}