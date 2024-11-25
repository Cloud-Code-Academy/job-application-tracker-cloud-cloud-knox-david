global class asynCleanStaleJobs implements Database.Batchable<sObject> {
      
    // Start method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id, CreatedDate, Current_Status__c, Notes__c FROM Job_Application__c';
        return Database.getQueryLocator(query);
    }
    
    // Execute method
    global void execute(Database.BatchableContext BC, List<Job_Application__c> scope) {
        List<Job_Application__c> jobsToUpdate = new List<Job_Application__c>();
        
        for (Job_Application__c jb : scope) {
            // Check if CreatedDate is 30 days or older and status is not 'Closed' or 'Accepted'
            if (jb.CreatedDate <= System.today().addDays(-30) && 
                jb.Current_Status__c != 'Closed' && 
                jb.Current_Status__c != 'Accepted') {
                
                jb.Current_Status__c = 'Closed';
                jb.Notes__c = 'Automatically closed if job is not updated after 30 days';
                jobsToUpdate.add(jb);
            }
        }
        
        // Update only the records that need to be updated
        if (!jobsToUpdate.isEmpty()) {
            update jobsToUpdate;
        }
    }
    
    // Finish method
    global void finish(Database.BatchableContext BC) {
        // Log completion for tracking
        System.debug('Batch process for cleaning stale jobs has completed.');
    }
}