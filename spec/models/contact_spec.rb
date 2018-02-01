require 'rails_helper'

RSpec.describe Contact, :type => :model do
  let(:valid_contact) {Contact.new(last_name:'Balanger',
                                      first_name:'Benjamin',
                                      email:'benjamin.balanger@blabla.eu',
                                      nbr_import:0,
                                      reason:nil,
                                      is_valid:false)}
  let(:valid_contact2) {Contact.new(last_name:'Balanger',
                                   first_name:'Benjamin',
                                   email:'benjamin.balanger12@blabla.eu',
                                   nbr_import:0,
                                   reason:nil,
                                   is_valid:false)}
  let(:valid_contact3) {Contact.new(last_name:'Jean',
                                    first_name:'Dupont',
                                    email:'benjamin.balanger@blabla.eu',
                                    nbr_import:0,
                                    reason:nil,
                                    is_valid:false)}
  let(:contact_bad_typo) {Contact.new(last_name:'124!:Balan1234ger345:;',
                                   first_name:'2345(-Benja8345,;:min65575;!',
                                   email:',;:benj,;amin.bala,;nger@bla,;bla.eu,;',
                                   nbr_import:0,
                                   reason:nil,
                                   is_valid:false)}
  let(:contact_bad_email) {Contact.new(last_name:'Balanger',
                                   first_name:'Benjamin',
                                   email:'benjamin.balangerblabla.eu',
                                   nbr_import:0,
                                   reason:nil,
                                   is_valid:false)}
  it 'Should save valid contact' do
    expect{valid_contact.save}.to change{Contact.where(is_valid:true).count}.by(1)
  end
  
  it 'Should not have two valid contact with same name' do
    expect{valid_contact.save
    valid_contact2.save}.to change{Contact.where(is_valid:true).count}.by(1).and change{Contact.where(is_valid:false).count}.by(1)
  end

  it 'Should not have two valid contact with same email' do
    expect{valid_contact.save
    valid_contact3.save}.to change{Contact.where(is_valid:true).count}.by(1).and change{Contact.where(is_valid:false).count}.by(1)
  end
  
  it 'Bad email should not be valid' do
    expect{contact_bad_email.save}.to change{Contact.where(is_valid:false, reason: "Email invalid").count}.by(1)
  end
  
  it 'Should clean name and email' do
    expect(contact_bad_typo.clean_character).to eq(valid_contact.inspect)
  end
end
