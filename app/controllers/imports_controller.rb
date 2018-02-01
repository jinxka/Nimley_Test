class ImportsController < ApplicationController
  before_action :set_contact, only: [:destroy]
  def destroy
    @import.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @import = Import.find(params[:id])
  end
  
  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:import).permit(:first_name, :last_name, :email)
  end
end