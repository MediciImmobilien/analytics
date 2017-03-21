defmodule Analytics do
	import DateRange
	import Analytics.Request
	
	def get_data(:impression, :current_month, :list) do
		{:ok, data} = request_data([current_month()], ["ga:impressions"],["ga:day"])
		data
	end
	
	def get_data(:ad_cost, :current_month, :list) do
		{:ok, data} = request_data([current_month()], ["ga:adCost"],["ga:day"])
		data
	end
	
	def get_data(:ad_cost, :current_month, :sum) do
		{:ok,  values} =  request_data([current_month()], ["ga:adCost"],["ga:day"]) 
		  values
	 	|> Enum.map(fn(%{"ga:adCost" => %{amount: amount}}) -> amount end)
		|> Enum.sum
		
		|> Money.new(:USD)
	end	
	
	def get_data(:impression, :last_month, :list) do
		{:ok, data} = request_data([last_month()], ["ga:impressions"],["ga:day"])
		data
	end
	
	def get_data(:adcost, :last_month, :list) do
		{:ok, data} = request_data([last_month()], ["ga:adCost"],["ga:day"])
		data
	end
	
	def get_data(:ad_cost, :last_month, :sum) do
		{:ok, values} =  request_data([last_month()], ["ga:adCost"],["ga:day"]) 
		values
	 	|> Enum.map(fn(%{"ga:adCost" => %{amount: amount}}) -> amount end)
		|> Enum.sum
		|> div(100)
		|> Money.new(:USD)
	end	
end