require 'rails_helper'

RSpec.describe "addresses/new", type: :view do
  before(:each) do
    assign(:address, Address.new(
      name: "MyString",
      surname: "MyString",
      address: "MyString",
      phone: "MyString"
    ))
  end

  it "renders new address form" do
    render

    assert_select "form[action=?][method=?]", addresses_path, "post" do

      assert_select "input[name=?]", "address[name]"

      assert_select "input[name=?]", "address[surname]"

      assert_select "input[name=?]", "address[address]"

      assert_select "input[name=?]", "address[phone]"
    end
  end
end
