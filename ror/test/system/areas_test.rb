require "application_system_test_case"

class AreasTest < ApplicationSystemTestCase
  setup do
    @area = areas(:one)
  end

  test "visiting the index" do
    visit areas_url
    assert_selector "h1", text: "Areas"
  end

  test "should create area" do
    visit areas_url
    click_on "New area"

    fill_in "Hierarchy", with: @area.hierarchy
    check "Isdefault" if @area.isDefault
    fill_in "Name", with: @area.name
    fill_in "User", with: @area.user_id
    click_on "Create Area"

    assert_text "Area was successfully created"
    click_on "Back"
  end

  test "should update Area" do
    visit area_url(@area)
    click_on "Edit this area", match: :first

    fill_in "Hierarchy", with: @area.hierarchy
    check "Isdefault" if @area.isDefault
    fill_in "Name", with: @area.name
    fill_in "User", with: @area.user_id
    click_on "Update Area"

    assert_text "Area was successfully updated"
    click_on "Back"
  end

  test "should destroy Area" do
    visit area_url(@area)
    click_on "Destroy this area", match: :first

    assert_text "Area was successfully destroyed"
  end
end
