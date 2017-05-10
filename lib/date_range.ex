defmodule DateRange do
	def current_month do
		%{month: month, year: year} = DateTime.utc_now()
		%{"startDate": Integer.to_string(year)<>"-0"<> Integer.to_string(month)<>"-01" ,"endDate": "today"}
	end
	
	def last_month do 
		%{month: current_month, year: current_year} = DateTime.utc_now()
		{year, month} = case current_month do 
						1 -> {current_year-1, 12}
						_ -> {current_year, current_month-1}
					end			
		%{"startDate": Integer.to_string(year)<>"-0"<> Integer.to_string(month)<>"-01" ,"endDate": "today"}
	end
	
	def current_year do 
		%{year: current_year} = DateTime.utc_now()
		%{"startDate": Integer.to_string(current_year) <> "-01" <>"-01" ,"endDate": "today"}
	end
end