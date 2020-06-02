# frozen_string_literal: true

class Address < ApplicationRecord
  # Default page size
  PAGE_SIZE = 5

  # Extract records by provided cursor, and returns
  # cursors for previous and next pages.
  def self.paginate(cursor, page_size = PAGE_SIZE)
    cursor ||= order(created_at: :desc).first.id

    records = limit(PAGE_SIZE).order(created_at: :desc).where('id <= ?', cursor)
    return { records: records } if records.empty?

    previous_cursor = limit(page_size)
                      .order(created_at: :asc).where('id > ?', cursor).ids.last

    next_cursor = order(created_at: :desc)
                  .find_by('id < ?', records.ids.last)&.id

    { previous_cursor: previous_cursor,
      records:         records,
      next_cursor:     next_cursor }
  end
end
