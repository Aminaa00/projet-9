trigger OrderTrigger on Order (before update, after update) {
	OrderTriggerHandler orderTH = new OrderTriggerHandler();
	
	if(Trigger.isBefore ) {
		orderTH.updateNetAmount(Trigger.New);		
	}

	if (Trigger.isAfter){
		orderTH.updateAccount(Trigger.old, Trigger.New);
	}
}