/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 04-24-2024
 * @last modified by  : Stefano Callisto
**/
trigger PwcErrorLogEventTrigger on Insert_Error_Log__e (after insert) {
    new PwcErrorLogEventTriggerHandler().run();
}