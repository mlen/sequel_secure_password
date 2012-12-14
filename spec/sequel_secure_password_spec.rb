require 'spec_helper'

describe "model using Sequel::Plugins::SecurePassword" do
  subject(:user) { User.new }

  context "with blank password" do
    before { user.password = "" }

    it { should_not be_valid }
  end

  context "with nil password" do
    before { user.password = nil }

    it { should_not be_valid }
  end

  context "without setting a password" do
    it { should_not be_valid }
  end

  context "without confirmation" do
    before { user.password = "foo" }

    it { should_not be_valid }
  end

  context "when password matches confirmation" do
    before { user.password = user.password_confirmation = "foo" }

    it { should be_valid }
  end

  describe "#authenticate" do
    let(:secret) { "foo" }
    before { user.password = secret }

    context "when authentication is successful" do
      it "returns the user" do
        user.authenticate(secret).should be user
      end
    end

    context "when authentication fails" do
      it { user.authenticate("").should be nil }
    end
  end

end
