# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cveprovider_session',
  :secret      => '5e7c401e55fcdea7d5e799805fae518fd8e865b3863f89937bfb856b2aced8bcb7785837dccffca71197ef0500b6ea56a02fa00fae2af0b7c260a419a6df7662'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
