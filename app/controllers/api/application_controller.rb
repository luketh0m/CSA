# Handles incoming user account HTTP JSON web service requests. This
# superclass extends the human web ApplicationController so that we
# inherit the authentication etc code. We change the behaviour of the
# protect from forgery checks (see below).
# @author Chris Loftus
class API::ApplicationController < ApplicationController
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # The REST client does not have the authenticity token so
  # instead of raising an error we nullify the caller's
  # session object. We should be putting stuff in a session
  # anyway for a stateless RESTful web service.

  protect_from_forgery with: :null_session

end
