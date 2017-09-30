Gem::Specification.new do |s|
	s.name			= 'money_test'
	s.version		= '0.0.2'
	s.platform		= Gem::Platform::RUBY
	s.add_development_dependency "rspec"
	s.summary		= "Monetary"
	s.description	= "Gem for finding the exchange rate between 2 monetary values along with arithmetic manipulations"
	s.author		= "Hussein Abu Maash"
	s.email			= "hussein.abumaash@gmail.com"
	s.homepage		= "http://github.com/HusseinReda/MoneyTest"
	s.files			=  ["lib/money_test.rb", "lib/exceptions.rb"]
	s.license		= 'MIT'
end