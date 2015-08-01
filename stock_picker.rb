def pick(prices)
	highest_profit = 0
	buy = 0
	sell = 0
	prices.each do |price|
		later_prices = prices[prices.index(price)..-1]
		later_prices.each do |later_price|
			profit = later_price - price
			if profit > highest_profit
				highest_profit = profit
				buy = prices.index(price)
				sell = later_prices.index(later_price) + buy
			end
		end
	end
	puts "Buy on day #{buy} and sell on day #{sell} for a profit of #{highest_profit}."
	[buy, sell]
end
