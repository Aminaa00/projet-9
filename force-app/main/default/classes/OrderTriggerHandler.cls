public with sharing class OrderTriggerHandler {
    public void updateNetAmount(List<Order> orderList) {
        for(Order order: orderList) {
            order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
        }       
    }
  
    public void updateAccount(List<Order> oldOrderList, List<Order> newOrderList ) {
        Set<Id> accIdsToUpdate = new Set<Id>();

        List<Order> orderListToWork =  new List<Order>();
        Set<Id> accIds = new Set<Id>();

        for(Integer i = 0; i<newOrderList.size(); i++){
            if(newOrderList[i].Status=='Ordered' && newOrderList[i].Status!=oldOrderList[i].Status){
                orderListToWork.add(newOrderList[i]);
                accIds.add(newOrderList[i].AccountId);
            }
        }

        List<Account> accList= [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id IN: accIds];
        List<Account> accListToUpdate= new List<Account> ();

        for(Order ord:orderListToWork){
            for(Account acc: accList) {
                if(ord.AccountId==acc.Id){
                    acc.Chiffre_d_affaire__c = acc.Chiffre_d_affaire__c + ord.TotalAmount;
                    accListToUpdate.add(acc);
                }
            }
        }
        if (!accListToUpdate.isEmpty()) {
            Database.update(accListToUpdate, false);
        }
    }
}