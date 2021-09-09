class Item < ApplicationRecord
  belongs_to :merchant

  def self.find_all_by_name(search)
    items = Item.arel_table
    Item.where(items[:name].matches("%#{search}%")).order(:name)

    # where("name.downcase ILIKE ?", "#{name}%.").order(:name)
  end
end
