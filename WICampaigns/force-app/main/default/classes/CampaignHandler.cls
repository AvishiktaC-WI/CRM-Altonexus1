public class CampaignHandler {

    public static void handleCampaignsInsert(List<Campaign> campaignList) {
        
        // Store new Campaign Names along with Reporting Code
        Map<String, String> newCampaignNames = new Map<String, String>();
        for (Campaign c : campaignList) {
            newCampaignNames.put(c.Name,c.AG_Dimension_Reporting_Code__c);
        }

        List<c2g__codaDimension3__c> existingEventNames = [SELECT Name, c2g__ReportingCode__c FROM c2g__codaDimension3__c WHERE Name IN: newCampaignNames.keySet()];

        Set<String> existingCampaignNames = new Set<String>();
        for (c2g__codaDimension3__c c : existingEventNames) {
            existingCampaignNames.add(c.Name);
        }

        List<c2g__codaDimension3__c> newEventNames = new List<c2g__codaDimension3__c>();

        for (String c : newCampaignNames.keySet()) {
            if (!existingCampaignNames.contains(c)) {
                c2g__codaDimension3__c newEventName = new c2g__codaDimension3__c(Name = c, c2g__ReportingCode__c = newCampaignNames.get(c));
                newEventNames.add(newEventName);
            }
        }

        if (!newEventNames.isEmpty()) {
            insert newEventNames;
        }

    }

    public static void handleCampaignsUpdate(List<Campaign> campaignList, Map<Id, Campaign> oldCampaignMap) {
        Map<String, String> namesMap = new Map<String, String>();
        Map<String, Campaign> newCMap = new Map<String, Campaign>();
        Map<String, Campaign> oldCMap = new Map<String, Campaign>();    
        List<String> newNamesToAdd = new List<String>();
    
        for (Campaign newCampaign : campaignList) { 
            Campaign oldCampaign = oldCampaignMap.get(newCampaign.Id);
            //if (newCampaign.Name != oldCampaign.Name) {
                namesMap.put(oldCampaign.Name, newCampaign.Name);
                oldCMap.put(oldCampaign.Name, oldCampaignMap.get(newCampaign.Id));
                newCMap.put(newCampaign.Name, newCampaign);
                newNamesToAdd.add(newCampaign.Name);            
            //}
        }
        System.debug(namesMap);
    
        List<Campaign> existingCampaigns = [SELECT Name, AG_Dimension_Reporting_Code__c, CreatedDate FROM Campaign WHERE Name IN :oldCMap.keySet() ORDER BY CreatedDate DESC];
    
        // Get existing latest old Campaigns and store count for each Campaign name
        Map<String, Campaign> lastestOldCampaignMap = new Map<String, Campaign>();
        Map<String,Integer> campaignCountMap = new Map<String,Integer>();
        for (Campaign c : existingCampaigns) {
            if (!lastestOldCampaignMap.containsKey(c.Name)) {
                lastestOldCampaignMap.put(c.Name, c);
                if(!campaignCountMap.containsKey(c.Name)) {
                    campaignCountMap.put(c.Name, 1);
                }   else {
                    Integer count = campaignCountMap.get(c.Name) + 1;
                    campaignCountMap.put(c.Name, count);
                }
            }
        }
    
        List<c2g__codaDimension3__c> eventsToInsert = new List<c2g__codaDimension3__c>();
        List<c2g__codaDimension3__c> eventsToUpdate = new List<c2g__codaDimension3__c>();
    
        List <c2g__codaDimension3__c> existingEvents = [SELECT Name, c2g__ReportingCode__c FROM c2g__codaDimension3__c WHERE Name IN :oldCMap.keySet() OR Name IN: newCMap.keySet() ORDER BY c2g__ReportingCode__c ASC];
    
        Map<String, Integer> existingCodesMap = new Map<String, Integer>();
        Map<String, c2g__codaDimension3__c> existingEventNamesMap = new Map<String, c2g__codaDimension3__c>();
    
        List<String> existingCodes = new List<String>();
    
        // Store existing events in Codes Map and Events map name-wise
        for (c2g__codaDimension3__c e : existingEvents) {
            System.debug(e.Name);
            String code = e.c2g__ReportingCode__c;
            Integer version = 0;
            if(code.containsIgnoreCase('-V'))   {
                version = (Integer.valueOf(code.substring(code.lastIndexOf('V')+1, code.length())));
                code = code.substring(0,(code.lastIndexOf('V'))-1);
            }
            existingCodes.add(code);
            existingCodesMap.put(code,version);
            existingEventNamesMap.put(e.Name, e);
            if (newNamesToAdd.contains(e.Name)) {
                newNamesToAdd.remove(newNamesToAdd.indexOf(e.Name));
            }
        }
    
        System.debug(newNamesToAdd);
    
        // Update Event Name for single Campaign, otherwise insert new Event Name
        for (String name : newNamesToAdd) {
            String code = newCMap.get(name).AG_Dimension_Reporting_Code__c;
            Integer version = 0;
            if (campaignCountMap.get(name) > 1) {
                if (existingCodes.contains(code)) {
                    version = existingCodesMap.get(code) + 1;
                    code += '-V'+version;
                }                
                System.debug(code);
                eventsToInsert.add(new c2g__codaDimension3__c(
                    Name = name, 
                    c2g__ReportingCode__c = code
                ));
            }   else {
                eventsToUpdate.add(new c2g__codaDimension3__c(
                    id = existingEventNamesMap.get(name).id,
                    Name = name
                ));
            }
        }
    
        System.debug(eventsToInsert.size());
        System.debug(eventsToUpdate.size());

        
        if (!eventsToUpdate.isEmpty()) {
            update eventsToUpdate;
        }

        if (!eventsToInsert.isEmpty()) {
            insert eventsToInsert;
        }
    }    
    
    public static void handleCampaignsDelete(List<Campaign> campaignList) {
        Set<String> campaignNamesToDelete = new Set<String>();
        for (Campaign c : campaignList) {
            campaignNamesToDelete.add(c.Name);
        }
    
        Map<String, Campaign> campaignsByEventName = new Map<String, Campaign>();
        for (Campaign c : [SELECT Name, AG_Dimension_Reporting_Code__c, CreatedDate
                           FROM Campaign 
                           WHERE Name IN :campaignNamesToDelete 
                           ORDER BY CreatedDate DESC]) {
            if (!campaignsByEventName.containsKey(c.Name)) {
                campaignsByEventName.put(c.Name, c);
            }
        }
    
        List<c2g__codaDimension3__c> eventsToUpdate = new List<c2g__codaDimension3__c>();
    
        for (c2g__codaDimension3__c eventName : [SELECT Id, Name FROM c2g__codaDimension3__c WHERE Name IN :campaignNamesToDelete]) {
            Campaign latestCampaign = campaignsByEventName.get(eventName.Name);
            if (latestCampaign != null) {
                eventName.c2g__ReportingCode__c = latestCampaign.AG_Dimension_Reporting_Code__c;
                eventsToUpdate.add(eventName);
            }
        }
    
        if (!eventsToUpdate.isEmpty()) {
            update eventsToUpdate;
        }
    }  
           
}