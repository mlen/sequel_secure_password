require 'spec_helper'

describe "model with Sequel::Plugins::SecurePassword" do
  subject { User.new }

  it "is invalid with blank password" do
    subject.password = ""
    subject.should_not be_valid
  end

  it "is invalid with nil password" do
    subject.password = nil
    subject.should_not be_valid
  end

  it "is invalid without a password" do
    subject.should_not be_valid
  end

  it "is valid with password matching confirmation" do
    subject.password = "foo"
    subject.password_confirmation = "foo"

    subject.should be_valid
  end

  it "is invalid without password matching confirmation" do
    subject.password = "foo"
    subject.password_confirmation = "bar"

    subject.should_not be_valid
  end

  it "returns user when authentication is successful" do
    subject.password = "foo"
    subject.authenticate("foo").should be subject
  end

  it "returns nil when authentication fails" do
    subject.password = "foo"
    subject.authenticate("bar").should be nil
  end

end
