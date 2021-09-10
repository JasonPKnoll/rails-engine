# frozen_string_literal: true

class Invoice < ApplicationRecord
  validates_presence_of :status, :merchant_id, :customer_id

  belongs_to :customer
  belongs_to :merchant

  has_many :items, through: :invoice_items
  has_many :invoice_items
  has_many :transactions, dependent: :destroy
end
