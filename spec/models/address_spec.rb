# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  before(:all) { FactoryBot.create_list(:address, 12) }

  subject { described_class.paginate(cursor, page_size) }

  let(:cursor) { first_page_cursor }
  let(:page_size) { 5 }
  let(:first_page_cursor) { described_class.order(created_at: :desc).first.id }
  let(:second_page_cursor) do
    described_class.order(created_at: :desc).offset(page_size).first.id
  end
  let(:last_page_cursor) do
    described_class.order(created_at: :desc).offset(page_size * 2).first.id
  end
  let(:records) { subject[:records] }
  let(:next_cursor) { subject[:next_cursor] }
  let(:previous_cursor) { subject[:previous_cursor] }

  context 'when cursor is nil' do
    let(:cursor) { nil }

    it 'returns records from first page' do
      expect(records.size).to eq(page_size)
      expect(records.first.id).to eq(first_page_cursor)
      expect(previous_cursor).to be_nil
      expect(next_cursor).to eq(second_page_cursor)
    end
  end

  context 'when page_size is nil' do
    let(:page_size) { nil }

    it 'show 5 records by default' do
      expect(records.size).to eq(5)
    end
  end

  context 'when cursor on first page' do
    it 'returns records from second page' do
      expect(records.size).to eq(page_size)
      expect(records.first.id).to eq(first_page_cursor)
      expect(previous_cursor).to be_nil
      expect(next_cursor).to eq(second_page_cursor)
    end
  end

  context 'when cursor on second page' do
    let(:cursor) { second_page_cursor }

    it 'returns records from second page' do
      expect(records.size).to eq(page_size)
      expect(records.first.id).to eq(second_page_cursor)
      expect(previous_cursor).to eq(first_page_cursor)
      expect(next_cursor).to eq(last_page_cursor)
    end
  end

  context 'when cursor on last page' do
    let(:cursor) { last_page_cursor }

    it 'returns records from last page' do
      expect(records.size).to eq(2)
      expect(records.first.id).to eq(last_page_cursor)
      expect(previous_cursor).to eq(second_page_cursor)
      expect(next_cursor).to be_nil
    end
  end

  context 'when cursor id is incorrect' do
    context 'when cursor id is less than possible' do
      let(:cursor) { -1 }

      it 'returns empty array of records' do
        expect(records.size).to eq(0)
        expect(previous_cursor).to be_nil
        expect(next_cursor).to be_nil
      end
    end

    context 'when cursor id is more than possible' do
      let(:cursor) { 1000 }

      it 'returns records from first page' do
        expect(records.size).to eq(page_size)
        expect(records.first.id).to eq(first_page_cursor)
        expect(previous_cursor).to be_nil
        expect(next_cursor).to eq(second_page_cursor)
      end
    end

    context 'when cursor id is incorrect' do
      let(:cursor) { :wrong }

      it 'raise error' do
        expect { subject }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end
end
