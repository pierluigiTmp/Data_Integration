@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(500);
        return response; 
    }
}