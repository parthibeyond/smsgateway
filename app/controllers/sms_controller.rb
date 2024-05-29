class SmsController < ApplicationController
  before_action :authenticate

  def inbound
    sms_params.validate_inbound_condition
    if sms_params.errors.empty?
      cache_for_inbound(sms_params.from, sms_params.to) if sms_params.text.strip.eql?('STOP')
      render json: {message: 'inbound sms ok', error: ''}
    else
      render json: {message: '', error: sms_params.errors.full_messages.join(', ')}
    end
  rescue StandardError => e
    render json: {message: '', error: 'unknown failure'}
  end
  
  def outbound
    sms_params.validate_outbound_condition
    if sms_params.errors.empty?
      increment_sms_count(sms_params.from)
      render json: {message: 'outbound sms ok', error: ''}
    else
      render json: {message: '', error: sms_params.errors.full_messages.join(', ')}
    end
  rescue StandardError => e
    render json: {message: '', error: 'unknown failure'}
  end

  private

  def sms_params
    @sms_params ||= Sms.new(params.permit(:from, :to, :text).merge(account: @current_account))
  end

  def increment_sms_count(from)
    count = $redis.incr("#{from}_count")
    $redis.expire("#{from}_count", 24.hours) if count == 1
  end

  def cache_for_inbound(from, to)
    $redis.set("#{from}_#{to}", true, ex: 4.hours)
  end
end
