require 'spec_helper'
require 'helpers/money_helpers'

RSpec.configure do |c|
	c.include MoneyHelpers
end

describe Money do
	it 'should create a money object with amount and currency' do
		sample = Money.new(50, 'EUR')

		expect(sample.amount).to eq 50
		expect(sample.currency).to eq 'EUR'
	end

	it 'should convert money (in EUR) to USD' do
		initialize_with_conversion_rates

		sample = Money.new(50, 'EUR')
		converted_value = sample.amount * Money.getRate('EUR','USD')

		sample = sample.convert_to('USD')

		expect(sample.amount.round(2)).to eq converted_value.round(2)
		expect(sample.currency).to eq "USD"
	end

	it 'should add 2 different money values with respect to the first one' do
		sample_eur = Money.new(50, 'EUR')
		sample_usd = Money.new(50, 'USD')

		total = sample_eur + sample_usd

		converted_value = sample_usd.amount * Money.getRate('USD','EUR')

		expect(total.amount).to eq(sample_eur.amount + converted_value)
		expect(total.currency).to eq('EUR')
	end

	it 'should subtract 2 different money values with respect to the first one' do
		sample_eur = Money.new(50, 'EUR')
		sample_usd = Money.new(50, 'USD')

		total = sample_eur - sample_usd

		converted_value = sample_usd.amount * Money.getRate('USD','EUR')

		expect(total.amount).to eq(sample_eur.amount - converted_value)
		expect(total.currency).to eq('EUR')
	end

	it 'should multiply a money amount by 5' do
		sample_eur = Money.new(50, 'EUR')

		total = sample_eur * 5

		amount = sample_eur.amount
		amount *= 5

		expect(total.amount).to eq(amount)
	end

	it 'should divide a money amount by 5' do
		sample_eur = Money.new(50, 'EUR')

		total = sample_eur / 5

		amount = sample_eur.amount
		amount /= 5

		expect(total.amount).to eq(amount)
	end

	it 'should return true for the equal comparison' do
		sample_eur = Money.new(50, 'EUR')
		converted_value = 50 * Money.getRate('EUR','USD')
		sample_usd = Money.new(converted_value, 'USD')

		expect(sample_eur == sample_usd).to be(true)
	end

	it 'should return true for the bigger than comparison' do
		sample_eur = Money.new(50, 'EUR')
		converted_value = ( 50 * Money.getRate('EUR','USD') ) - 1
		sample_usd = Money.new(converted_value, 'USD')

		expect(sample_eur > sample_usd).to be(true)
	end

	it 'should return true for the smaller than comparison' do
		sample_eur = Money.new(50, 'EUR')
		converted_value = ( 50 * Money.getRate('EUR','USD') ) + 1
		sample_usd = Money.new(converted_value, 'USD')

		expect(sample_eur < sample_usd).to be(true)
	end
end