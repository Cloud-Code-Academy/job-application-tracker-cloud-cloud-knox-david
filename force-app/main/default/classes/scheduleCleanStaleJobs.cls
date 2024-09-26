public class scheduleCleanStaleJobs implements Schedulable {
    public void execute(SchedulableContext context) {
       //enqueu job to delete stale jobs
        
        asynCleanStaleJobs cnjob = new asynCleanStaleJobs();
         System.enqueueJob(cnjob);
    }
}