require 'test_helper'

class ChefsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "chef", email: "chef@example.com", password: "password", password_confirmation: "password")
    @recipeOne = Recipe.create(name: "Vegetable salat", description: "Great salat", chef: @chef)
    @recipeTwo = Recipe.create(name: "Hot soup", description: "A yummy soup", chef: @chef)
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
    patch chef_path(@chef), params: { chef: { chefname: "kruemel", email: "kruemel@example.com" } }
    assert_redirected_to @chef
    assert_not flash.empty?
    @chef.reload
    assert_match "kruemel", @chef.chefname
    assert_match "kruemel@example.com", @chef.email
  end
  
end
