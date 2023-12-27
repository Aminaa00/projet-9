trigger OrderTrigger on Order (before update, after update) {
	OrderTriggerHandler ord = new OrderTriggerHandler ();
	if(Trigger.isBefore && Trigger.isUpdate) {
		ord.updateNetAmount(Trigger.new);
	}


	if(Trigger.isAfter && Trigger.isUpdate) {
		ord.updateAccount(Trigger.new);
	}
}