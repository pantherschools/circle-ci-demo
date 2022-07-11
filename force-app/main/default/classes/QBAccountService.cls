public with sharing class QBAccountService {

    public static void createAccount(QBAccountWrapper wrapper){
        HttpRequest request = QBUtils.prepareRequest('POST', '/v3/company/'+System.Label.QBCompanyId+'/account?minorversion=63', JSON.serialize(wrapper));
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);
        if (response.getStatusCode() == 200) {

        }else{

        }
    }

    public static void querySingleAccount(String accountId){
        HttpRequest request = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/account/'+accountId+'?minorversion=63', null);
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);
        if (response.getStatusCode() == 200) {

        }else{

        }
    }

    public static void queryAccounts(String query){
        if(String.isBlank(query)){
            query = 'select * from Account where Metadata.CreateTime > \'2014-12-31\' ';
        }
        HttpRequest request = QBUtils.prepareRequest('GET', '/v3/company/'+System.Label.QBCompanyId+'/query?query='+EncodingUtil.urlEncode(query,'UTF-8')+'&minorversion=63', '');
        HttpResponse response = (new Http()).send(request);
        String responseBody = response.getBody();
        System.System.debug(responseBody);
        if (response.getStatusCode() == 200) {

        }else{

        }
    }
    public class QBAccountWrapper{
        public String Name;
        public String AcctNum;
        public String AccountType;
        public String AccountSubType;
    }

}