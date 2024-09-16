public class asynCleanStaleJobs implements Queueable {
    public void execute(QueueableContext context) {
        // Query all job applications to be processed (assumed to be queried outside the loop)
        List<Job_Application__c> job = [SELECT Id, CreatedDate, Current_Status__c FROM Job_Application__c];

        for (Job_Application__c jb : job) {
            // Check if CreatedDate is 30 days or older and status is not 'Closed' or 'Accepted'
            if (jb.CreatedDate <= System.today().addDays(-30) && jb.Current_Status__c != 'Closed' && jb.Current_Status__c != 'Accepted') {
                jb.Current_Status__c = 'Closed';
                jb.Notes__c = 'Automatically closed if job is not updated after 30 days';
            }
        }

        // Update the records outside the loop
        update job;
    }
}
