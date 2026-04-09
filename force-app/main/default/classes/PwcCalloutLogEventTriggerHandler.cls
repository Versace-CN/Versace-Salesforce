/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 05-14-2024
 * @last modified by  : Stefano Callisto
**/
public with sharing class PwcCalloutLogEventTriggerHandler extends TriggerHandler {

    protected override void afterInsert() {
        List<CalloutLog__c> calloutLoggerList = new List<CalloutLog__c>();
        for (Insert_Callout_Log__e event : (List<Insert_Callout_Log__e>) Trigger.New) {
            calloutLoggerList.add(PwcCalloutLog.generateSoObjectFromEvent(event));
        }
        if (calloutLoggerList.isEmpty()) {
            return;
        }
        System.debug(LoggingLevel.DEBUG, 'DebugCalloutLogger: ' + calloutLoggerList);
        insert calloutLoggerList;
    }
}