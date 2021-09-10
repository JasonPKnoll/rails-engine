# frozen_string_literal: true

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
            .where('transactions.result =?', 'success')
            .where('invoices.status = ?', 'shipped')
            .group('merchants.id')
            .order('revenue DESC')
            .limit(total)
  end

  def self.find_merchant_rev(params_id)
    joins(items: [invoices: :transactions])
      .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .where('invoices.status = ?', 'shipped')
      .where('transactions.result = ?', 'success')
      .where('merchants.id = ?', params_id)
      .group('merchants.id')
      .order('revenue DESC')
      .first
  end

  def self.total_potential_revenue(number)
    joins(items: [invoices: :transactions])
    .select('merchants.*, SUM(invoice_items.quantity * invoice_items.unit_price) AS potential_revenue')
    .where.not('invoices.status = ?', 'shipped')
    .group('merchants.id')
    .order('potential_revenue DESC')
    .limit(number)
  end
end
