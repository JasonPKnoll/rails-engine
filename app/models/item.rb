# frozen_string_literal: true

class Item < ApplicationRecord
  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.find_all_by_name(search)
    items = Item.arel_table
    Item.where(items[:name].matches("%#{search}%")).order(:name)

    # where("name.downcase ILIKE ?", "#{name}%.").order(:name)
  end

  def self.find_most_revenue(cap)
    joins(invoices: :transactions)
      .select('items.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .where('transactions.result = ?', 'success')
      .where('invoices.status = ?', 'shipped')
      .group('items.id')
      .order('revenue DESC')
      .limit(cap)
  end
end
