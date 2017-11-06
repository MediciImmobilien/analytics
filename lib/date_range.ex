defmodule DateRange do
	
	def current_month do
		%{month: month, year: year} = DateTime.utc_now()
		%{"startDate": {year,month,1} |> format ,"endDate": {year, month, Timex.days_in_month(year, month)} |> format}
	end
	
	def last_month do 
		{year, month} = get_last_month()
		%{"startDate": {year, month, 1} |> format, "endDate": {year, month, Timex.days_in_month(year, month)}	 |> format}
	end
	
	def format({year, month, day}), do: "#{year}-#{do_format(month)}-#{do_format(day)}"
		
	def do_format(value) when value <= 9, do: "0#{value}"

	def do_format(value), do: "#{value}"	

	def get_last_month(), do: DateTime.utc_now()|> get_last_month()
	def get_last_month(%{month: 1, year: year}), do: {(year-1), 12} 
	def get_last_month(%{month: month, year: year}), do: {year, (month-1)} 
		
	def current_year do 
		%{year: year} = DateTime.utc_now()
		%{"startDate": "#{year}-01-01","endDate": "today"}
	end
end