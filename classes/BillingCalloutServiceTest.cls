@isTest
private class BillingCalloutServiceTest {
    
    @isTest 
    static void testCalloutBilling_Success() {
        Opportunity opp = new Opportunity(Name = 'Test', CloseDate = System.today(), StageName = 'Prospecting');
        insert opp;
        Project__c project = new Project__c(Opportunity__c = opp.Id, ProjectRef__c = 'Test', Billable_Amount__c = 1.1, Status__c = 'Billable');
        insert project;
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
        Test.startTest();
        BillingCalloutService.callBillingService(project);
        Test.stopTest();
        Project__c updatedProject = [SELECT Status__c FROM Project__c WHERE Id = :project.Id];
        System.assertEquals(updatedProject.Status__c, 'Billed');
    }
    
    @isTest 
    static void testCalloutBilling_Failure() {
        Opportunity opp = new Opportunity(Name = 'Test', CloseDate = System.today(), StageName = 'Prospecting');
        insert opp;
        Project__c project = new Project__c(Opportunity__c = opp.Id, ProjectRef__c = 'Test', Billable_Amount__c = 1.1, Status__c = 'Billable');
        insert project;
        Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
        Test.startTest();
        BillingCalloutService.callBillingService(project);
        Test.stopTest();
        Project__c updatedProject = [SELECT Status__c FROM Project__c WHERE Id = :project.Id];
        System.assertNotEquals(updatedProject.Status__c, 'Billed');
    }
    
}