class Import < ApplicationRecord
  before_validation do
    verify_name
    clean_character
    formatting_name
    find_reason
  end

  scope :last_import, -> {where(nbr_import: Import.order(:nbr_import).pluck(:nbr_import).last)}
  scope :invalid_contact, -> {where('reason IS NOT NULL')}
  
  def set_import(new_import)
    logger.info "SET IMPORT = #{new_import}"
    self.nbr_import = new_import
  end
  
  def find_reason
    return self.reason = "Email invalid" if /[^0-9A-Za-z\.@]/.match(email)
    return self.reason = "Contact already exists" if !Contact.find_by(last_name: last_name, first_name: first_name).nil?
    return self.reason = "Email already exists" if !Contact.find_by(email: email).nil?
  end
  
  def verify_name
    self.last_name = '' if self.last_name.length < 3
    self.first_name = '' if self.first_name.length < 3
  end

  def clean_character
    self.last_name = self.last_name.gsub(/[^A-Za-z]/, '')
    self.first_name = self.first_name.gsub(/[^A-Za-z]/, '')
    self.email = self.email.gsub(/[^0-9A-Za-z\.@]/, '')
  end

  def formatting_name
    self.last_name = self.last_name.downcase.capitalize!
    self.first_name = self.first_name.downcase.capitalize!
  end
end
