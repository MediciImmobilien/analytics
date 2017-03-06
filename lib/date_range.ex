defmodule DateRange do
	def current_month do
		%{month: month, year: year} = DateTime.utc_now()
		%{"startDate": Integer.to_string(year)<>"-0"<> Integer.to_string(month)<>"-01" ,"endDate": "today"}
	end	
end