global class eventReminderScheduler implements Schedulable, Database.Batchable<SObject>, Database.Stateful {
    
    global void execute(SchedulableContext sc) {
        //Start batch job...
        Database.executeBatch(this, 200);
    }

    global Database.QueryLocator start (Database.BatchableContext bc) {
        Date tomorrow = Date.today().addDays(1);

        return Database.getQueryLocator([
            SELECT Id,
               Subject,
               StartDateTime, 
               EndDateTime, 
               OwnerId,
               Owner.Email, 
               WhatId 
            FROM Event 
            WHERE StartDateTime >= :tomorrow
            AND OwnerId != null
            ]);           
        
    }
        

    global void execute (Database.BatchableContext bc, List<Event> events) {
 
              
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        for(Event ev : events) {
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setToAddresses(new String[] { ev.OwnerId });
                email.setSubject('Reminder: You have an event coming up');
                email.setPlainTextBody('The event \'' + ev.Subject + '\' that starts at ' + ev.StartDateTime.format() + ' is coming up. Please don\'t forget to conduct company research and review the job description.');
                emailsToSend.add(email);
                        
        }

        if(emailsToSend.size() > 0) {
            Messaging.sendEmail(emailsToSend);       

        }
            System.debug(emailsToSend.size());      
            System.debug(Limits.getEmailInvocations());
            
    }

    global void finish(Database.BatchableContext bc) {
        //In the future I can add post processes logic here...
        System.debug('Batch job completed for event reminders..');
    
    }
}