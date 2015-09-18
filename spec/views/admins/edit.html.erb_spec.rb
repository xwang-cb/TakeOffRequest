require 'rails_helper'

RSpec.describe "admins/edit", type: :view do
  before(:each) do
    @admin = assign(:admin, Admin.create!(
      :name => "MyString",
      :hashed_password => "MyString",
      :salt => "MyString"
    ))
  end

  it "renders the edit admin form" do
    render

    assert_select "form[action=?][method=?]", admin_path(@admin), "post" do

      assert_select "input#admin_name[name=?]", "admin[name]"

      assert_select "input#admin_hashed_password[name=?]", "admin[hashed_password]"

      assert_select "input#admin_salt[name=?]", "admin[salt]"
    end
  end
end
