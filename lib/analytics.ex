defmodule Analytics do
	def get_data(:impression, :current_month, :list) do
		Request.request_data([DateRange.current_month()], ["ga:impressions"],["ga:day"])
	end
	
	def get_data(:adcost, :current_month, :list) do
		Request.request_data([DateRange.current_month], ["ga:adCost"],["ga:day"])
	end
	
	def get_data(:ad_cost, :current_month, :sum) do
		Request.request_data([DateRange.current_month], ["ga:adCost"],["ga:adwordsCampaignID"]) 		
	end
end