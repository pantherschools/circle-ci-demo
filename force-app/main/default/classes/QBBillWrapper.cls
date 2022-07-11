/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-06-2022
 * @last modified by  : Amit Singh
**/
public with sharing class QBBillWrapper {
    
    public Line[] Line;
	public VendorRef VendorRef;
	public class Line {
		public String DetailType;	//AccountBasedExpenseLineDetail
		public Decimal Amount;	//200
		public String Id;	//1
		public AccountBasedExpenseLineDetail AccountBasedExpenseLineDetail;
	}
	public class AccountBasedExpenseLineDetail {
		public AccountRef AccountRef;
	}
	public class AccountRef {
		public String value;	//7
	}
	public class VendorRef {
		public String value;	//56
	}
}
