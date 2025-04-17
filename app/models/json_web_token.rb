class JsonWebToken

  JWT_SECRET = ENV.fetch('JWT_SECRET_KEY') { raise "JWT_SECRET_KEY is missing in environment variables" }

  def self.encode(payload)
    JWT.encode(payload, JWT_SECRET_KEY, nil, 'HS256')
  end

  def self.decode(token)
    JWT.decode(token, JWT_SECRET_KEY, nil), true, { algorithm: 'HS256' }).first
  rescue
    nil
  end
end
