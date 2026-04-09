/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 04-24-2024
 * @last modified by  : Stefano Callisto
**/
public with sharing class PwcErrorLogEventTriggerHandler extends TriggerHandler {
    protected override void afterInsert() {
        List<sObject> errorList = new List<sObject>();
        List<sObject> errorListHighGravity = new List<sObject>();
        for (Insert_Error_Log__e event : (List<Insert_Error_Log__e>) Trigger.New) {

            sObject log = PwcUtils.generateSObject('ApexErrorLog__c');
            log.put('User__c', event.User__c);
            log.put('ErrorMessage__c', event.ErrorMessage__c);
            log.put('ExceptionType__c', event.ExceptionType__c);
            log.put('ErrorLine__c', event.ErrorLine__c);
            log.put('StackTrace__c', event.StackTrace__c);
            log.put('ApexClass__c', event.ApexClass__c);
            log.put('Method__c', event.Method__c);
            log.put('LogType__c', event.LogType__c);
            log.put('Timestamp__c', event.Timestamp__c);
            log.put('Severity__c', event.Severity__c);
            log.put('SupportTeam__c', event.SupportTeam__c);
            errorList.add(log);
        }
        System.debug(LoggingLevel.DEBUG, 'DebugInErrorLog: ' + errorList);
        insert errorList;
        System.debug(LoggingLevel.DEBUG,JSON.serialize(errorListHighGravity));
        System.debug(LoggingLevel.DEBUG,JSON.serialize(errorList));

    }
}