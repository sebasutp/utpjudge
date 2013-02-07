# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Judge2::Application.config.secret_token = ENV.fetch('SECRET_TOKEN') do
  "668c3c6e280b6d6f79d997e1b5cd4201b6dec9811adddf9e9f9f20dfbc5071fbd35be048a785780c958771889ebc83efa4f6c072d73b775c60d1b43301e5a184"
end
