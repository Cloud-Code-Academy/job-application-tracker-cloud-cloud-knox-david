global class JoobleApi implements Schedulable {
        
    global void execute(SchedulableContext sc) {
            JoobleJobService.getJobs();
    }
}