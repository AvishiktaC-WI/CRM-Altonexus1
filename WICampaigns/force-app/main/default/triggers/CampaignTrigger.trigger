trigger CampaignTrigger on Campaign (after insert, after update, after delete) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            CampaignHandler.handleCampaignsInsert(Trigger.new);
        } else if (Trigger.isUpdate) {
            CampaignHandler.handleCampaignsUpdate(Trigger.new, Trigger.oldMap);
        } else if (Trigger.isDelete) {
            CampaignHandler.handleCampaignsDelete(Trigger.old);
        }
    }
}