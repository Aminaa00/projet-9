@isTest
public class OrderTriggerHandlerTest {
    static testMethod void updateNetAmountTest() {
        OrderTriggerHandler ord = new OrderTriggerHandler ();
        Account acc = TestDataFactory.createAccount('TestAccount');
        Contract cont = TestDataFactory.createContract(acc.Id, Date.newInstance(2024, 3, 1));
        Product2 p = TestDataFactory.createProduct('TestProduct');
        Pricebook2 pricebook = TestDataFactory.createPricebook('Example Price Book');
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(pricebook.Id, p.Id, 100);
        List<Order> orderListToUpdate = new List<Order> ();

        Test.startTest();
        Order order = TestDataFactory.createOrder(acc.Id, cont.Id, pricebook.Id, Date.newInstance(2024, 3, 1));
        OrderItem lineItem = TestDataFactory.createOrderItem(order.Id, p.Id, standardPrice.Id);
    
        cont.status='Activated';
        update cont;
        order.status='Ordered';
        update order;

        ord.updateNetAmount(orderListToUpdate);
        Order orderInserted= [SELECT Id, NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id =: order.id];
        OrderItem newOrderItem= [SELECT Id, Quantity, UnitPrice FROM OrderItem WHERE OrderId =: order.Id];
        
        Test.stopTest();
        System.assertEquals(orderInserted.NetAmount__c, ((newOrderItem.Quantity * newOrderItem.UnitPrice) - orderInserted.ShipmentCost__c), 'erreur');
    }

    
    static testMethod void updateAccountTest() {
        OrderTriggerHandler ord = new OrderTriggerHandler ();
        Account acc = TestDataFactory.createAccount('TestAccount');
        Contract cont = TestDataFactory.createContract(acc.Id, Date.newInstance(2024, 3, 1));
        Product2 p = TestDataFactory.createProduct('TestProduct');
        Pricebook2 pricebook = TestDataFactory.createPricebook('Example Price Book');
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(pricebook.Id, p.Id, 100);
        List<order> oldListOrder = new List<order>();
        List<order> newListOrder = new List<order>();

        Test.startTest();
        Order order = TestDataFactory.createOrder(acc.Id, cont.Id, pricebook.Id, Date.newInstance(2024, 3, 1));
        oldListOrder.add(order);
        OrderItem lineItem = TestDataFactory.createOrderItem(order.Id, p.Id, standardPrice.Id);
        cont.status='Activated';
        update cont;
        order.Status='Ordered';
        update order;
        newListOrder.add(order);
        Order orderInserted= [SELECT Id, NetAmount__c, TotalAmount, ShipmentCost__c FROM Order WHERE Id =: order.id];
        List<Account> updatedAccounts = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        ord.updateAccount(oldListOrder,newListOrder);
        Test.stopTest();
        
        List<Account> updatedAccounts2 = [SELECT Id, Chiffre_d_affaire__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2400, updatedAccounts[0].Chiffre_d_affaire__c, 'Account Chiffre_d_affaire__c should be updated correctly');
        }
}