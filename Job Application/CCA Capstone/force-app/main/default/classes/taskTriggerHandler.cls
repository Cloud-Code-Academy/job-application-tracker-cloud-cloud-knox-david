public with sharing class taskTriggerHandler {
    
    public static void appStatus(List<Job_Application__c> jobApplications) {
        // List to hold tasks to insert
        List<Task> taskToInsert = new List<Task>();
        
        // Loop through Job Applications and check status
        for (Job_Application__c jb : jobApplications) {
            if (jb.Current_Status__c == 'Saved') {
                
                Task tk1 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Check if the Job description aligns with your interests values', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk2 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Review the highlighted skills to see if the role is a good fit',
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk3 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Research the company or role and mark your excitement level', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);
                
                // Add tasks to the list
                taskToInsert.add(tk1);
                taskToInsert.add(tk2);
                taskToInsert.add(tk3);
            }
            if (jb.Current_Status__c == 'Applying'){
                Task tk1 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Find and research someone who works at the company and add them as a contacts', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk2 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Set up an informational interview to learn more about the role/company', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk3 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Identify potential referrals to help get your application on the top of the pile', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk4 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Work achievements using the job description keywordsCustomize your', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk5 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Submit your application on the company website, if possible', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);
                
                taskToInsert.add(tk1);
                taskToInsert.add(tk2);
                taskToInsert.add(tk3);
                taskToInsert.add(tk4);
                taskToInsert.add(tk5);

            }
            if (jb.Current_Status__c == 'Applied'){
                Task tk1 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Reach out to the hiring manager or recruiter', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk2 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Follow up on your application via email weekly', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk3 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Continue identifying and saving similar job opportunities', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk4 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Set up weekly networking calls to explore similar companies/roles', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);
                
                taskToInsert.add(tk1);
                taskToInsert.add(tk2);
                taskToInsert.add(tk3);
                taskToInsert.add(tk4);
            }
            if (jb.Current_Status__c == 'Interviewing'){
                Task tk1 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Prepare your blurb or “tell me about yourself” response', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk2 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Practice answering behavioral interview questions', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk3 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Research the company and your interviewers', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk4 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Set up your virtual interview space and test your tech', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk5 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Send thank you emails within 24 hours', 
                    ActivityDate = Date.Today() + 1, 
                    WhatId = jb.Id);
            
                taskToInsert.add(tk1);
                taskToInsert.add(tk2);
                taskToInsert.add(tk3);
                taskToInsert.add(tk4);
                taskToInsert.add(tk5);
            }
            if (jb.Current_Status__c == 'Negotiating'){
                Task tk1 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Research your market value and know your numbers', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk2 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Prepare your negotiation scripts', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk3 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Prepare your negotiation scriptss', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);               
            
                taskToInsert.add(tk1);
                taskToInsert.add(tk2);
                taskToInsert.add(tk3);
            }            
            if (jb.Current_Status__c == 'Accepted'){
                Task tk1 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Plan your resignation if applicable', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk2 = new Task(OwnerId = jb.CreatedById, 
                    Subject = 'Take some time to relax and recharg', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk3 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Prepare for your first day of onboarding', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);               
            
                taskToInsert.add(tk1);
                taskToInsert.add(tk2);
                taskToInsert.add(tk3);
            }
            if (jb.Current_Status__c == 'Closed'){
                Task tk1 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Send a follow-up email thanking the interviewer and asking for feedback', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);

                Task tk2 = new Task(
                    OwnerId = jb.CreatedById, 
                    Subject = 'Review your notes and reflect on areas of improvement', 
                    ActivityDate = Date.Today() + 5, 
                    WhatId = jb.Id);             
            
                taskToInsert.add(tk1);
                taskToInsert.add(tk2);
            }       
        
    }
    // Insert tasks if the list is not empty
    if (!taskToInsert.isEmpty()) {
        try {
        insert taskToInsert;
        System.debug('Tasks inserted successfully.');
        } catch (DmlException e) {
        System.debug('Error inserting tasks: ' + e.getMessage());
        }
    } 
  }
}