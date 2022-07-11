public with sharing class QBUtils {

    public static HttpRequest prepareRequest(String method, String url, String body) {
        HttpRequest request = new HttpRequest();
        request.setMethod(method);
        request.setEndPoint('callout:'+System.Label.QBNamedCredentials+url);
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Accept', 'application/json');
        if(!String.isBlank(body)) {
            request.setBody(body);
        }
        return request;
    }
}