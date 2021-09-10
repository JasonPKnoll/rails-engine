class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices
  has_many :customers, through: :invoices
  has_many :invoice_items, through: :invoices
  has_many :transactions, through: :invoices

  def self.find_by_name(search)
    merchants = Merchant.arel_table
    Merchant.where(merchants[:name].matches("%#{search}%")).order(:name).first

    # where("name.downcase ILIKE ?", "#{name}%.").order(:name).first
  end

  def find_merchant_rev
    # require "pry"; binding.pry
  end
end
