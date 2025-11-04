/* 
 * @description: Controller class to FastOpportunity Lightning Web Component
 */
public with sharing class FastOpportunityController {

    private static LeadRepository leadRepository;

    static{
        leadRepository = new LeadRepository();
    }

    @AuraEnabled
    public static Results creatingAnOpportunityWithLead( String fName, String lName, String company ){
        try {
            Lead myLead = new Lead(
                FirstName = fName,
                LastName = lName,
                Company = company
            );

            Database.insert( myLead );

            Database.LeadConvert leadConvertion = new database.LeadConvert();
            leadConvertion.setLeadId( myLead.Id );

            LeadStatus convertStatus = leadRepository.findLeadStatusApiName()[0];
            leadConvertion.setConvertedStatus( convertStatus.ApiName );

            Database.LeadConvertResult lcr = Database.convertLead( leadConvertion );

            return new Results( lcr.isSuccess(), lcr.isSuccess() ? null : JSON.serialize( lcr.getErrors() ) , lcr.getOpportunityId() );
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class Results {

        public Results( Boolean isSuccess, String errorString, String opportunityId) {
            this.isSuccess = isSuccess;
            this.errorString = errorString;
            this.opportunityId = opportunityId;
        }

        @AuraEnabled
        public Boolean isSuccess;

        @AuraEnabled
        public String errorString;

        @AuraEnabled
        public String opportunityId;

    }
}