require 'test_helper'

class FieldCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @field_category = field_categories(:one)
  end

  test "should get index" do
    get field_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_field_category_url
    assert_response :success
  end

  test "should create field_category" do
    assert_difference('FieldCategory.count') do
      post field_categories_url, params: { field_category: { name: @field_category.name } }
    end

    assert_redirected_to field_category_url(FieldCategory.last)
  end

  test "should show field_category" do
    get field_category_url(@field_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_field_category_url(@field_category)
    assert_response :success
  end

  test "should update field_category" do
    patch field_category_url(@field_category), params: { field_category: { name: @field_category.name } }
    assert_redirected_to field_category_url(@field_category)
  end

  test "should destroy field_category" do
    assert_difference('FieldCategory.count', -1) do
      delete field_category_url(@field_category)
    end

    assert_redirected_to field_categories_url
  end
end
