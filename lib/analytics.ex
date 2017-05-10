defmodule Analytics do
	import DateRange
	import Analytics.Request

	def get_data(:impressions) do 
		{:ok, data} = request_data([current_month()], ["ga:impressions", "ga:adCost", "ga:adClicks"],["ga:day","ga:month","ga:year", "ga:adwordsCampaignID"])
		data
		|> Enum.map(fn(%{"ga:year" => year, "ga:month" => month, "ga:day" => day} = item) -> Map.put_new(item, "date", year <> "-" <> month <> "-" <> day |> Date.from_iso8601!)   end)
		|> Enum.map(fn(map)-> Map.drop(map,["ga:year", "ga:month", "ga:day"]) end)  
		|> Enum.group_by(fn(%{"ga:adwordsCampaignID" => campaign_id}) -> campaign_id end, fn(map) -> Map.drop(map,["ga:adwordsCampaignID"])end)
	end
	
	def get_data(:impression, :current_month, :list) do
		{:ok, data} = request_data([current_month()], ["ga:impressions"],["ga:day"])
		data
	end
	
	def get_data(:ad_cost, :current_month, :list) do
		{:ok, data} = request_data([current_month()], ["ga:adCost"],["ga:day"])
		data
	end
	
	def get_data(:ad_cost, :current_year, :list) do
		{:ok, data} = request_data([current_year()], ["ga:adCost"],["ga:month"])
		data		
	end
	
	def get_data(:ad_cost, :current_month, :sum) do
		{:ok,  values} =  request_data([current_month()], ["ga:adCost"],["ga:day"]) 
		  values
	 	|> Enum.map(fn(%{"ga:adCost" => %{amount: amount}}) -> amount end)
		|> Enum.sum
		|> div(100)
		|> Money.new(:USD)
		|> Currency.from_usd_to_eur
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
		|> Currency.from_usd_to_eur
	end	
end