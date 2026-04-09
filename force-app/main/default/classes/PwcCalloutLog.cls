/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 05-14-2024
 * @last modified by  : Stefano Callisto
**/
public without sharing class PwcCalloutLog {
    private Insert_Callout_Log__e logger = new Insert_Callout_Log__e();

    public PwcCalloutLog setRequest(HttpRequest request) {
        logger.HTTPMethod__c = request.getMethod();
        logger.Endpoint__c = request.getEndpoint();
        logger.RequestMessage__c = PwcUtils.abbreviateTo10k(request.getBody().replace('\r\n', '#r'));
        return this;
    }

    public PwcCalloutLog setResponse(HttpResponse response, string additionalOutcomeInfos) {
        if (response == null) {
            logger.Status__c = 'FAILED';
            logger.ResponseMessage__c = additionalOutcomeInfos;
            return this;
        }

        Integer statusCode = response.getStatusCode();
        logger.ResponseMessage__c = PwcUtils.abbreviateTo10k(response.getBody());
        logger.HTTPStatus__c = response.getStatus();
        logger.HTTPStatusCode__c = statusCode;

        if (statusCode == 200) {
            logger.Status__c = 'SUCCESS';
            return this;
        }

        logger.Status__c = 'FAILED';

        return this;
    }

    public PwcCalloutLog setCallsDuration(Long totalTime) {
        logger.Time__c = totalTime;
        return this;
    }

    public PwcCalloutLog setHeader(Map<String, String> headers) {
        String strHeaders = formatHeaderForLog(headers);
        logger.headers__c = strHeaders.replace('\r', '#r');
        return this;
    }

    public PwcCalloutLog setTs(Datetime ts) {
        logger.Timestamp__c = ts;
        return this;
    }

    public PwcCalloutLog setServiceName(String str) {
        logger.Service__c = str;
        return this;
    }

    public SObject buildLog() {
        System.debug(LoggingLevel.DEBUG,JSON.serialize(logger));
        return logger;
    }

    public static CalloutLog__c generateSoObjectFromEvent(Insert_Callout_Log__e event) {
        CalloutLog__c logger = new CalloutLog__c();

        logger.RequestMessage__c = event.RequestMessage__c ;
        logger.Time__c = event.Time__c ;
        logger.Service__c = event.Service__c ;
        logger.HTTPMethod__c = event.HTTPMethod__c ;
        logger.Endpoint__c = event.Endpoint__c ;
        logger.ResponseMessage__c = event.ResponseMessage__c ;
        logger.HTTPStatus__c = event.HTTPStatus__c ;
        logger.HTTPStatusCode__c = event.HTTPStatusCode__c ;
        logger.Status__c = event.Status__c ;
        logger.Headers__c = event.Headers__c ;
        logger.Timestamp__c=event.Timestamp__c;
        return logger;
    }

    public static void publishCalloutLog(SObject log) {
        EventBus.publish(log);
    }

    public string formatHeaderForLog(Map<string, string> headers) {
        string headerMessage = '';
        for (string key : headers.keySet()) {
            headerMessage += key + ':' + (string) headers.get(key) + '\r';
        }
        return headerMessage;
    }


}