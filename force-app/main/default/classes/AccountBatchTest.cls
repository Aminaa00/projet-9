@isTest
public class AccountBatchTest {
    static testMethod void updateAccountTest() {
        List<Order> orderListToUpdateAccount = new List<Order> ();
        List<Order> newOrderListToUptdateAccount = new List<Order> ();
        Account acc = TestDataFactory.createAccount('TestAccount');
        Contract cont = TestDataFactory.createContract(acc.Id, Date.newInstance(2024, 3, 1));
        Product2 p = TestDataFactory.createProduct('TestProduct');
        Pricebook2 pricebook = TestDataFactory.createPricebook('Example Price Book');
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(pricebook.Id, p.Id, 100);

        Test.startTest();
        Order order = TestDataFactory.createOrder(acc.Id, cont.Id, pricebook.Id, Date.newInstance(2024, 3, 1));
        OrderItem lineItem = TestDataFactory.createOrderItem(order.Id, p.Id, standardPrice.Id);
        cont.status='Activated';
        update cont;
        order.Status='Ordered';
        update order;
        Order orderInserted= [SELECT Id, NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id =: order.id];
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        AccountBatch accBatch = new AccountBatch(updatedAccounts);
        Database.executeBatch(accBatch);
        Test.stopTest();
        
        List<Account> updatedAccounts2 = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2400, updatedAccounts2[0].Chiffre_d_affaire__c, 'Account Chiffre_d_affaire__c should be updated correctly');
    
    }

}