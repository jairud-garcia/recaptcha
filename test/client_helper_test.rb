require 'test/helper'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash'

describe Recaptcha::ClientHelper do
  include Recaptcha::ClientHelper

  describe "ssl" do
    def url(options={})
      "\"#{Recaptcha.configuration.api_server_url(options)}\""
    end

    it "uses ssl when ssl by default is on" do
      Recaptcha.configuration.use_ssl_by_default = true
      recaptcha_tags.must_include url(:ssl=>true)
    end

    it "does not use ssl when ssl by default is off" do
      recaptcha_tags.must_include url(:ssl=>false)
    end

    it "does not use ssl when ssl by default is overwritten" do
      Recaptcha.configuration.use_ssl_by_default = true
      recaptcha_tags(:ssl=>false).must_include url(:ssl=>false)
    end

    it "uses ssl when ssl by default is overwritten to true" do
      recaptcha_tags(:ssl=>true).must_include url(:ssl=>true)
    end
  end

  describe "noscript" do
    it "does not adds noscript tags when noscript is given" do
      recaptcha_tags(:noscript=> false).wont_include "noscript"
    end

    it "does not add noscript tags" do
      recaptcha_tags.must_include "noscript"
    end
  end

  describe "stoken" do
    let(:regex) { /" data-stoken="[1]" / }

    it "generates a secure token" do
      refute_nil Recaptcha::Token.secure_token
    end
    #Improving that test cause can fail by hash undeterministic order 
    #changed cause error with stoken (bad token)
    it "avoid security token" do
      html = recaptcha_tags(:stoken=> true)
      html.sub!(/data-stoken="[^"]+"/, 'data-stoken="TOKEN"')
      html = (/<div(( )+[a-z\--="]+)*( data-stoken="TOKEN")(( )+[a-z\--="]+)*( )*>/i).match(html).to_s
      html.must_include "class=\"g-recaptcha\""
      html.must_include "data-sitekey=\"0000000000000000000000000000000000000000\""
      html.must_include "data-stoken=\"TOKEN\""
    end

    it "does not add a security token when specified" do
      html = recaptcha_tags(:stoken => false)
      html.must_include "<div class=\"g-recaptcha\" data-sitekey=\"0000000000000000000000000000000000000000\"></div>"
    end

    it "raises if secure_token is called without a private_key" do
      Recaptcha.configuration.private_key = nil
      assert_raises Recaptcha::RecaptchaError do
        Recaptcha::Token.secure_token
      end
    end
  end
  #Modified cause can fail for hash order
  it "can include size" do
    html = recaptcha_tags(:size=> 10)
    html.sub!(/data-stoken="[^"]+"/, 'data-stoken="TOKEN"')
    html = (/<div(( )+[a-z\--="]+)*( class="g-recaptcha")(( )+[a-z\--="]+)*( )*>/i).match(html).to_s
    html.must_include "data-size=\"10\""
    html.must_include "data-sitekey=\"0000000000000000000000000000000000000000\""
  end

  it "raises withut public key" do
    Recaptcha.configuration.public_key = nil
    assert_raises Recaptcha::RecaptchaError do
      recaptcha_tags
    end
  end
end
