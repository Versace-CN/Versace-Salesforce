/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 03-10-2025
 * @last modified by  : Stefano Callisto
**/
public with sharing class PwcTestDataFactory {
    public static User setupUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(
                Alias = 'setup',
                Email = 'setupUser@testorg.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Setup',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = p.Id,
                TimeZoneSidKey = 'Europe/Rome',
                UserName = 'setup275436462111@testorg.com',
                FederationIdentifier = 'setupUser'
        );

        insert u;
        return u;
    }

    public static User initUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(
                Alias = 'init',
                Email = 'initUser@testorg.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'Matteo',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = p.Id,
                TimeZoneSidKey = 'Europe/Rome',
                UserName = 'matteo275436462111@testorg.com',
                FederationIdentifier = 'initUser'
        );

        insert u;
        return u;
    }

    public static Group newQueue(String name, String developerName){
        Group queue = new Group(Name = name, DeveloperName = developerName, Type = 'Queue');
        insert queue;
        return queue;
    }

    public static Campaign newCampaign() {
        Campaign campaign = new Campaign(
            Name = 'Campagna di Test Static',
            StartDate = Date.today().addDays(7), 
            EndDate = Date.today().addDays(30),   
            Status = 'Planned',
            Type = 'Webinar'
        );
        insert campaign;
        return campaign;
    }
}