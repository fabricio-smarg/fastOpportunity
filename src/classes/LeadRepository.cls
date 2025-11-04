/* 
 * @description: Class to execute lead queries 
 */
public virtual class LeadRepository {
    
    // This approach assumes that a lead achieves conversion exclusively through one specific status.
    public virtual List<LeadStatus> findLeadStatusApiName () {
        return [
            SELECT 
                ApiName 
            FROM 
                LeadStatus 
            WHERE 
                IsConverted = true 
            LIMIT 1
        ];
    }
}