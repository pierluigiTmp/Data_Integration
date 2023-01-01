public class BillingCalloutService {
    
    FINAL STATIC ServiceCredentials__c serviceCredentials =	ServiceCredentials__c.getOrgDefaults();
    
    @future(callout=true)
    public static void futureCallout(ID id) {
        Project__c p = [SELECT ProjectRef__c, Billable_Amount__c, Status__c FROM Project__c WHERE Id = :Id];
        BillingServiceProxy.project project = new BillingServiceProxy.project();
		project.username = serviceCredentials.Username__c;
		project.password = serviceCredentials.Password__c;
		project.billAmount = p.Billable_Amount__c;
		project.projectid = p.ProjectRef__c;
		BillingServiceProxy.InvoicesPortSoap11 invoice = new BillingServiceProxy.InvoicesPortSoap11();        
        String response = invoice.billProject(project);
        if(response == '201'){
            p.Status__c = 'Billed';
            update p;
        }
    }
    
    public static void callBillingService(Project__c p){
        if(p.Status__c == 'Billable'){
        	futureCallout(p.Id);
        }
    }
}