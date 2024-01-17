@isTest
public class OrderControllerTest{
    static testMethod void updateNetAmountTest(){
        List<Order> orderListToUptdate = new List<Order> ();
        Account acc = TestDataFactory.createAccount('TestAccount');
        Contract cont = TestDataFactory.createContract(acc.Id, Date.newInstance(2024, 3, 1));
        Product2 p = TestDataFactory.createProduct('TestProduct');
        Pricebook2 pricebook = TestDataFactory.createPricebook('Example Price Book');
        PricebookEntry standardPrice = TestDataFactory.createPricebookEntry(pricebook.Id, p.Id, 100);
        cont.Status = 'Activated';
        update cont;

        Test.startTest();
        List<Order> orders = new List<Order>();
            for (Integer i = 0; i < 200; i++){
                Order order = new Order(
                Name = 'Test Order ' + i,
                ShipmentCost__c = 7,
                AccountId = acc.Id,
                EffectiveDate = Date.newInstance(2024, 3, 1),
                Status = 'Draft',
                PriceBook2Id = Test.getStandardPricebookId()
                );
                orders.add(order);
            }
            insert orders;

        List<Order> ordersToUpdate = new List<Order>();
        List<OrderItem> orderItemsToInsert = new List<OrderItem>();
            for(Order orderr :orders) {
                orderr.Status = 'Ordered';
                ordersToUpdate.add(orderr);
                OrderItem lineItem = new OrderItem();
                lineItem.OrderId = orderr.id;
                lineItem.Quantity = 4;
                lineItem.UnitPrice = 6;
                lineItem.Product2id = p.id;
                lineItem.PricebookEntryId=standardPrice.id;
                orderItemsToInsert.add(lineItem);
            }
            insert orderItemsToInsert;
        Test.stopTest();

        List<Order> updatedOrders = [SELECT Id, TotalAmount, Status FROM Order WHERE Id IN :ordersToUpdate];
        Decimal totalAmountSum = 0;
        for (Order updatedOrder : updatedOrders) {
            totalAmountSum += updatedOrder.TotalAmount;
        }
        System.assertEquals(4800, totalAmountSum, 'Total amount of orders should be updated correctly');
    }
}