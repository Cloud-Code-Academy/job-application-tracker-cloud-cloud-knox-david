@isTest
private class JoobleApiTest {

    @isTest
    static void testScheduling() {
        //Schedule the job...
        String jobName = 'TestJoobleApiJob';
        String cronExp = '0 0 12 * * ?'; // Run at 12 PM every day
        Id jobId = System.schedule(jobName, cronExp, new JoobleApi());

        //Verify the job is scheduled...
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE Id = :jobId];
        System.assertEquals(cronExp, ct.CronExpression, 'Cron expression should match.');
        System.assertEquals(0, ct.TimesTriggered, 'The job should not have triggered yet.');
    }
}
