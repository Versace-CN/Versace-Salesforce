/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 03-10-2025
 * @last modified by  : Stefano Callisto
**/

public with sharing class PwCUtils {

    public static String stripJsonNulls(String inputJsonString) {
        String jsonString;
        if (inputJsonString != null) {
            jsonString = inputJsonString.replaceAll('\"[^\"]*\":null',''); //basic removeal of null values
            jsonString = inputJsonString.replaceAll('\"[^\"]*\":""',''); //basic removeal of empty values
            jsonString = inputJsonString.replaceAll(',{2,}', ','); //remove duplicate/multiple commas
            jsonString = inputJsonString.replace('{,', '{'); //prevent opening brace from having a comma after it
            jsonString = inputJsonString.replace(',}', '}'); //prevent closing brace from having a comma before it
            jsonString = inputJsonString.replace('[,', '['); //prevent opening bracket from having a comma after it
            jsonString = inputJsonString.replace(',]', ']'); //prevent closing bracket from having a comma before it
        }
        return jsonString;
    }

    public static List<String> toListId(List<SObject> objects) {
        List<String> ids = new List<String>();

        for(SObject obj : objects)
            if(notNull(obj.Id))
                ids.add(obj.Id);

        return ids;
    }

    public static Boolean notNull(Object o) { return o != null; }
    
    public static SObject generateSObject(String objectType) {

        Sobject generic = Schema.getGlobalDescribe().get(objectType).getDescribe().getSObjectType().newSObject();
        return generic;
    }
    
    public static Boolean isNullOrEmpty(string element)
    {
        return element==null || !String.isNotBlank(element) || !String.isNotEmpty(element);
    }

    public static Boolean isValid(string element)
    {
        return !isNullOrEmpty(element);
    }

    public static Boolean isValid(List<Object> element)
    {
        return !isNullOrEmpty(element);
    }

    public static Boolean isValid(Set<Object> element)
    {
        return !isNullOrEmpty(element);
    }

    public static Boolean isNullOrEmpty(List<Object> element)
    {
        return element==null || element.isEmpty();
    }

    public static Boolean isNullOrEmpty(Set<Object> element)
    {
        return element==null || element.isEmpty();
    }

    public static String abbreviateTo10k(String s){
        if(10000 < s.length()) {
            return s.substring(0, 10000);
        } else {
            return s;
        }
    }

    public static Account getAccountByIdFromList(List<Account> accounts, Id accountId) {
        for (Account acc : accounts) {
            if (acc.Id == accountId) {
                return acc;
            }
        }
        return null;
    }

}