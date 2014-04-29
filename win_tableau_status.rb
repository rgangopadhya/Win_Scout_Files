require 'timeout'
class WindowsTableauStatus < Scout::Plugin

	def build_report
		results = nil
		begin
			Timeout::timeout(15) { results = `\"C:\\Program Files\\Tableau\\Tableau Server\\8.1\\bin\\tabadmin.exe\" status -v` }
		rescue Timeout::Error
			puts "tabladmin status timed out"
		end

		if results
    			labels = []
			data = []

			lines = results.split("\n")
			lines.each do |line|
				if line.match(/'Tableau Server (.+)' \(\d+\) is (\w+)/)
					labels << $1
					status = ($2=="running" ? 1 : 0)
					data << status
				end
			end
			labels.each_with_index do |label, index|
				report "#{label}" => data[index]
			end
		end
	end
end
