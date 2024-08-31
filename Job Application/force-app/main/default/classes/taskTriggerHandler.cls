public with sharing class taskTriggerHandler {
    
    public static void appStatus(List<Job_Application__c> jobApplications) {
        // List to hold tasks to insert
        List<Task> taskToInsert = new List<Task>();
        
        // Loop through Job Applications and check status
        for (Job_Application__c jb : jobApplications) {
            if (jb.Current_Status__c == 'Saved') {
                // Create three tasks for the Job Application record
                Task tk1 = new Task(OwnerId = jb.CreatedById, Subject = 'Check if the Job description aligns with your interests values', ActivityDate = Date.Today() + 5, WhatId = jb.Id);
                Task tk2 = new Task(OwnerId = jb.CreatedById, Subject = 'Review the highlighted skills to see if the role is a good fit', ActivityDate = Date.Today() + 5, WhatId = jb.Id);
                Task tk3 = new Task(OwnerId = jb.CreatedById, Subject = 'Research the company or role and mark your excitement level', ActivityDate = Date.Today() + 5, WhatId = jb.Id);
                
                // Add tasks to the list
                taskToInsert.add(tk1);
                taskToInsert.add(tk2);
                taskToInsert.add(tk3);
            }
        }
        
        // Insert tasks if the list is not empty
        if (taskToInsert.size() > 0) {
            insert taskToInsert;
        }
    }
}
