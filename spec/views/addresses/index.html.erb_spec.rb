# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'addresses/index', type: :view do
  before(:each) do
    addresses = FactoryBot.create_list(:address, 2)
    assign(:addresses, addresses)
  end

  it 'renders a list of addresses' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 2
    assert_select 'tr>td', text: 'Surname'.to_s, count: 2
    assert_select 'tr>td', text: 'Address'.to_s, count: 2
    assert_select 'tr>td', text: 'Phone'.to_s, count: 2
  end
end
