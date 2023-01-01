public class ProjectCalloutService {
    
    FINAL STATIC String endpoint = 'callout:ProjectService';
    FINAL STATIC ServiceTokens__c serviceTokens = ServiceTokens__c.getOrgDefaults();
    
    //Inner class per lavori in coda async
    public class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        private List<ID> Id;
        public QueueablePMSCall(List<ID> Id) {
            this.Id = Id;
        }
        public void execute(QueueableContext context) {
            ProjectCalloutService.postOpportunityToPMS(Id);	        
        }
    }
    
    @InvocableMethod (label='Post Opportunity To PMS' description='POST opportunity trigger su sistema esterno PMS e aggiorna campi opportunity' category='Opportunity')
    public static void postOpportunityToPMS(List<Id> Id){
        Opportunity o = [SELECT Id, Name, CloseDate, Amount, Account.Name FROM Opportunity WHERE Id IN :Id];
        //Creazione body utilizzando i fields dell'opportunity param e serializzazione in json
        Map<String, Object> mapToSerialize = new Map<String, Object>();
        mapToSerialize.put('opportunityId', (String) o.Id);
        mapToSerialize.put('opportunityName', (String) o.Name);
        mapToSerialize.put('accountName', (String) o.Account.Name);
        mapToSerialize.put('closeDate', o.CloseDate);
        mapToSerialize.put('amount', o.Amount);
        String body = System.JSON.serialize((Object) mapToSerialize);
        //Callout a PMS 
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setHeader('token', serviceTokens.Token__c);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setBody(body);
        //Response da PMS e conseguente field update sull'opportunity trigger
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 201) {
            o.StageName = 'Submitted Project';
            update o;
        }
        else if(response.getStatusCode() == 500) {
            o.StageName = 'Resubmit Project';
            update o;
        } else {
            System.debug(response.getBody());
        }
    }
}