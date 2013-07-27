require_relative './spec_helper'

describe User do
  
  before :each do
    @user = User.new 'test'
    @user.stub(:putsnil) { nil }
  end

  describe "#putsnil" do
  
    it "should return nil" do
      @user.putsnil.should eql nil
    end
  
  end

  describe "#name" do
  
    it "should return name" do
      @user.name.should eql "test"
    end
  
  end

end

