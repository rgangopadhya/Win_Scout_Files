require 'timeout'
class WindowsDiskUsage < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(15) {
				if results = `typeperf \"\\LogicalDisk(*)\\% Free Space\" -sc 1`
					labels = []
					data = []
					puts results
					lines = results.split("\n")
					lines.each do |line|
						columns = line.split(",")
						columns.each do |column|
							if column.match(/LogicalDisk\((\w:|_Total)\)/)
								labels << $1
							elsif column.match(/^\"(\d*\.\d*)\"$/)
								data << $1
							end
						end
					end
					labels.each_with_index do |label, index|
						report "#{label}% available" => data[index].to_f
					end
				else
					raise "Couldn't use `typepref` as expected."
				end
			}
		rescue Timeout::Error
			puts "windowsdiskusage timed out"
		end
  end
end
