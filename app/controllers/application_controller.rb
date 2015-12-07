class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  def hello_world
    if this_is_a_really_really_really_really_really_really_really_really_really_long_variable
      true
    else
      'false'
    end
  end

  def this_is_a_really_really_really_really_really_really_really_really_really_long_variable
    'true'
  end

  def something
    'true'
  end
end
