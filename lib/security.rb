require 'openssl'
require "base64"
require 'digest'

class Security
  @key = '2T02j&xwE#tQA#e'
  def self.doHashSHA1(authorization)
    digest = OpenSSL::Digest.new('sha1')

    hmac = OpenSSL::HMAC.digest(digest, @key, authorization)
    return Base64.encode64(hmac)
  end
end
Security.doHashSHA1('GET590baa77d6b4ec0004902cbf')





