public class JoobleJobService {

    private final static String JOOBLE_API_KEY = '8e8e6f03-bc29-4092-84b9-ae41180b4ac5';
    private static final String JOOBLE_API_URL = 'https://jooble.org/api/';

    public static void getJobs() {
    
        // Filter criteria...
        String keyword = 'Salesforce';
        String location = 'Georgia';
    
        // Prepare request payload...
        Map<String, Object> requestBody = new Map<String, Object>{
            'keywords' => keyword,
            'location' => location
        };
    
        // Make HTTP request to Jooble API...
        HttpRequest request = new HttpRequest();
        request.setEndpoint(JOOBLE_API_URL + JOOBLE_API_KEY);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        // Request body contains payload with search parameters...
        request.setBody(JSON.serialize(requestBody));
    
        Http http = new Http();
        List<Map<String, Object>> jobList = new List<Map<String, Object>>();
    
        try {
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                System.debug('Raw Response: ' + response.getBody());
    
                // Deserialize the JSON response
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
             
            }                
        } catch (Exception e) {
            System.debug('Callout error: ' + e.getMessage());
        }
        
    }
}


