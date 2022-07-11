/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 07-06-2022
 * @last modified by  : Amit Singh
**/
public with sharing class QBBillService {
    
    /**
    * @description 
    * @author Amit Singh | 07-05-2022 
    * @param QBBillWrapper wrapper 
    **/

    /*
        String json = '{'+
		'  "Line": ['+
		'    {'+
		'      "DetailType": "AccountBasedExpenseLineDetail", '+
		'      "Amount": 200, '+
		'      "Id": "1", '+
		'      "AccountBasedExpenseLineDetail": {'+
		'        "AccountRef": {'+
		'          "value": "7"'+
		'        }'+
		'      }'+
		'    }'+
		'  ], '+
		'  "VendorRef": {'+
		'    "value": "56"'+
		'  }'+
		'}';
        QBBillWrapper wrapper = (QBBillWrapper)System.JSON.deserialize(json, QBBillWrapper.class);
        QBBillService.createBill(wrapper);
    */
    public static  Map<String, Object> createBill(QBBillWrapper wrapper){
        Map<String, Object> resonseMap = new Map<String, Object>();
        HttpRequest request = QBUtils.prepareRequest('POST', '/v3/company/'+System.Label.QBCompanyId+'/bill?minorversion=63', JSON.serialize(wrapper));
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();

        System.System.debug(' Response \n '+ responseBody);

        QBBillResponseWrapper responseData = new QBBillResponseWrapper();

        if (response.getStatusCode() == 200) {
            resonseMap.put('status','SUCCESS');
            responseData = (QBBillResponseWrapper)System.JSON.deserialize(responseBody, QBBillResponseWrapper.class);
            resonseMap.put('data',responseData);
        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While creating Bill in QBO', 'QBBillService', 'Error', 'Apex');
            log.logRecord.ExternalSystem__c = 'Stripe'; 
            log.logRecord.ExternalReferenceCode__c = String.valueOf( response.getStatusCode() ); 
            log.logRecord.ExternalSystemResult__c = responseBody; 
            log.logRecord.ExternalSystemErrorCodes__c = 'https://developer.intuit.com/app/developer/qbo/docs/develop/troubleshooting/error-codes'; 
            log.logRecord.ExternalSystemDocument__c = 'https://developer.intuit.com/app/developer/qbo/docs/get-started';
            resonseMap.put('data', log);
        }
        return resonseMap;
    }

    /* 
        QBBillService.readBill('147');
    */
    public static Map<String, Object> readBill(String billId){

        /* Prepare a Map for response */
        Map<String, Object> resonseMap = new Map<String, Object>();
        HttpRequest request = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/bill/'+billId+'?minorversion=63', null);
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        String finalBody  = responseBody.replaceAll('name','qbName');
        System.System.debug(responseBody);
        /* Store the reponse in QBBillResponseWrapper apes class */
        QBBillResponseWrapper responseData = new QBBillResponseWrapper();
        if (response.getStatusCode() == 200) {
            resonseMap.put('status','SUCCESS');
            responseData = (QBBillResponseWrapper)System.JSON.deserialize(responseBody, QBBillResponseWrapper.class);
            System.debug('responseData \n '+ System.JSON.serialize(responseData) );
            resonseMap.put('data',responseData);
        }else{
            resonseMap.put('status','ERROR');
            Logger log = new Logger('Error occured While Reading Bill', 'QBBillService', 'Error', 'Apex');
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
}
