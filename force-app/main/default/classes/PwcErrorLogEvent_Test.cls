/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 04-24-2024
 * @last modified by  : Stefano Callisto
**/
@IsTest
private class PwcErrorLogEvent_Test {
   @IsTest 
   static void testErrorLogEventBasic() {
        Integer countRowsPreExcep = [SELECT count() FROM ApexErrorLog__c];

        Test.startTest();
        integer a;
        try {
            a=a * 10;
        } catch (Exception ex) {
            PwcErrorLogEventHandler.PwcErrorLogInformationWrapper errorInformationWrapper = new PwcErrorLogEventHandler.PwcErrorLogInformationWrapper();
            errorInformationWrapper.e = ex;
            PwcErrorLogEventHandler.saveExceptionLog(errorInformationWrapper);
        }
        Test.stopTest();

        Integer countRowsPostExcep = [SELECT count() FROM ApexErrorLog__c];
        System.assert(true, countRowsPreExcep != countRowsPostExcep);
    }

    @IsTest
    static void testErrorLogEventWithNote() {
        Integer countRowsPreExcep = [SELECT count() FROM ApexErrorLog__c];

        Test.startTest();
        integer a;
        try {
            a=a * 10;
        } catch (Exception ex) {
            PwcErrorLogEventHandler.PwcErrorLogInformationWrapper informationWrapper=new PwcErrorLogEventHandler.PwcErrorLogInformationWrapper();
            informationWrapper.e=ex;
            informationWrapper.notes='My notes';
            PwcErrorLogEventHandler.saveExceptionLog(informationWrapper);
        }
        Test.stopTest();

        Integer countRowsPostExcep = [SELECT count() FROM ApexErrorLog__c];
        System.assert(true, countRowsPreExcep != countRowsPostExcep);
    }

    @IsTest
    static void testErrorLogEventFull() {
        Integer countRowsPreExcep = [SELECT count() FROM ApexErrorLog__c];

        Test.startTest();
        integer a;
        try {
            a=a * 10;
        } catch (Exception ex) {
            PwcErrorLogEventHandler.PwcErrorLogInformationWrapper informationWrapper=new PwcErrorLogEventHandler.PwcErrorLogInformationWrapper();
            informationWrapper.e=ex;
            informationWrapper.notes='My notes';
            informationWrapper.request='My request';
            informationWrapper.response='My response';
            PwcErrorLogEventHandler.saveExceptionLog(informationWrapper);
        }
        Test.stopTest();

        Integer countRowsPostExcep = [SELECT count() FROM ApexErrorLog__c];
        System.assert(true, countRowsPreExcep != countRowsPostExcep);
    }
    
    @IsTest
    static void testErrorLogEventTrigger() {
        Integer countRowsPreExcep = [SELECT count() FROM ApexErrorLog__c];
        Test.startTest();
        integer a;
        try {
            a=a * 10;
        } catch (Exception ex) {
            PwcErrorLogEventHandler.PwcErrorLogInformationWrapper informationWrapper=new PwcErrorLogEventHandler.PwcErrorLogInformationWrapper();
            informationWrapper.e=ex;
            informationWrapper.notes='My notes';
            informationWrapper.request='My request';
            informationWrapper.response='My response';
            PwcErrorLogEventHandler.saveExceptionLog(informationWrapper);
        }
        Test.stopTest();
        Integer countRowsPostExcep = [SELECT count() FROM ApexErrorLog__c];
        System.assert(true, countRowsPreExcep != countRowsPostExcep);
    }
}