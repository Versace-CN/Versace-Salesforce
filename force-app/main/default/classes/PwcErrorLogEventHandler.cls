/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 04-24-2024
 * @last modified by  : Stefano Callisto
**/
public without sharing class PwcErrorLogEventHandler {
    private final static Integer MAXLENGTH = 32768;
    private final static String EXCEPTIONLOGTYPE = 'Exception';
    private final static String INFOLOGTYPE = 'Info';

    public with sharing class PwcErrorLogInformationWrapper {
        public Exception e {get;set;}
        public String notes {get;set;}
        public String request {get;set;}
        public String response {get;set;}
        public String team {get;set;}
        public String severity {get;set;}
    }


    public static Exception saveExceptionLog(PwcErrorLogInformationWrapper informationWrapper){
        if(informationWrapper.e==null) return null;
        informationWrapper.notes=PwcUtils.isValid( informationWrapper.notes)?informationWrapper.notes:'';
        informationWrapper.request=PwcUtils.isValid( informationWrapper.request)?informationWrapper.request:'';
        informationWrapper.response=PwcUtils.isValid( informationWrapper.response)?informationWrapper.response:'';
        informationWrapper.severity='LOW';
        informationWrapper.team='TEAM0';

        Insert_Error_Log__e errorEvent = PwcErrorLogEventHandler.createEvent(informationWrapper);
        EventBus.publish(errorEvent);

        System.debug('--------------------------o oo o o ');
        return informationWrapper.e;
    }

    public static Exception saveExceptionLogHighSeverity(PwcErrorLogInformationWrapper informationWrapper){
        if(informationWrapper.e==null) return null;
        informationWrapper.notes=PwcUtils.isValid( informationWrapper.notes)?informationWrapper.notes:'';
        informationWrapper.request=PwcUtils.isValid( informationWrapper.request)?informationWrapper.request:'';
        informationWrapper.response=PwcUtils.isValid( informationWrapper.response)?informationWrapper.response:'';
        informationWrapper.severity='HIGH';
        informationWrapper.team='TEAM0';

        Insert_Error_Log__e errorEvent = PwcErrorLogEventHandler.createEvent(informationWrapper);
        EventBus.publish(errorEvent);

        return informationWrapper.e;
    }

    public static Insert_Error_Log__e initLogWithoutSave(PwcErrorLogInformationWrapper informationWrapper){
        if(informationWrapper.e==null) return null;
        informationWrapper.notes=PwcUtils.isValid( informationWrapper.notes)?informationWrapper.notes:'';
        informationWrapper.request=PwcUtils.isValid( informationWrapper.request)?informationWrapper.request:'';
        informationWrapper.response=PwcUtils.isValid( informationWrapper.response)?informationWrapper.response:'';
        informationWrapper.severity='LOW';
        informationWrapper.team='TEAM0';

        Insert_Error_Log__e errorEvent = PwcErrorLogEventHandler.createEvent(informationWrapper);

        return errorEvent;
    }

    public static Insert_Error_Log__e initLogWithoutSaveHighSeverity(PwcErrorLogInformationWrapper informationWrapper){
        if(informationWrapper.e==null) return null;
        informationWrapper.notes=PwcUtils.isValid( informationWrapper.notes)?informationWrapper.notes:'';
        informationWrapper.request=PwcUtils.isValid( informationWrapper.request)?informationWrapper.request:'';
        informationWrapper.response=PwcUtils.isValid( informationWrapper.response)?informationWrapper.response:'';
        informationWrapper.severity='HIGH';
        informationWrapper.team='TEAM0';

        Insert_Error_Log__e errorEvent = PwcErrorLogEventHandler.createEvent(informationWrapper);
        return errorEvent;
    }

    private static Insert_Error_Log__e createEvent(PwcErrorLogInformationWrapper informationWrapper){
        if(informationWrapper.e==null) return null;
        informationWrapper.notes=PwcUtils.isValid( informationWrapper.notes)?informationWrapper.notes:'';
        informationWrapper.request=PwcUtils.isValid( informationWrapper.request)?informationWrapper.request:'';
        informationWrapper.response=PwcUtils.isValid( informationWrapper.response)?informationWrapper.response:'';
        return initializeEvent(informationWrapper, EXCEPTIONLOGTYPE);
    }

    //returns a List of Strings where the first one is the className and the second one is the methodName
    private static List<String> extractNamingInfo(Exception e){
        String mainLine;

        List<String> traces = e.getStackTraceString().split('\n');
        System.debug(LoggingLevel.DEBUG,'STACK TRACE: ' + e.getStackTraceString());
        for(String trace : traces){
            if(!trace.contains('Class.PwcErrorLogEventHandler.')){
                //first trace not containing 'Class.LogHandler.' string is the original class/method we are interested in
                mainLine = trace;
                break;
            }
        }
        System.debug(LoggingLevel.DEBUG,mainLine);

        List<String> namingInfo = mainLine.left(mainLine.indexOf(':')).split('\\.');
        if(namingInfo.size()>1){
            //classica stringa di stackTrace Class.nomeClasse.nomeMetodo
            namingInfo.remove(0); //remove 'Class' string;
        }
        else{
            /* stackTrace strano, metto questo pezzo per evitare che il codice si spacchi se mai si dovesse ottenere uno stackTrace del genere.
             * Se qualcuno riesce a ottenere un caso del genere me lo faccia sapere (per ora sono riuscito ad ottenerlo solo tramite
             * codice eseguito come anonymous block, che però è un caso particolare e out of scope per l' utilizzo dell' oggetto Log__c)
             */
            return 	new List<String>(2);
        }
        return namingInfo;
    }

    //initializes all the record fields
    private static Insert_Error_Log__e initializeEvent(PwcErrorLogInformationWrapper informationWrapper,String logType){
        String className;
        String methodName;

        List<String> namingInfo = extractNamingInfo(informationWrapper.e);
        className  = namingInfo.size() > 0 ? namingInfo.get(0) : null;
        methodName = namingInfo.size() > 1 ? namingInfo.get(1) : null;

        Insert_Error_Log__e eventLog = new Insert_Error_Log__e(User__c = UserInfo.getUserId(),
                ErrorMessage__c = informationWrapper.e.getMessage(),
                ExceptionType__c = logType == EXCEPTIONLOGTYPE ? informationWrapper.e.getTypeName() : null,
                ErrorLine__c = String.valueOf(informationWrapper.e.getLineNumber()),
                StackTrace__c = informationWrapper.e.getStackTraceString(),
                ApexClass__c = className,
                Method__c = methodName,
                LogType__c = LogType,
                Timestamp__c=Datetime.now(),
                Severity__c=informationWrapper.severity,
                SupportTeam__c=informationWrapper.team
        );

        System.debug(LoggingLevel.DEBUG,'Inserito evento: ' + eventLog);
        return eventLog;
    }


}