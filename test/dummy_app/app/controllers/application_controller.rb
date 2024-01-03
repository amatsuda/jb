# frozen_string_literal: true

if ENV['API'] == '1'
  class ApplicationController < ActionController::API
  end
else
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  end
end
