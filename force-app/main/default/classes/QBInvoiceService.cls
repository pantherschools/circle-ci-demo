/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-06-2022
 * @last modified by  : Amit Singh
**/
public with sharing class QBInvoiceService {
    
    /**
    * @description 
    * @author Amit Singh | 07-06-2022 
    * @return Map<String, Object> 
    **/

    /**
        String json =		'{'+
		'  "Line": ['+
		'    {'+
		'      "DetailType": "SalesItemLineDetail", '+
		'      "Amount": 100.0, '+
		'      "SalesItemLineDetail": {'+
		'        "ItemRef": {'+
		'          "name": "Services", '+
		'          "value": "1"'+
		'        }'+
		'      }'+
		'    }'+
		'  ], '+
		'  "CustomerRef": {'+
		'    "value": "1"'+
		'  }'+
		'}'; 
        QBInvoiceInputWrapper wrapper = (QBInvoiceInputWrapper)System.JSON.deserialize(json, QBInvoiceInputWrapper.class);
        QBInvoiceService.createInvoice(wrapper);
    */
    public static  Map<String, Object> createInvoice(QBInvoiceInputWrapper wrapper){

        Map<String, Object> resonseMap = new Map<String, Object>();
        HttpRequest request = QBUtils.prepareRequest('POST', '/v3/company/'+System.Label.QBCompanyId+'/invoice?minorversion=63', JSON.serialize(wrapper));
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();

        System.System.debug(' Response \n '+ responseBody);

        QBInvoiceService responseData = new QBInvoiceService();

        if (response.getStatusCode() == 200) {
            resonseMap.put('status','SUCCESS');
            responseData = (QBInvoiceService)System.JSON.deserialize(responseBody, QBInvoiceService.class);
            resonseMap.put('data',responseData);
        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Creating Invoice in QBO', 'QBInvoiceService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
        return resonseMap;
    }

    /**
    * @description 
    * @author Amit Singh | 07-06-2022 
    * @param String invoiceId 
    * @return Map<String, Object> 
    **/
    public static  Map<String, Object> readInvoice(String invoiceId){

        /* Prepare a Map for response */
        Map<String, Object> resonseMap = new Map<String, Object>();
        HttpRequest request = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/invoice/'+invoiceId+'?minorversion=63', null);
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        String finalBody  = responseBody.replaceAll('Long','Longitude');
        System.System.debug(responseBody);
        /* Store the reponse in QBBillResponseWrapper apes class */
        QBInvoiceService responseData = new QBInvoiceService();
        if (response.getStatusCode() == 200) {
            resonseMap.put('status','SUCCESS');
            responseData = (QBInvoiceService)System.JSON.deserialize(responseBody, QBInvoiceService.class);
            System.debug('responseData \n '+ System.JSON.serialize(responseData) );
            resonseMap.put('data',responseData);
        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Reading Invoice from QBO', 'QBInvoiceService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
            /* Save the Log into the System */
            /* log.log( UserInfo.getUserId(), responseBody, responseBody, ''); */
        }
        return resonseMap;
    }

	public static Map<String, Object> deleteInvoide(String invoiceId){
		Map<String, Object> resonseMap = new Map<String, Object>();
		return resonseMap;
	}

	public static Map<String, Object> downloadInvoideAsPdf(String invoiceId){
		Map<String, Object> resonseMap = new Map<String, Object>();
		HttpRequest request = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/invoice/'+invoiceId+'/pdf?minorversion=63', null);
        HttpResponse response = (new Http()).send(request);
		String responseBody = response.getBody();
		if (response.getStatusCode() == 200) {

		}else{
			resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Reading Invoice from QBO', 'QBInvoiceService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
		}
		return resonseMap;
	}

    /* Have the inner class & variable to store the invoice details */

    public Invoice Invoice;
	public class Invoice {
		public String TxnDate;	//2014-09-19
		public String domain;	//QBO
		public String PrintStatus;	//NeedToPrint
		public SalesTermRef SalesTermRef;
		public Double TotalAmt;	//362.07
		public Line[] Line;
		public String DueDate;	//2014-10-19
		public boolean ApplyTaxAfterDiscount;
		public String DocNumber;	//1037
		public boolean sparse;
		public CustomerMemo CustomerMemo;
		public Decimal Deposit;	//0
		public Decimal Balance;	//362.07
		public CustomerRef CustomerRef;
		public TxnTaxDetail TxnTaxDetail;
		public String SyncToken;	//0
		public LinkedTxn[] LinkedTxn;
		public BillEmail BillEmail;
		public ShipAddr ShipAddr;
		public String EmailStatus;	//NotSet
		public BillAddr BillAddr;
		public MetaData MetaData;
		public CustomField[] CustomField;
		public String Id;	//130
	}
	public class SalesTermRef {
		public String value;	//3
	}
	public class Line {
		public String Description;	//Rock Fountain
		public String DetailType;	//SalesItemLineDetail
		public SalesItemLineDetail SalesItemLineDetail;
		public Integer LineNum;	//1
		public Decimal Amount;	//275
		public String Id;	//1
	}
	public class SalesItemLineDetail {
		public TaxCodeRef TaxCodeRef;
		public Integer Qty;	//1
		public Decimal UnitPrice;	//275
		public ItemRef ItemRef;
	}
	public class TaxCodeRef {
		public String value;	//TAX
	}
	public class ItemRef {
		public String name;	//Rock Fountain
		public String value;	//5
	}
	public class CustomerMemo {
		public String value;	//Thank you for your business and have a great day!
	}
	public class CustomerRef {
		public String name;	//Sonnenschein Family Store
		public String value;	//24
	}
	public class TxnTaxDetail {
		public TxnTaxCodeRef TxnTaxCodeRef;
		public Double TotalTax;	//26.82
		public TaxLine[] TaxLine;
	}
	public class TxnTaxCodeRef {
		public String value;	//2
	}
	public class TaxLine {
		public String DetailType;	//TaxLineDetail
		public Decimal Amount;	//26.82
		public TaxLineDetail TaxLineDetail;
	}
	public class TaxLineDetail {
		public Double NetAmountTaxable;	//335.25
		public Integer TaxPercent;	//8
		public TaxRateRef TaxRateRef;
		public boolean PercentBased;
	}
	public class TaxRateRef {
		public String value;	//3
	}
	public class LinkedTxn {
		public String TxnId;	//100
		public String TxnType;	//Estimate
	}
	public class BillEmail {
		public String Address;	//Familiystore@intuit.com
	}
	public class ShipAddr {
		public String City;	//Middlefield
		public String Line1;	//5647 Cypress Hill Ave.
		public String PostalCode;	//94303
		public String Lat;	//37.4238562
		public String Longitude;	//-122.1141681
		public String CountrySubDivisionCode;	//CA
		public String Id;	//25
	}
	public class BillAddr {
		public String Line4;	//Middlefield, CA  94303
		public String Line3;	//5647 Cypress Hill Ave.
		public String Line2;	//Sonnenschein Family Store
		public String Line1;	//Russ Sonnenschein
		public String Longitude;	//-122.1141681
		public String Lat;	//37.4238562
		public String Id;	//95
	}
	public class MetaData {
		public String CreateTime;	//2014-09-19T13:16:17-07:00
		public String LastUpdatedTime;	//2014-09-19T13:16:17-07:00
	}
	public class CustomField {
		public String DefinitionId;	//1
		public String StringValue;	//102
		public String Name;	//Crew #
	}
}