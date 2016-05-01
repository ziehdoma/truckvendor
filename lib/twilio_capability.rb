class TwilioCapability
  def self.generate(role)
    # To find TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN visit
    # https://www.twilio.com/user/account
    account_sid = ENV['SK65f29896cba444f5a9522ea65eabf357']
    auth_token  = ENV['FPUEFRB6hTBX5V91LqNXQMEHQu7kReMu']
    capability = Twilio::Util::Capability.new account_sid, auth_token

    application_sid = ENV['TWIML_APPLICATION_SID']
    capability.allow_client_outgoing application_sid
    capability.allow_client_incoming role

    capability.generate
  end
end


