public with sharing class AccountBatchHandler {
    public static List<Account> updateAccount(List<Account> scope){
        List<Account> accToUpdate = new List<Account>();
        List<Id> accountIds = new List<Id>();
        for (Account acc : scope) {
            accountIds.add(acc.Id);
        }
        
        List<Order> listOrders = [SELECT Id, TotalAmount, AccountId FROM Order WHERE AccountId IN :accountIds];   
        for(Account myAccount : scope) {
            Decimal totalAmountForAccount = 0;
            for(Order order : listOrders) {
                if(order.AccountId == myAccount.Id){
                    totalAmountForAccount += order.TotalAmount;
                }
            }
            myAccount.Chiffre_d_affaire__c = totalAmountForAccount;
            accToUpdate.add(myAccount);
        }
        return accToUpdate;
    }
}