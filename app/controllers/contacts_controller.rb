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
  # # POST /contacts
  # # POST /contacts.json
  # def create
  #   @contact = Contact.new(contact_params)
  #
  #   respond_to do |format|
  #     if @contact.save
  #       format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
  #       format.json { render :show, status: :created, location: @contact }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @contact.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  # def update
  #   respond_to do |format|
  #     if @contact.update(contact_params)
  #       format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @contact }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @contact.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
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
