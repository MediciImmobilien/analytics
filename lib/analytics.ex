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
		{:ok, %{values: values}} =  request_data([current_month()], ["ga:adCost"],["ga:day"]) 
		
		{:ok, money} = values
	 	|> Enum.map(fn(%{amount: amount}) -> amount/100 end)
		|> Enum.sum
		|> Money.parse(:USD)
		
		money
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
		{:ok, data} =  request_data([last_month()], ["ga:adCost"],["ga:day"]) 
		data
	 	|> Enum.map(fn(%{value: value}) -> value end)
		|> Enum.sum
	end	
end