require_relative 'credit_card'

class CardProcessor
  attr_accessor :entries, :card_activity

  def initialize(entries)
    @card_activity = {}
    @entries = entries
  end

  def process_entry
    @entries.each do |entry|
      do_action(entry)
    end
    self
  end

  def do_action(entry)
    input_entry = entry.split(' ')
    action = input_entry[0]
    case action
    when 'Add'
      add_entry(entry)
    when 'Charge'
      charge_amount(entry)
    when 'Credit'
      credit_amount(entry)
    end
  end

  def add_entry(entry)
    _action, name, card_number, limit = entry.split(' ')
    @card_activity[name] = CreditCard.new(name, card_number, limit)
  end

  def charge_amount(entry)
    _action, name, amount = entry.split(' ')
    if @card_activity[name]
      @card_activity[name].charge(amount)
    else
      "No credit card available to charge with name #{name}"
    end
  end

  def credit_amount(entry)
    _action, name, amount = entry.split(' ')
    if @card_activity[name]
      @card_activity[name].credit(amount)
    else
      "No credit card available to credit with name #{name}"
    end
  end

  def display_statement
    @card_activity.each do |key, _value|
      name = key
      balance = @card_activity[key].balance
      value = balance == 'error' ? CreditCard::ERROR : "$" + balance.to_s
      puts(name + ": " + value.strip)
    end
  end
end