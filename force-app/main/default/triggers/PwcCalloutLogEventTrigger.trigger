/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 05-14-2024
 * @last modified by  : Stefano Callisto
**/
trigger PwcCalloutLogEventTrigger on Insert_Callout_Log__e (after insert) {
    new PwcCalloutLogEventTriggerHandler().run();
}