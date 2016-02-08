require 'bundler/setup'
require 'maxitest/autorun'
require 'mocha/setup'
require 'webmock/minitest'
require 'cgi'
require 'recaptcha'
require 'i18n'

ENV.delete('RAILS_ENV')
ENV.delete('RACK_ENV')

I18n.enforce_available_locales = false

# Minitest::Test.send(:prepend, Module.new do
#   def setup
#     super
#     Recaptcha.configure do |config|
#       config.public_key = '0000000000000000000000000000000000000000'
#       config.private_key = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
#       config.use_ssl_by_default = Recaptcha::USE_SSL_BY_DEFAULT
#     end
#   end
# end)
Minitest::Test.class_eval do
  def setup
    super
    Recaptcha.configure do |config|
      config.public_key = '0000000000000000000000000000000000000000'
      config.private_key = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
      config.use_ssl_by_default = Recaptcha::USE_SSL_BY_DEFAULT
    end
    SecureRandom.module_eval do
      def self.uuid
        ary = self.random_bytes(16).unpack("NnnnnN")
        ary[2] = (ary[2] & 0x0fff) | 0x4000
        ary[3] = (ary[3] & 0x3fff) | 0x8000
        "%08x-%04x-%04x-%04x-%04x%08x" % ary
      end
    end
    Base64.module_eval do
      def self.urlsafe_encode64(value)
        URI.escape(self.encode64(value))
      end
    end
    URI.module_eval do
      def self.encode_www_form(enum)
        enum.map{|k,v| "#{CGI.escape(k.to_s)}=#{CGI.escape(v.to_s)}"}.join('&')
      end
    end
  end
end
