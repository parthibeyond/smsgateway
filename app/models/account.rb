class Account < ApplicationRecord
  self.table_name = 'account'

  has_many :phone_number

  def authenticate(auth)
    auth_id.eql?(auth)
  end
end
