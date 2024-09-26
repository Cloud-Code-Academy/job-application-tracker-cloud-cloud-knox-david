@isTest
public class JoobleJobServiceTest {

    // Mock response for Jooble API...
    public class JoobleApiMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Create a mock response...
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setHeader('Content-Type', 'application/json');
            // Sample JSON response...
            String jsonResponse = '{"totalCount": 2, "jobs": [{"title": "Salesforce Technical Lead", "location": "Atlanta, GA", "snippet": "Manage the technical aspects..."},{"title": "Salesforce Developer", "location": "Savannah, GA", "snippet": "Develop and maintain Salesforce applications..."}]}';
            res.setBody(jsonResponse);
            return res;
        }
    }

    @isTest
    static void testGetJobs() {
        // Set the mock callout...
        Test.setMock(HttpCalloutMock.class, new JoobleApiMock());
        
        // Call the method...
        JoobleJobService.getJobs();

    }
}
