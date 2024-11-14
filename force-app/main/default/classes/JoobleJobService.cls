public class JoobleJobService {

    private final static String JOOBLE_API_KEY = '8e8e6f03-bc29-4092-84b9-ae41180b4ac5';
    private static final String JOOBLE_API_URL = 'https://jooble.org/api/';

    @future(callout=true)
    public static void getJobs() {
    
        // Filter criteria...
        String keyword = 'Salesforce';
        String location = 'Georgia';
        Date datecreatedfrom = Date.today().addDays(-1);
        Integer resultonpage = 2;

        // Prepare request payload...
        Map<String, Object> requestBody = new Map<String, Object>{
            'keywords' => keyword,
            'location' => location,
            'datecreatedfrom' => datecreatedfrom.year() + '-' + datecreatedfrom.month() + '-' + datecreatedfrom.day(),
            'resultonpage' => resultonpage
        };
    
        // Make HTTP request to Jooble API...
        HttpRequest request = new HttpRequest();
        request.setEndpoint(JOOBLE_API_URL + JOOBLE_API_KEY);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(JSON.serialize(requestBody));
    
        Http http = new Http();        
    
        try {
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                System.debug('Raw Response: ' + response.getBody());
    
                // Deserialize the JSON response...
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                if(jsonResponse.get('jobs') != null) {                    
                    List<Object> jobList = (List<Object>) jsonResponse.get('jobs');

                    List<Job_Application__c> jobApplications = new List<Job_Application__c>();

                    // Iterate over the jobList, casting each item to Map<String, Object>...
                    for(Object jobObj : jobList) {
                        Map<String, Object> job = (Map<String, Object>) jobObj;
                        Job_Application__c jobApplication = new Job_Application__c();
                        
                        jobApplication.Name = (String) job.get('title');
                        jobApplication.Salary__c = parseSalary(job.get('salary'));
                        jobApplication.Url__c = (String) job.get('link');
                        jobApplication.Description__c = ('Company: '+ job.get('company'))+ '' + removeHTMLChar(job.get('snippet'));
                        jobApplication.Jooble_Id__c = String.valueOf((Long) job.get('id'));
                        jobApplication.Current_Status__c = 'Saved';

                        jobApplications.add(jobApplication);                        
                    }

                    // Insert Job_Application__c records if the list is not empty...
                    if(jobApplications.size() > 0) {
                        try {
                            insert jobApplications;
                            System.debug('Inserted Job Applications: ' + jobApplications.size());
                        } catch (DmlException e) {
                            System.debug('Error inserting new job applications: ' + e.getMessage());
                        }                        
                    }             
                } else {
                    System.debug('No jobs found or error getting response.');
                }
            } else {
                System.debug('Error response from Jooble API: ' + response.getStatusCode());
            }                
        } catch (Exception e) {
            System.debug('Callout error: ' + e.getMessage());
        }
        
    }
    
    //Helper Class to Parse Salary...
    private static Decimal parseSalary(Object salary) {
        if (salary instanceof Decimal) {
            return (Decimal) salary;
        } else if (salary instanceof Integer) {
            return Decimal.valueOf((Integer) salary);
        } else if (salary instanceof Long) {
            return Decimal.valueOf((Long) salary);
        } else if (salary instanceof String) {
            try {
                return Decimal.valueOf((String) salary);
            } catch (Exception e) {
                System.debug('Failed to parse salary: ' + salary);
            }
        }
        return null;
    }

    private static String removeHTMLChar(Object snippet) {
        String description = (String) snippet;        
        return description.replaceAll('&nbsp;', ' ').replaceAll('&amp;', '&').replaceAll('<[^>]*>', '');
    }
}