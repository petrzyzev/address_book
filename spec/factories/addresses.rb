# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    name { 'Name' }
    surname { 'Surname' }
    address { 'Address' }
    phone { 'Phone' }
  end
end
