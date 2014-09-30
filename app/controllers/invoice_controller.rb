class InvoiceController < ApplicationController

  def index
    @invoices = Invoice.all
  end
  
end
