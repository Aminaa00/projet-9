public without sharing class OrderController{
    public OrderController(ApexPages.StandardController stdController){
    }
    public decimal SumOrders{
      get{
        AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order WHERE Status = 'Ordered'];
        return (decimal)groupedResults.get('total');
      }
      set;
    }
}