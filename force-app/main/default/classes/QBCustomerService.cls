public with sharing class QBCustomerService {

    //QBCustomerService.testCreateCustomer();
    public static void testCreateCustomer(){
        String customer  =		'{'+
		'  "FullyQualifiedName": "King Groceries", '+
		'  "PrimaryEmailAddr": {'+
		'    "Address": "jdrew@myemail.com"'+
		'  }, '+
		'  "DisplayName": "King\'s Groceries", '+
		'  "Suffix": "Jr", '+
		'  "Title": "Mr", '+
		'  "MiddleName": "B", '+
		'  "Notes": "Here are other details.", '+
		'  "FamilyName": "King", '+
		'  "PrimaryPhone": {'+
		'    "FreeFormNumber": "(555) 555-5555"'+
		'  }, '+
		'  "CompanyName": "King Groceries", '+
		'  "BillAddr": {'+
		'    "CountrySubDivisionCode": "CA", '+
		'    "City": "Mountain View", '+
		'    "PostalCode": "94042", '+
		'    "Line1": "123 Main Street", '+
		'    "Country": "USA"'+
		'  }, '+
		'  "GivenName": "James"'+
		'}';
        QBCustomerWrapper wrapper = (QBCustomerWrapper)JSON.deserialize(customer, QBCustomerWrapper.class);
        createCustomer(wrapper);
    }
    public static void createCustomer(QBCustomerWrapper wrapper){
        HttpRequest request = QBUtils.prepareRequest('POST', '/v3/company/'+System.Label.QBCompanyId+'/customer?minorversion=63', JSON.serialize(wrapper));
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);
        if (response.getStatusCode() == 200) {

        }else{

        }
    }

    public static void queryCustomers(String query){
        if(String.isBlank(query)){
            query = 'select * from Customer Where Metadata.LastUpdatedTime > \'2015-03-01\' ';
        }
        HttpRequest request = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/query?query='+EncodingUtil.urlEncode(query,'UTF-8')+'&minorversion=63', '');
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        if (response.getStatusCode() == 200) {
            System.System.debug(responseBody);
        }else{

        }
    }
    //QBCustomerService.querySingleCustomer('20');
    public static void querySingleCustomer(String customerId){
        HttpRequest request = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/customer/'+customerId+'?minorversion=63', '');
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);
        if (response.getStatusCode() == 200) {
        }else{

        }
    }

    public class QBCustomerWrapper {
        public String FullyQualifiedName;
        public PrimaryEmailAddr PrimaryEmailAddr;
        public String DisplayName;
        public String Suffix;
        public String Title;
        public String MiddleName;
        public String Notes;
        public String FamilyName;
        public PrimaryPhone PrimaryPhone;
        public String CompanyName;
        public BillAddr BillAddr;
        public String GivenName;
    }

    public class PrimaryEmailAddr {
		public String Address;
	}
	public class PrimaryPhone {
		public String FreeFormNumber;
	}
	public class BillAddr {
		public String CountrySubDivisionCode;
		public String City;
		public String PostalCode;
		public String Line1;
		public String Country;
	}
}