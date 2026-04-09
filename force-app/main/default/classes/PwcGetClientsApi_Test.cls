/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 04-03-2025
 * @last modified by  : Stefano Callisto
**/
@isTest
public with sharing class PwcGetClientsApi_Test {
    @testSetup
    static void setup() {
        Account acc = new Account(
            FirstName = 'Test',
            LastName = 'User',
            PersonEmail = 'test@example.com',
            PersonMobilePhone = '1234567890',
            BillingCity = 'Milan',
            BillingPostalCode = '20100',
            Orce_Id__c = 'ORC12345'
        );
        insert acc;
    }

    @isTest
    static void testGetClientsSuccess() {
        PwcGetClientsApi.GetClientsRequestDto requestDto = new PwcGetClientsApi.GetClientsRequestDto();
        requestDto.firstName = 'Test';
        requestDto.lastName = 'User';
        
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(JSON.serialize(requestDto));
        RestContext.request = req;
        
        Test.startTest();
        PwcGetClientsApi.GetClientsResponseDto response = PwcGetClientsApi.getClients();
        Test.stopTest();
        
        System.assertEquals('OK', response.status, 'Lo stato della risposta deve essere OK.');
        System.assert(response.response.size() > 0, 'Dovrebbe esserci almeno un risultato.');
        System.assertEquals('Test', response.response[0].firstName, 'Il nome deve corrispondere.');
        System.assertEquals('User', response.response[0].lastName, 'Il cognome deve corrispondere.');
    }

    @isTest
    static void testGetClientsNoResults() {
        PwcGetClientsApi.GetClientsRequestDto requestDto = new PwcGetClientsApi.GetClientsRequestDto();
        requestDto.firstName = 'NonEsistente';
        requestDto.lastName = 'Utente';
        
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf(JSON.serialize(requestDto));
        RestContext.request = req;
        
        Test.startTest();
        PwcGetClientsApi.GetClientsResponseDto response = PwcGetClientsApi.getClients();
        Test.stopTest();
        
        System.assertEquals('OK', response.status, 'Lo stato della risposta deve essere OK anche senza risultati.');
        System.assertEquals(0, response.response.size(), 'Non dovrebbero esserci risultati.');
    }

    @isTest
    static void testGetClientsExceptionHandling() {
        RestRequest req = new RestRequest();
        req.requestBody = Blob.valueOf('Invalid JSON'); // Simula una richiesta non valida
        RestContext.request = req;
        
        Test.startTest();
        PwcGetClientsApi.GetClientsResponseDto response = PwcGetClientsApi.getClients();
        Test.stopTest();
        
        System.assertEquals('ERROR', response.status, 'Lo stato della risposta deve essere ERROR in caso di eccezione.');
        System.assertNotEquals(null, response.errorMessage, 'Il messaggio di errore non deve essere nullo.');
    }
}