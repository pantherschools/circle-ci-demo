/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-06-2022
 * @last modified by  : Amit Singh
**/
public with sharing class QBInvoiceInputWrapper {
    public Line[] Line;
	public CustomerRef CustomerRef;
	public class Line {
		public String DetailType;	//SalesItemLineDetail
		public Decimal Amount;	//100
		public SalesItemLineDetail SalesItemLineDetail;
	}
	public class SalesItemLineDetail {
		public ItemRef ItemRef;
	}
	public class ItemRef {
		public String name;	//Services
		public String value;	//1
	}
	public class CustomerRef {
		public String value;	//1
	}
}
