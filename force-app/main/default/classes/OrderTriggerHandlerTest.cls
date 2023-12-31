@isTest
public class OrderTriggerHandlerTest {
    static testMethod void updateNetAmountTest() {
        OrderTriggerHandler ord = new OrderTriggerHandler ();
            List<Order> orderListToUptdate = new List<Order> ();
            Account acc = new Account (Name = 'AccountName');
            insert acc;
            Contract cont = new Contract(AccountId = acc.Id, Status = 'Draft', StartDate = Date.newInstance(2024, 3, 1), ContractTerm = 1);
            insert cont;

            //Jeans,jogging...
            Product2 p = new Product2();
            p.Name = ' Test Product ';
            p.Description='Test Product Entry For Product';
            p.productCode = 'SFDCPanther-123';
            p.isActive = true;
            insert p;


            Pricebook2 priceBook = new Pricebook2(
            Name = 'Example Price Book',
            Description = 'This is the Price Book description.',
            IsActive = true );
            insert priceBook;

            PricebookEntry standardPrice = new PricebookEntry();
            standardPrice.Pricebook2Id = Test.getStandardPricebookId();
            standardPrice.Product2Id = p.Id;
            standardPrice.UnitPrice = 100;
            standardPrice.IsActive = true;
            standardPrice.UseStandardPrice = false;
            insert standardPrice ;


            Test.startTest();
            Order order = new Order(Name = 'Test', ShipmentCost__c = 7, AccountId = acc.Id, EffectiveDate = Date.newInstance(2024, 3, 1), ContractId = cont.Id, Status = 'Draft', PriceBook2Id = Test.getStandardPricebookId());
            insert order;

            //ORDER = ORDERITEM = commande / PRODUCT2=PRODUCT / PRICEBOOK / PRICEBOOKENTRY
            // OrderItem (ci-dessous) = Order Product (sur SF)
            // Lien entre produit & Order
            OrderItem lineItem = new OrderItem();
            lineItem.OrderId = order.id;
            lineItem.Quantity = 24;
            lineItem.UnitPrice = 240;
            lineItem.Product2id = p.id;
            lineItem.PricebookEntryId=standardPrice.id;
            insert lineItem;


            orderListToUptdate.add(order);
            ord.updateNetAmount(orderListToUptdate);
            Test.stopTest();
            //Order orderItem = new Order(Name = 'Test', TotalAmount = 20, ShipmentCost__c = 7, AccountId = acc.Id, EffectiveDate = Date.newInstance(2024, 3, 1), ContractId = cont.Id, Status = 'Draft');

            Order orderUpdated= [SELECT Id, NetAmount__c FROM Order WHERE Id =: order.id];
            system.assertEquals(orderUpdated.NetAmount__c, ((lineItem.Quantity * lineItem.UnitPrice) - order.ShipmentCost__c), 'erreur');
        //order.NetAmount__c = order.TotalAmount - order.ShipmentCost__c;
    }
}