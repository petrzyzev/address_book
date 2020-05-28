# frozen_string_literal: true

class AddressExtractor
  PAGE_SIZE = 3

  def initialize(cursor = nil)
    @cursor = cursor
  end

  attr_accessor :cursor

  def records
    cursor ? sorted_addresses.where('id < ?', cursor) : sorted_addresses
  end

  def previous_page_cursor
    cursor ? sorted_addresses(:asc).where('id > ?', cursor).last : nil
  end

  private

  def limited_addresses
    @limited_addresses ||= Address.limit(PAGE_SIZE)
  end

  def sorted_addresses(rotation = :desc)
    limited_addresses.order(created_at: rotation)
  end
end
