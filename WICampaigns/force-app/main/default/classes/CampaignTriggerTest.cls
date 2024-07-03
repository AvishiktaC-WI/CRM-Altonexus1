@isTest
public class CampaignTriggerTest {
    // @testSetup
    // static void setup() {
    //     // Create PR Campaign record type
    //     RecordType prCampaignRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Campaign' AND DeveloperName = 'PR_Campaign' LIMIT 1];

    //     // Create test data that can be used in multiple test methods
    //     List<Campaign> campaigns = new List<Campaign>();
    //     for (Integer i = 0; i < 5; i++) {
    //         campaigns.add(new Campaign(
    //             Name = 'Test Campaign ' + i,
    //             RecordTypeId = prCampaignRecordType.Id,
    //             StartDate = Date.today().addDays(i),
    //             EndDate = Date.today().addDays(i + 10)
    //         ));
    //     }
    //     insert campaigns;
    // }

    // @isTest
    // static void testDuplicateCampaignCreationAndUpdate() {
    //     RecordType prCampaignRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'Campaign' AND DeveloperName = 'PR_Campaign' LIMIT 1];

    //     Campaign campaign1 = new Campaign(
    //         Name = 'Duplicate Campaign',
    //         RecordTypeId = prCampaignRecordType.Id,
    //         StartDate = Date.today(),
    //         EndDate = Date.today().addDays(10)
    //     );
    //     Campaign campaign2 = new Campaign(
    //         Name = 'Duplicate Campaign',
    //         RecordTypeId = prCampaignRecordType.Id,
    //         StartDate = Date.today(),
    //         EndDate = Date.today().addDays(10)
    //     );

    //     insert new List<Campaign>{campaign1, campaign2};

    //     List<c2g__codaDimension3__c> dimensions = [SELECT Name, c2g__ReportingCode__c FROM c2g__codaDimension3__c WHERE Name = 'Duplicate Campaign'];
    //     System.assertEquals(1, dimensions.size(), 'Expected only one dimension record for the duplicate name.');

    //     campaign1 = [SELECT Id, Name, StartDate, EndDate FROM Campaign WHERE Name = 'Duplicate Campaign' LIMIT 1];
    //     campaign1.Name = 'Updated Duplicate Campaign';
    //     campaign1.StartDate = campaign1.StartDate.addDays(1);
    //     campaign1.EndDate = campaign1.EndDate.addDays(1);
    //     update campaign1;

    //     dimensions = [SELECT Name, c2g__ReportingCode__c FROM c2g__codaDimension3__c WHERE Name = 'Updated Duplicate Campaign'];
    //     System.assertEquals(1, dimensions.size(), 'Expected one updated dimension record.');
    //     System.assertEquals(campaign1.AG_Dimension_Reporting_Code__c, dimensions[0].c2g__ReportingCode__c, 'Expected updated reporting code.');
    // }

    // @isTest
    // static void testDeleteCampaign() {
    //     List<Campaign> campaignsToDelete = [SELECT Id, Name FROM Campaign LIMIT 5];
    //     delete campaignsToDelete;

    //     List<c2g__codaDimension3__c> dimensions = [SELECT Name, c2g__ReportingCode__c FROM c2g__codaDimension3__c WHERE Name LIKE 'Test Campaign %'];
    //     System.assertEquals(5, dimensions.size(), 'Expected 5 dimension records to remain after deletion.');
    //     for (c2g__codaDimension3__c dimension : dimensions) {
    //         System.assertNotEquals(null, dimension.c2g__ReportingCode__c, 'Reporting Code should not be null after deletion.');
    //     }
    // }

}