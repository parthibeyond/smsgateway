class Sms
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :from, :to, :text, :account

  validates_each :from, :to, :text do |record, attr, value|
    record.errors.add attr, "is missing" if value.blank?
    record.errors.add attr, "is invalid" if ([:from, :to].include?(attr) && out_of_limit(value&.size.to_i))
    record.errors.add attr, "is invalid" if ([:text].include?(attr) && out_of_limit(value&.size.to_i))
  end

  def self.out_of_limit(limit)
    (limit < 6) && (limit > 16)
  end

  def validate_inbound_condition
    validate
    phone = account.phone_number.find_by(number: to)
    errors.add(:to, "parameter not found") if phone.nil?
  end

  def validate_outbound_condition
    validate
    phone = account.phone_number.find_by(number: from)
    errors.add(:from, "parameter not found") if phone.nil?
    errors.add(:base, "sms from #{from} to #{to} blocked by STOP request") if $redis.get("#{from}_#{to}")
    errors.add(:base, "limit reached for from #{from}") if $redis.get("#{from}_count").to_i > 50
  end

  def stop_command_exists?(from, to)
  end

  def increment_sms_count(from)
    count = $redis.incr("#{from}_count")
    $redis.expire("#{from}_count", 24.hours) if count == 1
  end

  def exceeded_rate_limit?(from)
  end
end
