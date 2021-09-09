class Merchant < ApplicationRecord
  has_many :items

  def self.find_by_name(search)
    merchants = Merchant.arel_table
    Merchant.where(merchants[:name].matches("%#{search}%")).order(:name).first

    # where("name.downcase ILIKE ?", "#{name}%.").order(:name).first
  end
end
