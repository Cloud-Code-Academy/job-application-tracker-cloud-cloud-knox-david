global class eventReminderScheduler implements Schedulable {
    
    global void execute(SchedulableContext sc) {
        sendEventReminders();
    }

    public static void sendEventReminders() {
        Date tomorrow = Date.today().addDays(1);

        List<Event> upcomingEvents = [SELECT Id,
                                            Subject,
                                            StartDateTime, 
                                            EndDateTime, 
                                            OwnerId,
                                            Owner.Email, 
                                            WhatId 
                                        FROM Event 
                                        WHERE StartDateTime >= :tomorrow
                                        AND OwnerId != null
                                       ];

        for(Event ev : upcomingEvents) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setToAddresses(new String[] {ev.Owner.Email});
            email.setToAddresses(new String [] {ev.OwnerId});
            email.setSubject('Reminder: You have an event coming up');
            email.setPlainTextBody('The event \'' + ev.Subject + '\' that starts at ' + ev.StartDateTime.format() + ' is coming up. Please don\'t forget to conduct company research and review the job description.');
            

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            System.debug(Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}));

        }
    }
}