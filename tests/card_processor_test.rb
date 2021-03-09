require_relative '../lib/card_processor'

require "test/unit"

class CardProcessorTest < Test::Unit::TestCase

  def test_process_entry
    input  = "Add Tom 4111111111111111 $1000"
    card_processor = CardProcessor.new([input]).process_entry
    assert_equal(1,   card_processor.card_activity.length)
  end

  def test_add_entry
    input  = "Add Tom 4111111111111111 $1000"
    added_credit_card = CardProcessor.new([]).add_entry(input)
    assert_equal('Tom',   added_credit_card.name)
  end

  def test_add_entry_with_zero_balance
    input  = "Add Tom 4111111111111111 $1000"
    added_credit_card = CardProcessor.new([]).add_entry(input)
    assert_equal(0,   added_credit_card.balance)
  end

  def test_charge_amount
    card_processor = CardProcessor.new(['Add Tom 4111111111111111 $1000']).process_entry
    card_processor.charge_amount('Charge Tom $500')
    assert_equal(card_processor.card_activity['Tom'].balance, 500)
  end

  def test_credit_amount
    card_processor = CardProcessor.new(['Add Tom 4111111111111111 $300']).process_entry
    card_processor.credit_amount('Credit Tom $200')
    assert_equal(card_processor.card_activity['Tom'].balance, -200)
  end

  def test_invalid_amount_account
    card_processor = CardProcessor.new(['Add Tom 1234567890123456 $10000']).process_entry
    assert_equal(card_processor.card_activity['Tom'].balance, "error")
  end

  def test_card_over_limit
    card_processor = CardProcessor.new(['Add Tom 4111111111111111 $500']).process_entry
    card_processor.charge_amount('Charge Tom $600')
    assert_equal(card_processor.card_activity['Tom'].balance, 0)
  end

  def test_error_message_if_no_card
    card_processor = CardProcessor.new(['Credit Tom 4111111111111111 $1000']).process_entry
    assert_equal(card_processor.charge_amount('Charge Tom $500'), 'No credit card available to charge with name Tom')
  end

  def test_negative_balance
    card_processor = CardProcessor.new(['Add Lisa 5454545454545454 $3000']).process_entry
    card_processor.charge_amount('Charge Lisa $7')
    card_processor.credit_amount('Credit Lisa $100')
    assert_equal(card_processor.card_activity['Lisa'].balance, -93)
  end
end