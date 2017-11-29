# Sets up twitter
# Chris Loftus
require 'oauth'

# Twitter OAuth settings for 2-legged authentication
TWOAUTH_SITE = 'https://api.twitter.com/1.1/'


# To use Twitter OAuth you will need to:
# 1. create a Twitter application (see http://dev.twitter.com/apps). Since 2-legged
#    authentication (rather than 3) you don't need to specify a callback url
# 2. obtain the consumer key and secret and assign appropriately below. Create
#    a config/local_env.yml file in the root of the rails project and assign the values
#    to the environment variables there. Make sure you add /config/local_env.yml to .gitignore
#    so that if you are using a public repository on Github you don't expose
#    the local_env.yml file to the world! I have already updated config/application.rb
#    to read and use this yml file.
# 3. since 2-legged oauth you can avoid all the redirect to authenticate
#    and access Twitter directly with your own access token and secret. These
#    can be obtained from your Twitter application access token page. Assign these
#    to the appropriate constants below.
# I suggest you read about OAuth to understand what the protocol etc does.

# Consumer key and secret for general access to Twitter site
TWOAUTH_CONSUMER_KEY = ENV['TWOAUTH_CONSUMER_KEY']
TWOAUTH_CONSUMER_SECRET = ENV['TWOAUTH_CONSUMER_SECRET']

# Access token and secret used for single access use
TWOAUTH_ACCESS_TOKEN = ENV['TWOAUTH_ACCESS_TOKEN']
TWOAUTH_ACCESS_SECRET = ENV['TWOAUTH_ACCESS_SECRET']

# Prepare the access token here
consumer = OAuth::Consumer.new(TWOAUTH_CONSUMER_KEY, TWOAUTH_CONSUMER_SECRET,
                               {site: TWOAUTH_SITE,
                                scheme: :header
                               })

# Now create the access token object from passed values
token_hash = {oauth_token: TWOAUTH_ACCESS_TOKEN,
              oauth_token_secret: TWOAUTH_ACCESS_SECRET
}
TWITTER_ACCESS_TOKEN = OAuth::AccessToken.from_hash(consumer, token_hash)
