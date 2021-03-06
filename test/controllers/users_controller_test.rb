require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user = users(:athens)
    @other_user = users(:bthens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end
  
  test 'non logged in should not get access to editing' do
    get :edit, id: @user
    assert_not flash.empty?
    assert_redirected_to login_path
  end
    
  test 'non logged in should not get access to patching' do
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_not flash.empty?
    assert_redirected_to login_path
  end
  
    
  test 'another logged in should not get access to editing' do
    log_in_as(@other_user)
    get :edit, id: @user
    assert_redirected_to root_path
  end
  
      
  test 'another logged in should not get access to patching' do
    log_in_as(@other_user)
    patch :update, id: @user, user: {name: @user.name, email: @user.email}
    assert_redirected_to root_path
  end
  
  test 'make sure users accessible to logged in' do
    get :index
    assert_redirected_to login_path
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
  assert_redirected_to login_path
  end

  test 'should redirect destroy when logged in as a non-admin' do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
  assert_redirected_to root_path
  end

  test 'should redirect when getting follower if not logged in' do
    get :following, id: @user
    assert_redirected_to login_path
  end
  
  test 'should redirect when getting following if not logged in' do
    get :followers, id: @user
    assert_redirected_to login_path
  end
  

end
