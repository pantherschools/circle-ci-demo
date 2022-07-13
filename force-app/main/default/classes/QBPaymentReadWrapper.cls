/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-11-2022
 * @last modified by  : Amit Singh
**/
public with sharing class QBPaymentReadWrapper {
    public Payment Payment;
	public class Payment {
		public CustomerRef CustomerRef;
		public DepositToAccountRef DepositToAccountRef;
		public PaymentMethodRef PaymentMethodRef;
		public Integer TotalAmt;
		public Integer UnappliedAmt;
		public boolean ProcessPayment;
		public String domain;
		public boolean sparse;
		public String Id;
		public String SyncToken;
		public MetaData MetaData;
		public String TxnDate;
		public CurrencyRef CurrencyRef;
		public LinkedTxn[] LinkedTxn;
		public Line[] Line;
	}
	public class CustomerRef {
		public String value;
		public String name;
	}
	public class DepositToAccountRef {
		public String value;
	}
	public class PaymentMethodRef {
		public String value;
	}
	public class MetaData {
		public String CreateTime;
		public String LastUpdatedTime;
	}
	public class CurrencyRef {
		public String value;
		public String name;
	}
	public class LinkedTxn {
		public String TxnId;
		public String TxnType;
	}
	public class Line {
		public Integer Amount;
		public LinkedTxn[] LinkedTxn;
	}
	public class value {
		public String Name;
		public String Value;
	}
}
