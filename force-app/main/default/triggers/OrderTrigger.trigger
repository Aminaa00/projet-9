trigger OrderTrigger on Order (before update, after update) {
	if(Trigger.isBefore && Trigger.isUpdate) {
		Order newOrder= trigger.new[0];
		newOrder.NetAmount__c = newOrder.TotalAmount - newOrder.ShipmentCost__c;
	}


	if(Trigger.isAfter && Trigger.isUpdate) {
		set<Id> setAccountIds = new set<Id>();
    
		for(integer i=0; i< trigger.new.size(); i++){
			Order newOrder= trigger.new[i];
		   
			Account acc = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id =:newOrder.AccountId ];
			acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + newOrder.TotalAmount;
			update acc;
		}
	}
}