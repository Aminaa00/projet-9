public with sharing class OrderTriggerHandler {
    public void updateNetAmount(List<Order> orderList) {
        for(Order order: orderList) {
            system.debug(order);
		    order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
        }
    }

    public void updateAccount(List<Order> orderList) {
        Set<Id> accIds = new Set<Id>();

        for(Order ord : orderList) {
            accIds.add(ord.AccountId);
        }
        List<Account> accList= [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN: accIds];
        List<Account> accListToUpdate= new List<Account> ();
        for(Order ord:orderList){
        for(Account acc: accList) {
			acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + ord.TotalAmount;
            accListToUpdate.add(acc);
        }
	    }
        update accListToUpdate;
    }
}