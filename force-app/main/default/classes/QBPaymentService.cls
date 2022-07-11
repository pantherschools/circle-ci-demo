/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-08-2022
 * @last modified by  : Amit Singh
**/
public with sharing class QBPaymentService {

    //QBPaymentService.testCreatePayment();
    public static void testCreatePayment(){
        CustomerRef ref = new CustomerRef();
        ref.setValue('20');
        CurrencyRef cRef = new CurrencyRef();
        cRef.setValue('USD');
        QBPaymentWrapper payment = new QBPaymentWrapper();
        payment.setCustomerRef(ref);
        payment.setCurrencyRef(cRef);
        payment.TotalAmt = 239.00;
        createPayment(payment);
    }

    /**
    * @description 
    * @author Amit Singh | 07-07-2022 
    * @param QBPaymentWrapper wrapper 
    **/
    public static Map<String, Object> createPayment(QBPaymentWrapper wrapper){
        HttpRequest request = QBUtils.prepareRequest('POST', '/v3/company/'+System.Label.QBCompanyId+'/payment?minorversion=63', JSON.serialize(wrapper));
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);

        Map<String, Object> resonseMap = new Map<String, Object>();
        if (response.getStatusCode() == 200) {

        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Creating Payment to QBO', 'QBPaymentService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
        return resonseMap;
    }
    public static Map<String, Object> deletePayment(String body){
        /*
            {
                "SyncToken": "2",
                "Id": "73"
            }
        */
        Map<String, Object> resonseMap = new Map<String, Object>();
        HttpRequest request = QBUtils.prepareRequest('POST', '/v3/company/'+System.Label.QBCompanyId+'/payment?operation=delete&minorversion=63', body);
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);
        if (response.getStatusCode() == 200) {

        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Deleting Payment from QBO', 'QBPaymentService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
        return resonseMap;
    }

    public static Map<String, Object> voidPayment(String body){
        /*
            {
                "SyncToken": "0",
                "Id": "146",
                "sparse": true
            }
        */
        Map<String, Object> resonseMap = new Map<String, Object>();
        HttpRequest request = QBUtils.prepareRequest('POST', '/v3/company/'+System.Label.QBCompanyId+'/payment?operation=update&include=void&minorversion=63', body);
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);
        if (response.getStatusCode() == 200) {
            resonseMap.put('status','SUCCESS');
            resonseMap.put('data','SUCCESS');
        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Voiding a Payment from QBO', 'QBPaymentService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
        return resonseMap;
    }
    //QBPaymentService.readSinglePayment('146');
    public static Map<String, Object> readSinglePayment(String paymentId){
        HttpRequest request = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/payment/'+paymentId+'?minorversion=63', null);
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);
        Map<String, Object> resonseMap = new Map<String, Object>();
        if (response.getStatusCode() == 200) {

        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Reading Payment from QBO', 'QBPaymentService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
        return resonseMap;
    }
    //QBPaymentService.getPaymentPDF('146');
    public static Map<String, Object> getPaymentPDF(String paymentId){
        HttpRequest request   = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/payment/'+paymentId+'/pdf?minorversion=63', null);
        HttpResponse response = (new Http()).send(request);
        Blob responseBody     = response.getBodyAsBlob();
        Map<String, Object> resonseMap = new Map<String, Object>();
        System.System.debug(response);
        if (response.getStatusCode() == 200) {

        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Reading Payment as PDF from QBO', 'QBPaymentService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = response.getBody(); 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
        return resonseMap;
    }
    
    //QBPaymentService.sendPayment('146','amitasinghsfdc@gmail.com');
    public static Map<String, Object> sendPayment(String paymentId, String email){

        Map<String, Object> resonseMap = new Map<String, Object>();
        HttpRequest request = QBUtils.prepareRequest('POST', '/v3/company/'+System.Label.QBCompanyId+'/payment/'+paymentId+'/send?sendTo='+email+'&minorversion=63', null);
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);
        if (response.getStatusCode() == 200) {

        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Sending Payment from QBO', 'QBPaymentService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
        return resonseMap;
    }
    public class QBPaymentWrapper{
        public Decimal TotalAmt;
        private CustomerRef CustomerRef;
        private CurrencyRef CurrencyRef;
        public void setCustomerRef(CustomerRef ref){
            this.CustomerRef = ref;
        }
        public void setCurrencyRef(CurrencyRef ref){
            this.CurrencyRef = ref;
        }
    }
    public class CustomerRef{
        public string value;
        public string name;
        public void setValue(String value){
            this.value = value;
        }
        public void setName(String name){
            this.name = name;
        }
    }
    public class CurrencyRef{
        public string value;
        public string name;
        public void setValue(String value){
            this.value = value;
        }
        public void setName(String name){
            this.name = name;
        }
    }

    public class QueryResponseWrapper{
        public QueryResponse QueryResponse;
        public String timeStamp;
    }

    public class QueryResponse {
        public Payment[] Payment;
        public Integer startPosition;
        public Integer maxResults;
    }

    public class Payment {
        public CustomerRef CustomerRef;
        public DepositToAccountRef DepositToAccountRef;
        public PaymentMethodRef PaymentMethodRef;
        public String PaymentRefNum;
        public Decimal TotalAmt;
        public Decimal UnappliedAmt;
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
    public class LinkedTxn {
        public String TxnId;
        public String TxnType;
    }
    public class Line {
        public Decimal Amount;
        public LinkedTxn[] LinkedTxn;
        public LineEx LineEx;
    }
    public class LineEx {
        public LineClass[] LineClass;
    }
    public class LineClass {
        public value value;
        public boolean nil;
        public boolean globalScope;
        public boolean typeSubstituted;
    }
    public class value {
        public String Name;
        public String Value;
    }
}