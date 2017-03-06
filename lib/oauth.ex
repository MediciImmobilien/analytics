defmodule Oauth do
	@url "https://accounts.google.com/o/oauth2/token"

	def body(config) do
		%{
			client_id: config[:client_id],
			client_secret: config[:client_secret],
			refresh_token: config[:refresh_token],
			grant_type: "refresh_token"
		}
		|> URI.encode_query
	end

	def get_access_token() do
		config = Application.get_env(:analytics, :analytics)
		{:ok, %{body: body}} = HTTPoison.post(@url, body(config), %{"Content-Type" => "application/x-www-form-urlencoded"})
		body 
		|> Poison.decode! 
		|> Map.get("access_token")
	end
end