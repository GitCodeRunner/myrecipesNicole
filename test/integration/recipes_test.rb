require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "chef", email: "chef@example.com")
    @recipeOne = Recipe.create(name: "vegetable salat", description: "great salat", chef: @chef)
    @recipeTwo = Recipe.create(name: "hot soup", description: "a yummy soup", chef: @chef)
  end
  
  test 'should get recipes index' do
    get recipes_url
    assert_response :success
  end
  
  test 'should get recipes listing' do
    get recipes_url
    assert_template 'recipes/index'
    assert_match @recipeOne.name, response.body
    assert_match @recipeTwo.name, response.body
  end
  
end