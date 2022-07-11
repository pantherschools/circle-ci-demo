/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-06-2022
 * @last modified by  : Amit Singh
**/
public with sharing class QBBillResponseWrapper {
    public Bill Bill;
	public class Bill {
		public String DueDate;	//2022-07-05
		public Decimal Balance;	//200
		public String domain;	//QBO
		public boolean sparse;
		public String Id;	//145
		public String SyncToken;	//0
		public MetaData MetaData;
		public String TxnDate;	//2022-07-05
		public CurrencyRef CurrencyRef;
		public Line[] Line;
		public VendorRef VendorRef;
		public APAccountRef APAccountRef;
		public Decimal TotalAmt;	//200
	}
	public class MetaData {
		public String CreateTime;	//2022-07-05T01:22:13-07:00
		public LastModifiedByRef LastModifiedByRef;
		public String LastUpdatedTime;	//2022-07-05T01:22:13-07:00
	}
	public class LastModifiedByRef {
		public String value;	//9130354254186146
	}
	public class CurrencyRef {
		public String value;	//USD
		public String name;	//United States Dollar
	}
	public class Line {
		public String Id;	//1
		public Integer LineNum;	//1
		public Decimal Amount;	//200
		public LinkedTxn[] LinkedTxn;
		public String DetailType;	//AccountBasedExpenseLineDetail
		public AccountBasedExpenseLineDetail AccountBasedExpenseLineDetail;
	}
	public class LinkedTxn {
	}
	public class AccountBasedExpenseLineDetail {
		public AccountRef AccountRef;
		public String BillableStatus;	//NotBillable
		public TaxCodeRef TaxCodeRef;
	}
	public class AccountRef {
		public String value;	//7
		public String name;	//Advertising
	}
	public class TaxCodeRef {
		public String value;	//NON
	}
	public class VendorRef {
		public String value;	//56
		public String name;	//Bob's Burger Joint
	}
	public class APAccountRef {
		public String value;	//33
		public String name;	//Accounts Payable (A/P)
	}
}
