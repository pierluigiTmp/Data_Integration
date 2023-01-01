@isTest
private class ProjectRESTServiceTest {
	
    @isTest 
    static void testPOSTService_Success() {
    	Opportunity parentOpp = new Opportunity(Name = 'Test', CloseDate = Date.newInstance(2023, 12, 22), StageName = 'Prospecting', DeliveryInstallationStatus__c = 'Yet to Begin');
        insert parentOpp;
        String ProjectRef = 'TESTESTESTEST123456';
        String ProjectName = 'Test Project';
        String OpportunityId = parentOpp.Id;
        Date StartDate = Date.newInstance(2022, 12, 22);
        Date EndDate = Date.newInstance(2023, 2, 22);
        Double Amount = 67890.09;
        String Status = 'Running';
        Test.startTest();
        String response = ProjectRESTService.postProjectData(ProjectRef, ProjectName, OpportunityId, StartDate, EndDate, Amount, Status);
        Test.stopTest();
        System.assertEquals(response, 'OK');
    }
    
    @isTest 
    static void testPOSTService_DMLException() {
    	Opportunity parentOpp = new Opportunity(Name = 'Test', CloseDate = Date.newInstance(2023, 12, 22), StageName = 'Prospecting', DeliveryInstallationStatus__c = 'Yet to Begin');
        insert parentOpp;
        String ProjectRef = 'TESTESTESTEST123456';
        String ProjectName = 'Test Project';
        String OpportunityId = parentOpp.Id;
        Date StartDate = Date.newInstance(2022, 12, 22);
        Date EndDate = Date.newInstance(2023, 2, 22);
        Double Amount = 67890.09;
        String Status = 'Running';
        Test.startTest();
        delete parentOpp;
        String response = ProjectRESTService.postProjectData(ProjectRef, ProjectName, OpportunityId, StartDate, EndDate, Amount, Status);
        Test.stopTest();
        System.assertNotEquals(response, 'OK');
    }
}