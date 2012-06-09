require File.dirname(__FILE__) + '/spec_helper'

describe Netzke::MongoidComponentState do
  def set_current_user(user)
    Netzke::MongoidComponentState.init(:current_user => user)
  end
  
  def masquerade_as(hsh)
    Netzke::MongoidComponentState.init(:session => {:masquerade_as => hsh})
  end
  
  def reset_masquerade
    Netzke::MongoidComponentState.init(:session => {})
  end
  
  def set_component(component)
    Netzke::MongoidComponentState.init(:component => component)
  end
  
  it "should propagate settings down the hierarchy when masquerading" do
    # role1 = FactoryGirl.create :role
    
    user1_with_role1 = FactoryGirl.create :user, :role => 'user'
    user2_with_role1 = FactoryGirl.create :user, :role => 'user'
    
    set_component("some_component")
    
    Netzke::MongoidComponentState.init(:session => {})

    # set value for first user
    set_current_user(user1_with_role1)
    Netzke::MongoidComponentState.update_state!(:some_option => 1)
    Netzke::MongoidComponentState.state.should == {'some_option' => 1}
    
    # set value for second user
    set_current_user(user2_with_role1)
    Netzke::MongoidComponentState.update_state!(:some_option => 2)
    Netzke::MongoidComponentState.state.should == {'some_option' => 2}
    
    # masquerade as those user's role, and change the value
    masquerade_as(:role => 'user')
    Netzke::MongoidComponentState.update_state!(:some_option => 3)
    
    reset_masquerade

    # switch the users and check the values
    set_current_user(user1_with_role1)
    Netzke::MongoidComponentState.state.should == {'some_option' => 3}
    
    set_current_user(user2_with_role1)
    Netzke::MongoidComponentState.state.should == {'some_option' => 3}
    
    # Masquerade as world and override the values again
    masquerade_as(:world => true)
    Netzke::MongoidComponentState.update_state!(:some_option => 4)
    
    reset_masquerade
    
    # switch the users and check the values
    set_current_user(user1_with_role1)
    Netzke::MongoidComponentState.state.should == {'some_option' => 4}
    
    set_current_user(user2_with_role1)
    Netzke::MongoidComponentState.state.should == {'some_option' => 4}
    
  end
  
  it "should be possible to delete keys-value pairs by setting the value to nil" do
    Netzke::MongoidComponentState.state.should be_nil
    Netzke::MongoidComponentState.update_state!(:some_option => 1)
    Netzke::MongoidComponentState.state.should == {'some_option' => 1}
    Netzke::MongoidComponentState.update_state!(:some_option => nil)
    Netzke::MongoidComponentState.state.should == {}
  end
end