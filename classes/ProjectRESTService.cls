@RestResource(urlMapping='/project')
global with sharing class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status) {
        Project__c project = new Project__c();
        project.ProjectRef__c = ProjectRef;
        project.Name = ProjectName;                                   
        project.Opportunity__c = OpportunityId;                                   
        project.Start_Date__c = StartDate;
        project.End_Date__c = EndDate;
        project.Billable_Amount__c = Amount;   
        project.Status__c = Status;
        
        Savepoint sp = Database.setSavepoint();
        List<Opportunity> o = [SELECT DeliveryInstallationStatus__c FROM Opportunity WHERE Id = :OpportunityId LIMIT 1];
        if(!o.isEmpty()){
            o[0].DeliveryInstallationStatus__c = 'In progress';
        }
        try{
            upsert project project.ProjectRef__c;
            update o;
        }
        catch(DmlException e){
            Database.rollback(sp);
            return e.getMessage();
        }
        return 'OK';
    }
}