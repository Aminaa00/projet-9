@isTest
public class TestDataFactory{
    public static Account createAccount(String accountName){
        Account acc = new Account (Name = accountName,Chiffre_d_affaire__c=0.00);
        insert acc;
        return acc;
    }

    public static Contract createContract(Id accountId, Date startDate){
        Contract cont = new Contract(AccountId = accountId, Status = 'Draft', StartDate = startDate, ContractTerm = 1);
        insert cont;
        return cont;
    }

    public static Product2 createProduct(String productName){
        Product2 p = new Product2();
        p.Name = productName;
        p.Description = 'Test Product Entry For Product';
        p.ProductCode = 'SFDCPanther-123';
        p.IsActive = true;
        insert p;
        return p;
    }

    public static Pricebook2 createPricebook(String pricebookName){
        Pricebook2 priceBook = new Pricebook2(
            Name = pricebookName,
            Description = 'This is the Price Book description.',
            IsActive = true
        );
        insert priceBook;
        return priceBook;
    }

    public static PricebookEntry createPricebookEntry(Id pricebookId, Id productId, Decimal unitPrice){
        Product2 p = createProduct('TestProduct');

        PricebookEntry standardPrice = new PricebookEntry();
        standardPrice.Pricebook2Id = Test.getStandardPricebookId();
        standardPrice.Product2Id = p.Id;
        standardPrice.UnitPrice = 100;
        standardPrice.IsActive = true;
        standardPrice.UseStandardPrice = false;
        insert standardPrice;
        return standardPrice;
    }

    public static Order createOrder(Id accountId, Id contractId, Id pricebookId, Date effectiveDate){
        Contract cont = [SELECT AccountId FROM Contract WHERE Id = :contractId LIMIT 1];
        Pricebook2 pricebook = createPricebook('Example Price Book');
        Product2 p = createProduct('TestProduct');
        PricebookEntry standardPrice = createPricebookEntry(pricebook.id, p.Id, 100);
        
        Order order = new Order(
            Name = 'Test',
            ShipmentCost__c = 7,
            AccountId = cont.AccountId,
            EffectiveDate = effectiveDate,
            ContractId = cont.Id,
            Status = 'Draft',
            NetAmount__c = 0,
            Pricebook2Id=standardPrice.Pricebook2Id 
          );
        insert order;
        return order;
    }

    public static OrderItem createOrderItem(Id orderId, Id productId, Id pricebookEntryId){
        Product2 p = createProduct('TestProduct');
        Pricebook2 pricebook = createPricebook('Example Price Book');
        PricebookEntry standardPrice = createPricebookEntry(pricebook.id, p.Id, 100);

        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = orderId;
        lineItem.Quantity = 24;
        lineItem.UnitPrice = standardPrice.UnitPrice;
        lineItem.Product2id = p.Id;
        lineItem.PricebookEntryId = standardPrice.Id;
        insert lineItem;
        return lineItem;
    }
}