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

  def self.find_most_revenue(total)
    Merchant.joins(items: [invoices: :transactions])
            .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
            .where("transactions.result =?", "success")
            .where("invoices.status = ?", "shipped")
            .group("merchants.id")
            .order("revenue DESC")
            .limit(total)
  end

  def find_merchant_rev
    items.joins(invoices: :transactions)
         .where("invoices.status = ?", "shipped")
         .where("transactions.result = ?", "success")
         .sum("invoice_items.quantity * invoice_items.unit_price")
  end
end
