class PhoneNumber < ApplicationRecord
  self.table_name = 'phone_number'
  
  belongs_to :account
  validates :phone_number, presence: true
end
