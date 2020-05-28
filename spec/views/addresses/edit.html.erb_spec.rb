require 'rails_helper'

RSpec.describe "addresses/edit", type: :view do
  before(:each) do
    @address = assign(:address, Address.create!(
      name: "MyString",
      surname: "MyString",
      address: "MyString",
      phone: "MyString"
    ))
  end

  it "renders the edit address form" do
    render

    assert_select "form[action=?][method=?]", address_path(@address), "post" do

      assert_select "input[name=?]", "address[name]"

      assert_select "input[name=?]", "address[surname]"

      assert_select "input[name=?]", "address[address]"

      assert_select "input[name=?]", "address[phone]"
    end
  end
end
