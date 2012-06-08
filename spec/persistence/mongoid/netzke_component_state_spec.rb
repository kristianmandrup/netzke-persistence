require File.dirname(__FILE__) + '/spec_helper'

describe Mongoid::Mongoid::NetzkeComponentState do
  def set_current_user(user)
    Mongoid::NetzkeComponentState.init(:current_user => user)
  end
  
  def masquerade_as(hsh)
    Mongoid::NetzkeComponentState.init(:session => {:masquerade_as => hsh})
  end
  
  def reset_masquerade
    Mongoid::NetzkeComponentState.init(:session => {})
  end
  
  def set_component(component)
    Mongoid::NetzkeComponentState.init(:component => component)
  end
  
  it "should propagate settings down the hierarchy when masquerading" do
    role1 = Factory(:role)
    
    user1_with_role1 = Factory(:user, :role => role1)
    user2_with_role1 = Factory(:user, :role => role1)
    
    set_component("some_component")
    
    Mongoid::NetzkeComponentState.init(:session => {})

    # set value for first user
    set_current_user(user1_with_role1)
    Mongoid::NetzkeComponentState.update_state!(:some_option => 1)
    Mongoid::NetzkeComponentState.state.should == {:some_option => 1}
    
    # set value for second user
    set_current_user(user2_with_role1)
    Mongoid::NetzkeComponentState.update_state!(:some_option => 2)
    Mongoid::NetzkeComponentState.state.should == {:some_option => 2}
    
    # masquerade as those user's role, and change the value
    masquerade_as(:role_id => role1.id)
    Mongoid::NetzkeComponentState.update_state!(:some_option => 3)
    
    reset_masquerade

    # switch the users and check the values
    set_current_user(user1_with_role1)
    Mongoid::NetzkeComponentState.state.should == {:some_option => 3}
    
    set_current_user(user2_with_role1)
    Mongoid::NetzkeComponentState.state.should == {:some_option => 3}
    
    # Masquerade as world and override the values again
    masquerade_as(:world => true)
    Mongoid::NetzkeComponentState.update_state!(:some_option => 4)
    
    reset_masquerade
    
    # switch the users and check the values
    set_current_user(user1_with_role1)
    Mongoid::NetzkeComponentState.state.should == {:some_option => 4}
    
    set_current_user(user2_with_role1)
    Mongoid::NetzkeComponentState.state.should == {:some_option => 4}
    
  end
  
  it "should be possible to delete keys-value pairs by setting the value to nil" do
    Mongoid::NetzkeComponentState.state.should be_nil
    Mongoid::NetzkeComponentState.update_state!(:some_option => 1)
    Mongoid::NetzkeComponentState.state.should == {:some_option => 1}
    Mongoid::NetzkeComponentState.update_state!(:some_option => nil)
    Mongoid::NetzkeComponentState.state.should == {}
  end
end