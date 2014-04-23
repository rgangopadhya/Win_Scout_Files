class WindowsTableauStatus < Scout::Plugin

  def build_report
    if results = `\"C:\\Program Files\\Tableau\\Tableau Server\\8.1\\bin\\tabadmin.exe\" status -v`
    			labels = []
			data = []

			lines = results.split("\n")
			lines.each do |line|
				puts line
				if line.match(/'Tableau Server (.+)' \(\d+\) is (\w+)/)
					labels << $1
					status = ($2=="running" ? 1 : 0)
					data << status
				end
			end
			labels.each_with_index do |label, index|
				report "#{label}" => data[index]
			end
    else
       raise "Couldn't use tabadmin"
    end
  rescue Exception
     error "Error getting tableau status", $!.message
  end

end
