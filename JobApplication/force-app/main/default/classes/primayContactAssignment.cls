public with sharing class primayContactAssignment {
 
    public Static void setPrimayContactAssignment(List<Job_Application__c> job, List<Contact> conToUpdate ) {
     
        // fetch Job application with Primary Contact null
        for(Job_Application__c j: job = [SELECT Id,	Primary_Contact__c FROM  Job_Application__c WHERE Id IN:job AND Primary_Contact__c = null]){
            // fetch all the contacts related to the company
            for(Contact con: [SELECT Id FROM Contact WHERE AccountId =:j.Company_Name__c]){
                // assign the contact to the job application
                j.Primary_Contact__c = con.Id;
                conToUpdate.add(con);
            } 
        }

        if(conToUpdate.size() > 0){
            update conToUpdate;
        }
    }
}