/**
 * @description       : 
 * @author            : Stefano Callisto
 * @group             : PwC
 * @last modified on  : 04-04-2025
 * @last modified by  : Stefano Callisto
**/
@RestResource(urlMapping='/getClients/*')
global with sharing class PwcGetClientsApi {

    @HttpPost
    global static GetClientsResponseDto getClients() {
        try {
            List<Account> accounts = new List<Account>();
            RestRequest req = RestContext.request;
            GetClientsRequestDto getClientsRequestDto = (GetClientsRequestDto) JSON.deserialize(req.requestBody.toString(), GetClientsRequestDto.class);   
            accounts = getListAccount(getClientsRequestDto);
            return constructResponse('OK', null, accounts);
        } catch (Exception e) {
            return constructResponse('ERROR', e.getMessage(), null);
        }
    }

    private static List<Account> getListAccount(GetClientsRequestDto getClientsRequestDto) {
        String query = 'SELECT Id ';
        for(Schema.FieldSetMember f : SObjectType.Account.FieldSets.GetClients.getFields()) {
            query +=  ', ' + f.getFieldPath();
        }
        String whereCondition = generateWhereQuery(getClientsRequestDto);
        query += ' FROM Account' + whereCondition;
        System.debug(query);
        return Database.query(query);
    }

    private static String generateWhereQuery(GetClientsRequestDto getClientsRequestDto) {
        String whereCondition = '';
        if(getClientsRequestDto!=null){
            if(String.isNotBlank(getClientsRequestDto.serviceCloudId)) {
                whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'Id = \'' + getClientsRequestDto.serviceCloudId + '\'';
            }
            else if(String.isNotBlank(getClientsRequestDto.xStoreId)) {
                    whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'XStore_Id__c = \'' + getClientsRequestDto.xStoreId + '\'';
                }
            else{
                if(String.isNotBlank(getClientsRequestDto.firstName)) {
                    whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'FirstName = \'' + getClientsRequestDto.firstName + '\'';
                }
                if(String.isNotBlank(getClientsRequestDto.lastName)) {
                    whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'LastName = \'' + getClientsRequestDto.lastName + '\'';
                }
                if(String.isNotBlank(getClientsRequestDto.personEmail)) {
                    whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'PersonEmail = \'' + getClientsRequestDto.personEmail + '\'';
                }
                if(String.isNotBlank(getClientsRequestDto.personMobilePhone)) {
                    whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'PersonMobilePhone = \'' + getClientsRequestDto.personMobilePhone + '\'';
                }
                if(String.isNotBlank(getClientsRequestDto.billingCity)) {
                    whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'BillingCity = \'' + getClientsRequestDto.billingCity + '\'';
                }
                if(String.isNotBlank(getClientsRequestDto.billingPostalCode)) {
                    whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'BillingPostalCode = \'' + getClientsRequestDto.billingPostalCode + '\'';
                }
                if(String.isNotBlank(getClientsRequestDto.orceId)) {
                    whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'Orce_Id__c = \'' + getClientsRequestDto.orceId + '\'';
                }
                if(String.isNotBlank(getClientsRequestDto.createdCompany)) {
                    whereCondition += (String.isBlank(whereCondition) ? ' WHERE ' : ' AND ') + 'Created_Company__pc = \'' + getClientsRequestDto.createdCompany + '\'';
                } 
            }
        }
        return whereCondition;
    }

    private static GetClientsResponseDto constructResponse(String status, String errorMessage, List<Account> accounts) {
        GetClientsResponseDto getClientsResponseDto = new GetClientsResponseDto();
        if(accounts!=null){
            getClientsResponseDto.response = new List<DetailsClientDto>();
            for(Account account : accounts){
                DetailsClientDto detailsClientDto = new DetailsClientDto();
                detailsClientDto.customerID = account.Id;
                detailsClientDto.orceId = account.Orce_Id__c;
                detailsClientDto.employeeID = null;  //WORKDAY ID
                detailsClientDto.businessName = account.Business_Name__pc;
                detailsClientDto.firstName = account.FirstName;
                detailsClientDto.lastName = account.LastName;
                detailsClientDto.firstNameLocal = account.First_Name_Local__pc;
                detailsClientDto.lastNameLocal = account.Last_Name_Local__pc;
                detailsClientDto.emailAddress = account.PersonEmail;
                detailsClientDto.mobilePhone = account.PersonMobilePhone;
                detailsClientDto.addressName = account.Billing_Name__pc;
                detailsClientDto.addressLine = account.BillingStreet;
                detailsClientDto.addressDistrict = account.Billing_District__pc;
                detailsClientDto.addressCity = account.BillingCity;
                detailsClientDto.addressPostalcode = account.BillingPostalCode;
                detailsClientDto.addressStateOrProvince = account.BillingState;
                detailsClientDto.addressRegion = account.Billing_Region__pc;
                detailsClientDto.addressCounty = account.Billing_State_County__pc;
                detailsClientDto.addressCountryISO3 = account.Billing_Iso_Code__pc;
                detailsClientDto.addressLine2 = account.BillingStreet2__pc;
                detailsClientDto.nationality = account.Nationality__pc;
                detailsClientDto.age = account.Age_Group__pc;  //CHIEDERE A DARIO
                detailsClientDto.fiscalCode = account.Fiscal_Code__pc;
                detailsClientDto.profession = null;  // TO REMOVE
                detailsClientDto.weChat = null; //TO REMOVE
                detailsClientDto.taxGroup = null;
                detailsClientDto.ecommerceId = account.Ecommerce_Code__c;
                detailsClientDto.marketingHQ = account.Marketing_HQ__pc;
                detailsClientDto.profilingHQ = account.Profiling_HQ__pc;
                detailsClientDto.marketingCN = account.Marketing_PRC__pc;
                detailsClientDto.profilingCN = account.Profiling_PRC__pc;
                getClientsResponseDto.response.add(detailsClientDto);
            }
        }
        getClientsResponseDto.status = status;
        getClientsResponseDto.errorMessage = errorMessage;
        return getClientsResponseDto;
    }

    
    global with sharing class GetClientsRequestDto {
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String personEmail { get; set; }
        public String personMobilePhone { get; set; }
        public String billingCity { get; set; }
        public String billingPostalCode { get; set; }
        public String orceId { get; set; }
        public String createdCompany { get; set; }
        public String xStoreId { get; set; }
        public String serviceCloudId { get; set; }
    }

    global with sharing class GetClientsResponseDto {
        public String status { get; set; }
        public String errorMessage { get; set; }
        public List<DetailsClientDto> response { get; set; }
    }
    
    global with sharing class DetailsClientDto {
        public String customerID { get; set; }
        public String orceId { get; set; }
        public String employeeID { get; set; }
        public String businessName { get; set; }
        public String firstName { get; set; }
        public String lastName { get; set; }
        public String firstNameLocal { get; set; }
        public String lastNameLocal { get; set; }
        public String emailAddress { get; set; }
        public String mobilePhone { get; set; }
        public String addressName { get; set; }
        public String addressLine { get; set; }
        public String addressDistrict { get; set; }
        public String addressCity { get; set; }
        public String addressPostalcode { get; set; }
        public String addressStateOrProvince { get; set; }
        public String addressRegion { get; set; }
        public String addressCounty { get; set; }
        public String addressCountryISO3 { get; set; }
        public String addressLine2 { get; set; }
        public String nationality { get; set; }
        public String age { get; set; }
        public String fiscalCode { get; set; }
        public String profession { get; set; }
        public String weChat { get; set; }
        public String taxGroup { get; set; }
        public String ecommerceId { get; set; }
        public Boolean marketingHQ { get; set; }
        public Boolean profilingHQ { get; set; }
        public Boolean marketingCN { get; set; }
        public Boolean profilingCN { get; set; }
    }
}