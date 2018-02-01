class Contact < ApplicationRecord
  
  before_validation do
    verify_name
    clean_character
    formatting_name
    find_reason
    isValid?
  end
  
  validates_uniqueness_of :last_name, scope: :first_name, if: ->{isValid?}
  validates :email, presence: true, uniqueness: true, if: ->{isValid?}
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, if: ->{isValid?}

  scope :last_import, -> {where(nbr_import: Contact.order(:nbr_import).pluck(:nbr_import).last)}
  scope :invalid_contact, -> {where(is_valid: false)}
  scope :valid_contact, -> {where(is_valid: true)}

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
  
  def isValid?
    self.is_valid = true if self.reason.blank?
  end
  
  def self.import(file)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    new_import = Contact.order(:nbr_import).pluck(:nbr_import).last
    new_import.blank? ? new_import = 0 : new_import = new_import+1
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      contact = new
      contact.attributes = row.to_hash
      contact.nbr_import = new_import
      contact.save
    end
  end
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
      when ".csv" then Csv.new(file.path, nil, :ignore)
      when ".xls" then Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Excelx.new(file.path, nil, :ignore)
      else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
