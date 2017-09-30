# This is the main class for saving the monetary value and handling
# different operations

require 'exceptions'

class Money
	attr_accessor :amount, :currency

	# Setting Euro as the default base currency
	@@base_currency = 'EUR'
	@@conversion_rates = {}

	# Constructor taking the money amount and the currency
	def initialize(amount, currency)
		@amount = amount.to_f
		@currency = currency
	end

	# Setting the different conversion rates with respect to
	# the base currency
	# == Parameters:
	# base_currency::
	# 	The base currency upon which the conversion rates should
	# 	calculate, example: 'EUR', 'USD'
	# conversion_rates::
	# 	A hash containing the different exchange rates' currencies
	# 	and values with respect to the base currency, example:
	# 	{
	# 		'USD'     => 1.11,
	# 		'Bitcoin' => 0.0047
	# 	}
	def self.conversion_rates(base_currency, conversion_rates)
		@@base_currency = base_currency
		@@conversion_rates = conversion_rates
	end

	# Converting the amount in the calling object upon the currency
	# entered, with respect to the base currency
	# == Returns:
	# 	A money object with the new amount and currency
	def convert_to(to_currency)
		from_currency = self.currency
		rate = Money.getRate(from_currency, to_currency)

		converted_amount = self.amount * rate

		Money.new(converted_amount, to_currency)
	end

	# overriding arithmetic operators
	def +(other)
		rate = Money.getRate(other.currency, self.currency)
		new_other_amount = other.amount * rate
		Money.new(self.amount + new_other_amount, self.currency)
	end

	def -(other)
		rate = Money.getRate(other.currency, self.currency)
		new_other_amount = other.amount * rate
		Money.new(self.amount - new_other_amount, self.currency)
	end

	def *(value)
		Money.new(self.amount * value.to_f, self.currency)
	end

	def /(value)
		Money.new(self.amount / value.to_f, self.currency)
	end
	# --------------------------------

	# overriding comparisons operators, to the nearest 2 decimal places
	def ==(other)
		temp = other.convert_to(self.currency)
		return self.amount.round(2) == temp.amount.round(2)
	end

	def >(other)
		temp = other.convert_to(self.currency)
		return self.amount.round(2) > temp.amount.round(2)
	end

	def <(other)
		temp = other.convert_to(self.currency)
		return self.amount.round(2) < temp.amount.round(2)
	end
	# --------------------------------

	def inspect
		return sprintf('%.2f %s', amount, currency)
	end

	def to_s
		return sprintf('%.2f %s', amount, currency)
	end

	# Getting the exchange rate between 2 currencies
	# == Returns:
	#  	- 1 if the 2 currencies are the same
	#  	- the required rate, even if the 2 currencies are swaped
	#  		(return inverse the value)
	# == Raises:
	# 	- RateNotFound if no rates are set for those 2 currencies
	def self.getRate(from_currency, to_currency)
		return 1 if to_currency == from_currency

		if !@@conversion_rates[to_currency].nil? && from_currency == @@base_currency
			return @@conversion_rates[to_currency]
		end

		if !@@conversion_rates[from_currency].nil? && to_currency == @@base_currency
			return 1.0 / @@conversion_rates[from_currency]
		end

		raise Exceptions::RateNotFound
	end
end