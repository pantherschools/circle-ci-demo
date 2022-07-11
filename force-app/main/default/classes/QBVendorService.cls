/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-06-2022
 * @last modified by  : Amit Singh
**/
public with sharing class QBVendorService {
    
    /*
        String json =		'{'+
		'  "PrimaryEmailAddr": {'+
		'    "Address": "dbradley@myemail.com"'+
		'  }, '+
		'  "WebAddr": {'+
		'    "URI": "http://DiannesAutoShop.com"'+
		'  }, '+
		'  "PrimaryPhone": {'+
		'    "FreeFormNumber": "(650) 555-2342"'+
		'  }, '+
		'  "DisplayName": " Auto Shop", '+
		'  "Suffix": "Sr.", '+
		'  "Title": "Ms.", '+
		'  "Mobile": {'+
		'    "FreeFormNumber": "(650) 555-2000"'+
		'  }, '+
		'  "FamilyName": "Bradley", '+
		'  "TaxIdentifier": "99-5688293", '+
		'  "AcctNum": "35372649", '+
		'  "CompanyName": "Auto Shop", '+
		'  "BillAddr": {'+
		'    "City": "Millbrae", '+
		'    "Country": "U.S.A", '+
		'    "Line3": "29834 Mustang Ave.", '+
		'    "Line2": "Dianne Bradley", '+
		'    "Line1": "Auto Shop", '+
		'    "PostalCode": "94030", '+
		'    "CountrySubDivisionCode": "CA"'+
		'  }, '+
		'  "GivenName": "Dianne", '+
		'  "PrintOnCheckName": "Auto Shop"'+
		'}';
        QBVendorWrapper wrapper = (QBVendorWrapper)System.JSON.deserialize(json, QBVendorWrapper.class);
        QBVendorService.createVendor(wrapper);

    */
    public static Map<String, Object> createVendor(QBVendorWrapper wrapper){

		Map<String, Object> resonseMap = new Map<String, Object>();
        HttpRequest request = QBUtils.prepareRequest('POST', '/v3/company/'+System.Label.QBCompanyId+'/vendor?minorversion=63', JSON.serialize(wrapper));
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(' responseBody \n '+ responseBody);
        if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
            System.debug(' Record is created \n ');
			resonseMap.put('status','SUCCESS');
            QBVendorService vendorRecord = (QBVendorService)System.JSON.deserialize(responseBody, QBVendorService.class);
            System.debug(vendorRecord.Vendor.Id);
			resonseMap.put('data',vendorRecord);
        }else{
			resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Creating Vendor in QBO', 'QBVendorService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
		return resonseMap;
    }
    // QBVendorService.readVendor('60');
    public static Map<String, Object> readVendor(String vendorId){

		Map<String, Object> resonseMap = new Map<String, Object>();

        QBVendorService vendorRecord = new QBVendorService();
        HttpRequest request = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/vendor/'+vendorId+'?minorversion=63', null);
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        String finalBody = responseBody.replace('Long','Longitude');
        System.System.debug(' Response from Quickbooks \n ' + finalBody);
        if (response.getStatusCode() == 200) {
			resonseMap.put('status','SUCCESS');
            vendorRecord = (QBVendorService)System.JSON.deserialize(responseBody, QBVendorService.class);
			resonseMap.put('data',vendorRecord);
            System.debug(vendorRecord.Vendor.Id);
        }else{
			resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Reading Vendor in QBO', 'QBVendorService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
        return resonseMap;
    }

    public Vendor Vendor;

	public class Vendor {
		public PrimaryEmailAddr PrimaryEmailAddr;
		public boolean Vendor1099;
		public String domain;	//QBO
		public String GivenName;	//Bessie
		public String DisplayName;	//Books by Bessie
		public BillAddr BillAddr;
		public String SyncToken;	//0
		public String PrintOnCheckName;	//Books by Bessie
		public String FamilyName;	//Williams
		public PrimaryPhone PrimaryPhone;
		public String AcctNum;	//1345
		public String CompanyName;	//Books by Bessie
		public WebAddr WebAddr;
		public boolean sparse;
		public boolean Active;
		public Integer Balance;	//0
		public String Id;	//30
		public MetaData MetaData;
	}
	public class PrimaryEmailAddr {
		public String Address;	//Books@Intuit.com
	}
	public class BillAddr {
		public String City;	//Palo Alto
		public String Line1;	//15 Main St.
		public String PostalCode;	//94303
		public String Lat;	//37.445013
		public String Longitude;	//-122.1391443
		public String CountrySubDivisionCode;	//CA
		public String Id;	//31
	}
	public class PrimaryPhone {
		public String FreeFormNumber;	//(650) 555-7745
	}
	public class WebAddr {
		public String URI;	//http://www.booksbybessie.co
	}
	public class MetaData {
		public String CreateTime;	//2014-09-12T10:07:56-07:00
		public String LastUpdatedTime;	//2014-09-17T11:13:46-07:00
	}
}
