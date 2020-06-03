# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  subject { described_class.paginate(cursor, page, page_size) }

  before(:all) { FactoryBot.create_list(:address, 12) }

  let(:cursor) { first_page_prev_cursor }
  let(:page_size) { 5 }
  let(:page) { 'next' }

  let(:first_page_prev_cursor) do
    described_class.order(created_at: :desc).limit(page_size).first.id
  end

  let(:second_page) do
    described_class.order(created_at: :desc).offset(page_size).limit(page_size)
  end
  let(:second_page_next_cursor) { second_page.last.id }
  let(:second_page_prev_cursor) { second_page.first.id }

  let(:last_page) do
    described_class.order(created_at: :desc).offset(page_size * 2).limit(page_size)
  end
  let(:last_page_next_cursor) { last_page.last.id }
  let(:last_page_prev_cursor) { last_page.first.id }

  let(:records) { subject }

  context 'when cursor is nil' do
    let(:cursor) { nil }

    it 'returns records from first page' do
      expect(records.size).to eq(page_size)
      expect(records.first.id).to eq(first_page_prev_cursor)
    end
  end

  context 'when cursor on first page' do
    context 'when prev page' do
      let(:cursor) { first_page_prev_cursor }
      let(:page) { 'previous' }

      it 'raise EndOfListError' do
        expect { records }.to raise_error(EndOfListError)
      end
    end
  end

  context 'when cursor on second page' do
    context 'when next page' do
      let(:cursor) { second_page_next_cursor }

      it 'returns records from last page' do
        expect(records.size).to eq(2)
        expect(records.first.id).to eq(last_page_prev_cursor)
      end
    end

    context 'when prev page' do
      let(:cursor) { second_page_prev_cursor }
      let(:page) { 'previous' }

      it 'returns records from prev page' do
        expect(records.size).to eq(page_size)
        expect(records.first.id).to eq(first_page_prev_cursor)
      end
    end
  end

  context 'when cursor on last page' do
    context 'when next page' do
      let(:cursor) { last_page_next_cursor }
      let(:page) { 'next' }

      it 'raise EndOfListError' do
        expect { records }.to raise_error(EndOfListError)
      end
    end
  end

  context 'when cursor id is incorrect' do
    context 'when cursor id is less than possible' do
      let(:cursor) { -1 }

      it 'returns empty array of records' do
        expect { records }.to raise_error(EndOfListError)
      end
    end

    context 'when cursor id is more than possible' do
      let(:cursor) { 1000 }

      it 'returns records from first page' do
        expect(records.size).to eq(page_size)
        expect(records.first.id).to eq(first_page_prev_cursor)
      end
    end

    context 'when cursor id is incorrect' do
      let(:cursor) { :wrong }

      it 'raise error' do
        expect { records }.to raise_error(ActiveRecord::StatementInvalid)
      end
    end
  end
end
