defmodule Analytics.Request do
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
		|> handle_result	
	end
	
	def handle_result(%{"reports" => [%{"columnHeader" => %{"dimensions" => [dimensionsheader], "metricHeader" => %{"metricHeaderEntries" => metricHeaderEntries}}, "data" => %{"rows" => rows}}]}) do
		{:ok, rows |> Enum.map(fn(%{"dimensions" => [dimension],"metrics" => [%{"values" => values}]})-> Map.merge(%{dimensionsheader => dimension}, handle_metrics(metricHeaderEntries,values)) end)}
	end
	
	def handle_result(%{"error" => %{"message" => message}}) do
		{:error,  message}
	end		
	
	def handle_metrics(metricHeaderEntries,values) do 
		for {{name, type}, value} <- Enum.zip(metricHeaderEntries |> Enum.map(fn(%{"name" => name, "type" => type}) -> {name,type} end), values) do 
			case {{name, type}, value} do
				{{name, "INTEGER"}, value} -> {name, value |> String.to_integer}
				{{name, "CURRENCY"}, value} -> {name, value |> String.to_float |> parse_money }
				{{name, "FLOAT"}, value} -> {name, value |> String.to_float}
			end
		end
		|> Map.new
	end
	
	def parse_money(float) do 
		{:ok, money} = float
		|> Float.round(2)
		|> Money.parse(:USD)
		money
	end
end