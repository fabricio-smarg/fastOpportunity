/* 
 * @description: Forms Lightning Web Component to converting a lead in account, opportunity and contact
 */
import { LightningElement, track } from 'lwc';

import createLeadAndConvertService from '@salesforce/apex/FastOpportunityController.creatingAnOpportunityWithLead';

export default class FastOpportunity extends LightningElement {
    @track showLoadingScreen = false;
    @track loadingScreenMessage = '';
    @track opportunityId;

    @track formData = {
        customerFirstName: '',
        customerLastName: '',
        company: ''
    };

    showForms = true;
    resultMessage = '';
    showResult = false;
    showCreate = true;
    showFinish = false;

    async handleCreate() {
        this.showForms = false;
        this.showCreate = false;
        this.showLoadingScreen = true;

        let result = await createLeadAndConvertService ( { fName: this.formData.customerFirstName ,  lName: this.formData.customerLastName,  company: this.formData.company } );

        this.showLoadingScreen = false;

        if( result.isSuccess == true ) { this.opportunityId = result.opportunityId; }
        else { this.resultMessage = result.errorString; this.showFinish = true; }

        this.showResult = true;
    }

    handleFinish() {
        window.location.reload();
    }

    handleChange(event) {
        const { name, value } = event.target;
        this.formData = { ...this.formData, [name]: value };
    }

    isNull( value ) {
        if( value == [] || value == '' || value == undefined || value == null || value == {} ) {
            return true;
        }
        return false;
    }

    get isDisabled() {
        return this.isNull( this.formData.company ) || this.isNull ( this.formData.customerLastName ); 
    }

    get recordUrl() {
        return `${window.location.origin}/${this.opportunityId}`;
    }
}