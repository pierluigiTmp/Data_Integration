@isTest
private class ProjectCalloutServiceTest {
    @testSetup static void setup() {
		ServiceTokens__c cs = new ServiceTokens__c();
        cs.Name = 'Test Token';
		cs.token__c = 'Test Value';
		insert cs;
        Account a = new Account(Name = 'Account Test');
        insert a;
        Opportunity o = new Opportunity(Name = 'Opportunity Test', CloseDate = System.today(), StageName = 'New Project', Amount = 5000, AccountId = a.id);
        insert o;
	}
    
    @isTest 
    static void testPostCallout_Success() {
        Opportunity o = [SELECT Id FROM Opportunity];
        List<ID> Id = new List<ID>{o.Id};
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(Id);
        Test.stopTest();
        Opportunity oUpdated = [SELECT StageName FROM Opportunity WHERE Id = :o.Id];
        System.assert(oUpdated.StageName == 'Submitted Project');
    }
    
    @isTest 
    static void testPostCallout_Failure() {
        Opportunity o = [SELECT Id FROM Opportunity];
        List<ID> Id = new List<ID>{o.Id};
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        Test.startTest();
        ProjectCalloutService.postOpportunityToPMS(Id);
        Test.stopTest();
        Opportunity oUpdated = [SELECT StageName FROM Opportunity WHERE Id = :o.Id];
        System.assert(oUpdated.StageName == 'Resubmit Project');
    }
    
    @isTest 
    static void testPostCallout_Queueable_Success() {
        Opportunity o = [SELECT Id FROM Opportunity];
        List<ID> Id = new List<ID>{o.Id};
        ProjectCalloutService.QueueablePMSCall job = new ProjectCalloutService.QueueablePMSCall(Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        System.enqueueJob(job);
        Test.stopTest();
        Opportunity oUpdated = [SELECT StageName FROM Opportunity WHERE Id = :o.Id];
        System.assert(oUpdated.StageName == 'Submitted Project');
    }
    
    @isTest 
    static void testPostCallout_Queueable_Failure() {
        Opportunity o = [SELECT Id FROM Opportunity];
        List<ID> Id = new List<ID>{o.Id};
        ProjectCalloutService.QueueablePMSCall job = new ProjectCalloutService.QueueablePMSCall(Id);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        System.enqueueJob(job);
        Test.stopTest();
        Opportunity oUpdated = [SELECT StageName FROM Opportunity WHERE Id = :o.Id];
        System.assert(oUpdated.StageName == 'Resubmit Project');
    }
    
    
    
}