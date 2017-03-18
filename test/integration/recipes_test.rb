require 'test_helper'

class RecipesTest < ActionDispatch::IntegrationTest
  
  def setup
    @chef = Chef.create!(chefname: "chef", email: "chef@example.com")
    @recipeOne = Recipe.create(name: "Vegetable salat", description: "Great salat", chef: @chef)
    @recipeTwo = Recipe.create(name: "Hot soup", description: "A yummy soup", chef: @chef)
  end
  
  test 'should get recipes index' do
    get recipes_url
    assert_response :success
  end
  
  test 'should get recipes listing' do
    get recipes_url
    assert_template 'recipes/index'
    assert_match @recipeOne.name, response.body
    assert_select "a[href=?]", recipe_path(@recipeOne), text: @recipeOne.name
    assert_match @recipeTwo.name, response.body
    assert_select "a[href=?]", recipe_path(@recipeTwo), text: @recipeTwo.name
  end
  
  test 'should get recipes show' do
    get recipe_path(@recipeOne)
    assert_template 'recipes/show'
    assert_match @recipeOne.name, response.body
    assert_match @recipeOne.description, response.body
    assert_match @chef.chefname, response.body
    assert_select 'a[href=?]', edit_recipe_path(@recipeOne), text: "Edit this recipe"
    assert_select 'a[href=?]', recipe_path(@recipeOne), text: "Delete this recipe"
    assert_select 'a[href=?]', recipes_path, text: "Return to recipes listing"
  end
  
  test 'create new valid recipe' do
    get new_recipe_path
    assert_template 'recipes/new'
    name_of_recipe = "chicken saute"
    description_of_recipe = "add chicken, add vegetables, cook for 20 minutes, servie delicious meal"
    assert_difference 'Recipe.count', 1 do
      post recipes_path, params: { recipe: { name: name_of_recipe, description: description_of_recipe } }
    end
    follow_redirect!
    assert_match name_of_recipe.capitalize, response.body
    assert_match description_of_recipe, response.body
  end
  
  test 'reject invalid recipe submissions' do
    get new_recipe_path
    assert_template 'recipes/new'
    assert_no_difference 'Recipe.count' do
      post recipes_path, params: { recipe: { name: " ", description: " "} }
    end
    assert_template 'recipes/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
end