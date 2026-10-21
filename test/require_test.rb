# frozen_string_literal: true

require 'test_helper'
require 'open3'

class RequireTest < ActiveSupport::TestCase
  test "require 'jb' without Rails doesn't raise" do
    _out, err, status = Open3.capture3(RbConfig.ruby, '-I', File.expand_path('../lib', __dir__), '-e', "require 'jb'; p Jb::VERSION")

    assert status.success?, err
  end
end
