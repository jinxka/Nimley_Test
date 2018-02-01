class ContactsController < ApplicationController
  before_action :set_contact, only: [:destroy]

  def import
    Contact.import(params[:file])
    redirect_to root_url, notice: 'Contacts imported successfully'
  end
  
  # GET /contacts
  # GET /contacts.json
  def index
    @invalid_contacts = Contact.last_import.invalid_contact
    @valid_contacts = Contact.last_import.valid_contact
  end

  def history
    @all_valid_contacts = Contact.valid_contact
    @all_invalid_contacts = Contact.invalid_contact
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:first_name, :last_name, :email)
    end
end
