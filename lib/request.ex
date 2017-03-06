defmodule Request do
	@url "https://analyticsreporting.googleapis.com/v4/reports:batchGet" 
		
	def body(dateRanges, metrics,dimensions) do 
		%{"reportRequests": [%{"viewId": "121729881","dateRanges": dateRanges,"metrics": metrics|> Enum.map(fn(metric) -> %{"expression": metric} end),"dimensions": dimensions|> Enum.map(fn(dimension) -> %{"name": dimension} end)}]}	
		|> Poison.encode!
	end

	def headers do 
		[{"Content-Type", "application/json"}, {"Authorization", "Bearer " <> Oauth.get_access_token()}]
	end
		
	def request_data(dateRanges, metrics,dimensions) do
		{:ok, %{body: body}} = HTTPoison.post(@url,body(dateRanges, metrics,dimensions),headers)
		body 
		|> Poison.decode!
		|> prepare_result	
	end
		
	def prepare_result(%{"reports" => [%{"data" => %{"rows" => rows}}]}) do 
		{:ok, rows}  
	end

	def prepare_result(%{"reports" => [%{"data" => %{"totals" => [%{"values" => ["0.0"]}]}}]}) do
		{:ok,[]}
	end
		
	def prepare_result(%{"error" => %{"code" => code, "message" => message,"status" => status}}) do
		{:error,  message}
	end		
end