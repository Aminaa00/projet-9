global class AccountBatch implements Database.Batchable<sObject> {
    List<Account> accListToUpdate;

    global AccountBatch(List<Account> listToUpdate) {
        this.accListToUpdate = listToUpdate;
    }

    global Database.QueryLocator start(Database.BatchableContext info){
        return Database.getQueryLocator('SELECT Id FROM Account WHERE Id IN (SELECT AccountId FROM Order WHERE Status = \'Ordered\')');
    }

    global void execute(Database.BatchableContext info, List<Account> scope){      
        List<Account> accountToUpdate = AccountBatchHandler.updateAccount(scope);
        Database.SaveResult[] updateAcc = Database.update(accountToUpdate);
    }

    global void finish(Database.BatchableContext info) {
        System.debug('AccountBatch Failed');
    }
}