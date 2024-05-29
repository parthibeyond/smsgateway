class Sms
  include ActiveModel::API
  include ActiveModel::Validations

  attr_accessor :from, :to, :text, :account

  validates_each :from, :to, :text do |record, attr, value|
    record.errors.add attr, "is missing" if value.blank?
    record.errors.add attr, "is invalid" if ([:from, :to].include?(attr) && out_of_limit(value&.size.to_i, 6, 16))
    record.errors.add attr, "is invalid" if (attr.eql?(:text) && out_of_limit(value&.size.to_i, 1, 120))
  end

  def self.out_of_limit(limit, min, max)
    (limit < min) || (limit > max)
  end

  def validate_inbound_condition
    validate
    errors.add(:to, "parameter not found") unless phone_exists?(to)
  end

  def validate_outbound_condition
    validate
    errors.add(:from, "parameter not found") unless phone_exists?(from)
    errors.add(:base, "sms from #{from} to #{to} blocked by STOP request") if stop_command_exists?(from, to)
    errors.add(:base, "limit reached for from #{from}") if exceeded_rate_limit?(from)
  end

  def phone_exists?(number)
    account.phone_number.find_by(number: number)
  end

  def stop_command_exists?(from, to)
    $redis.get("#{from}_#{to}")
  end

  def increment_sms_count(from)
    count = $redis.incr("#{from}_count")
    $redis.expire("#{from}_count", 24.hours) if count == 1
  end

  def exceeded_rate_limit?(from)
    $redis.get("#{from}_count").to_i > 50
  end
end
