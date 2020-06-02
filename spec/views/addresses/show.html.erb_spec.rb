# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'addresses/show', type: :view do
  before(:each) do
    address = FactoryBot.create(:address)
    @address = assign(:address, address)
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Surname/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/Phone/)
  end
end
