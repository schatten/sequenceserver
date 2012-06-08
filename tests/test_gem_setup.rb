require 'fileutils'
require 'net/http'
require 'minitest/spec'
require 'minitest/autorun'

# helpers
require File.join(File.dirname(__FILE__), 'env')

module SequenceServer
  module Test
    # make sure BLAST+ binaries are present, SequenceServer gem is installed, etc.
    Env.setup

    describe "gem" do
      include Client

      it "can launch SequenceServer from gem" do
        Server.run_from_gem
        ping.must_equal 200
        Server.kill
      end
    end
  end
end
