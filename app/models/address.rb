# frozen_string_literal: true

class Address < ApplicationRecord
  # Default page size
  PAGE_SIZE = 5
  # Pagination cases
  CASES = { 'next'     => { order: :desc, condition: 'id < ?' },
            'previous' => { order: :asc, condition: 'id > ?' } }.freeze

  # Extract records by provided cursor and page params.
  def self.paginate(cursor, page, page_size = PAGE_SIZE)
    return first_page(page_size) unless CASES[page] && cursor

    request_params = CASES[page].merge(page_size: page_size, cursor: cursor)
    records = get_records(request_params)
    raise EndOfListError if records.empty?

    page == 'previous' ? records.reverse : records
  end

  # Returns a list matching request parameters
  def self.get_records(order:, condition:, page_size:, cursor:)
    order(created_at: order).where(condition, cursor).limit(page_size)
  end

  # Returns records from first page
  def self.first_page(page_size)
    order(created_at: :desc).limit(page_size)
  end
end

# Class of error, occurring when reaching the border of the list
class EndOfListError < StandardError
end
