require 'test_helper'

class ChefsShowTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "chef", email: "chef@example.com", password: "password", password_confirmation: "password")
    @recipeOne = Recipe.create(name: "Vegetable salat", description: "Great salat", chef: @chef)
    @recipeTwo = Recipe.create(name: "Hot soup", description: "A yummy soup", chef: @chef)
  end
  
  test 'should get chefs show' do
    get chef_path(@chef)
    assert_template 'chefs/show'
    assert_select "a[href=?]", recipe_path(@recipeOne), text: @recipeOne.name
    assert_select "a[href=?]", recipe_path(@recipeTwo), text: @recipeTwo.name
    assert_match @recipeOne.description, response.body
    assert_match @recipeTwo.description, response.body
    assert_match @chef.chefname, response.body
  end
  
end
