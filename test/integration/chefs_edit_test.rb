require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "chef", email: "chef@example.com", password: "password", password_confirmation: "password")
    @chef2 = Chef.create!(chefname: "chef2", email: "chef2@example.com", password: "password", password_confirmation: "password", admin: true)
  end
  
  test 'reject an invalid edit' do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: " ", email: "chef@example.com" } }
    assert_template 'chefs/edit'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
  test 'accept valid edit' do
    sign_in_as(@chef, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "kruemel", email: "kruemel@example.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "kruemel", @chef.chefname
    assert_match "kruemel@example.com", @chef.email
  end
  
  test 'accept edit attempt by admin user' do
    sign_in_as(@chef2, "password")
    get edit_chef_path(@chef)
    assert_template 'chefs/edit'
    patch chef_path(@chef), params: { chef: { chefname: "chefedited", email: "chefedited@example.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "chefedited", @chef.chefname
    assert_match "chefedited@example.com", @chef.email
  end
  
  test 'redirect edit attempt by another non-admin user' do
    sign_in_as(@chef, "password")
    updated_name = "chef2edited"
    updated_email = "chef2edited@example.com"
    patch chef_path(@chef2), params: { chef: { chefname: updated_name, email: updated_email } }
    assert_redirected_to chefs_path
    assert_not flash.empty?
    @chef.reload
    assert_match "chef2", @chef2.chefname
    assert_match "chef2@example.com", @chef2.email
  end
  
end
