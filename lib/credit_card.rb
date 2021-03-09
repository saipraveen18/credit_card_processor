class CreditCard
  attr_accessor :name, :card_number, :limit, :balance

  ERROR = "error"

  def initialize(name, number, limit)
    @name = name

    if is_lunh_valid?(number)
      @card_number = number
      @limit = limit
      @balance = 0
    else
      @card_number = ERROR
      @balance = ERROR
    end
  end

  def is_lunh_valid?(number)
    luhn_checksum(number)
  end

  def luhn_checksum(number)
    number.chars.reverse.each_slice(2).inject(0) do |sum, (a, b)|
      double = b.to_i * 2
      sum + a.to_i + (double > 9 ? double - 9 : double)
    end % 10 == 0
  end

  def charge(amount)
    return nil unless is_valid_entry

    coerced_amount = amount.delete_prefix("$").to_i
    coerced_limit = @limit.delete_prefix("$").to_i

    if  @balance + coerced_amount < coerced_limit
      self.balance = @balance + coerced_amount
    else
      @balance
    end
  end

  def credit(amount)
    coerced_amount = amount.delete_prefix("$").to_i

    if is_valid_entry
      self.balance = @balance - coerced_amount
    else
      @balance
    end
  end

  def is_valid_entry
    @card_number != ERROR
  end
end