@isTest
private class JoobleJobServiceTest {

    //Mock response for Jooble API...
    private class JoobleApiMock implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            //Create a mock response...
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');

            //Sample JSON response...
            String jsonResponse = '{"jobs": ['
                + '{"id": 12345, "title": "Salesforce Technical Lead", "salary": 150000, "link": "http://example.com/lead", "company": "Tech Solutions", "snippet": "Manage the technical aspects..."},'
                + '{"id": 67890, "title": "Salesforce Developer", "salary": 120000, "link": "http://example.com/dev", "company": "Code Factory", "snippet": "Develop and maintain Salesforce applications..."}'
                + ']}';
            res.setBody(jsonResponse);
            return res;
        }
    }

    @isTest
    static void testGetJobs() {

        //Set the mock callout...
        Test.setMock(HttpCalloutMock.class, new JoobleApiMock());

        //Call the future method...
        Test.startTest();
        JoobleJobService.getJobs();
        Test.stopTest();

        //Query the Job_Application__c records created by the service....
        List<Job_Application__c> jobApps = [
            SELECT Name, Salary__c, Url__c, Description__c, Jooble_Id__c, Current_Status__c 
            FROM Job_Application__c 
            WHERE Jooble_Id__c IN ('12345', '67890')
        ];

        //Check assertions...
        System.assertEquals(2, jobApps.size(), 'Two job applications should have been inserted.');

        //Verify first job application...
        Job_Application__c jobApp1 = jobApps[0];
        System.assertEquals('Salesforce Technical Lead', jobApp1.Name, 'Job title should match.');
        System.assertEquals(150000, jobApp1.Salary__c, 'Salary should match.');
        System.assertEquals('http://example.com/lead', jobApp1.Url__c, 'URL should match.');
        System.assert(jobApp1.Description__c.contains('Tech Solutions'), 'Description should include company name.');
        System.assert(jobApp1.Description__c.contains('Manage the technical aspects'), 'Description should include job snippet.');
        System.assertEquals('Saved', jobApp1.Current_Status__c, 'Job status should be set to "Saved".');

        //Verify second job application...
        Job_Application__c jobApp2 = jobApps[1];
        System.assertEquals('Salesforce Developer', jobApp2.Name, 'Job title should match.');
        System.assertEquals(120000, jobApp2.Salary__c, 'Salary should match.');
        System.assertEquals('http://example.com/dev', jobApp2.Url__c, 'URL should match.');
        System.assert(jobApp2.Description__c.contains('Code Factory'), 'Description should include company name.');
        System.assert(jobApp2.Description__c.contains('Develop and maintain Salesforce applications'), 'Description should include job snippet.');
        System.assertEquals('Saved', jobApp2.Current_Status__c, 'Job status should be set to "Saved".');
    }
}
