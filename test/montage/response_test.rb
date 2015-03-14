require File.dirname(__FILE__) + '/../minitest_helper.rb'
require 'montage/response'

class Montage::ReponseTest < Minitest::Test
  context "#success?" do
    should "be true if status is in the 200..299 range" do
      (200..299).each do |status|
        subject = Montage::Response.new(status, {})
        assert subject.success?
      end
    end

    should "be false if the status code is 404" do
      subject = Montage::Response.new(404, {})
      assert !subject.success?
    end

    should "be false if the status code is 415" do
      subject = Montage::Response.new(415, {})
      assert !subject.success?
    end

    should "be false if the status code is 500" do
      subject = Montage::Response.new(500, {})
      assert !subject.success?
    end
  end

  context "#members" do
    setup do
      @body = {
        "data" => {
          "token" => "fdjsklajdflkj3iq09h598"
        }
      }

      @subject = Montage::Response.new(200, @body, "token")
    end

    should "parse the response properly and make the members available via a method call" do
      assert @subject.token.is_a?(Montage::Token)
      assert_equal "fdjsklajdflkj3iq09h598", @subject.token.value
    end
  end
end