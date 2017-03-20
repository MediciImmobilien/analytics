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
	
	def prepare_result(%{"reports" => [%{"columnHeader" => %{"metricHeader" => %{"metricHeaderEntries" => [%{"name" => _name,"type" => "INTEGER"}]}}, "data" => %{"rows" => rows}}]}) do 
		{:ok,%{dimensions: rows |> Enum.map(fn(%{"dimensions" => [dimensions]}) -> dimensions end), values: rows|> Enum.map(fn(%{"metrics" => [%{"values" => [values]}]}) ->  values |> String.to_integer end)}}
	end
	
	def prepare_result(%{"reports" => [%{"columnHeader" => %{"metricHeader" => %{"metricHeaderEntries" => [%{"name" => _name,"type" => "CURRENCY"}]}}, "data" => %{"rows" => rows}}]}) do 
		{:ok,%{dimensions: rows |> Enum.map(fn(%{"dimensions" => [dimensions]}) -> dimensions end), values: rows|> Enum.map(fn(%{"metrics" => [%{"values" => [values]}]}) ->   values |> String.to_float |> parse_money end)}}
	
	
	
	
	
	
	
	end

	def parse_money(float) do 
		
		{:ok, money} = float
		|> Float.round(2)
		|> Money.parse(:USD)
		money
	end





	def prepare_result(%{"reports" => [%{"columnHeader" => %{"metricHeader" => %{"metricHeaderEntries" => [%{"name" => _name,"type" => "FLOAT"}]}}, "data" => %{"rows" => rows}}]}) do 
		{:ok,%{dimensions: rows |> Enum.map(fn(%{"dimensions" => [dimensions]}) -> dimensions end), values: rows|> Enum.map(fn(%{"metrics" => [%{"values" => [values]}]}) ->  values |> String.to_float end)}}
	end

	def prepare_result(%{"reports" => [%{"data" => %{"totals" => [%{"values" => ["0.0"]}]}}]}) do
		{:ok,%{dimensions: [], values: []}}
	end
	
	def prepare_result(%{"reports" => [%{"data" => %{"totals" => [%{"values" => ["0"]}]}}]}) do
		{:ok,%{dimensions: [], values: []}}
	end
	
	def prepare_result(%{"error" => %{"message" => message}}) do
		{:error,  message}
	end		
end