# This is the main class for saving the monetary value and handling
# different operations

class MoneyTest
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
		rate = getRate(from_currency, to_currency)

		# raise Exceptions::RateNotFound if rate.nil?

		converted_amount = self.amount * rate

		MoneyTest.new(converted_amount, to_currency)
	end

	# overriding arithmetic operators
	def +(other)
		rate = getRate(other.currency, self.currency)
		new_other_amount = other.amount * rate
		MoneyTest.new(self.amount + new_other_amount, self.currency)
	end

	def -(other)
		rate = getRate(other.currency, self.currency)
		new_other_amount = other.amount * rate
		MoneyTest.new(self.amount - new_other_amount, self.currency)
	end

	def *(value)
		MoneyTest.new(self.amount * value.to_f, self.currency)
	end

	def /(value)
		MoneyTest.new(self.amount / value.to_f, self.currency)
	end

	def inspect
		return "#{@amount.round(2)} #{@currency}"
	end

	def to_s
		return "#{@amount.round(2)} #{@currency}"
	end

	private
		def getRate(from_currency, to_currency)
			return 1 if to_currency == from_currency

			return @@conversion_rates[to_currency] if !@@conversion_rates[to_currency].nil?

			if !@@conversion_rates[from_currency].nil? && to_currency == @@base_currency
				return 1.0 / @@conversion_rates[from_currency]
			end

			return 1000000
			# raise NoRateFound
		end

end