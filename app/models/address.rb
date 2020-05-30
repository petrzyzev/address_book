# frozen_string_literal: true

class Address < ApplicationRecord
  PAGE_SIZE = 5

  def self.paginate(cursor, page_size = PAGE_SIZE)
    cursor ||= order(created_at: :desc).first.id

    previous_cursor = limit(page_size)
                      .order(created_at: :asc).where('id > ?', cursor).ids.last

    records = limit(PAGE_SIZE).order(created_at: :desc).where('id <= ?', cursor)

    next_cursor = order(created_at: :desc)
                  .find_by('id < ?', records.ids.last)&.id

    { previous_cursor: previous_cursor,
      records:         records,
      next_cursor:     next_cursor }
  end
end
