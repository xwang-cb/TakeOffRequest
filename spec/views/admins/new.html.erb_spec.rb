require 'rails_helper'

RSpec.describe "admins/new", type: :view do
  before(:each) do
    assign(:admin, Admin.new(
      :name => "MyString",
      :hashed_password => "MyString",
      :salt => "MyString"
    ))
  end

  it "renders new admin form" do
    render

    assert_select "form[action=?][method=?]", admins_path, "post" do

      assert_select "input#admin_name[name=?]", "admin[name]"

      assert_select "input#admin_hashed_password[name=?]", "admin[hashed_password]"

      assert_select "input#admin_salt[name=?]", "admin[salt]"
    end
  end
end
