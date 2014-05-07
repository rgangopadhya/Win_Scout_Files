require 'timeout'
require 'time'
class WindowsDiskUsage < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(5) {
				if results = `typeperf \"\\LogicalDisk(*)\\% Free Space\" -sc 1`
					labels = []
					data = []
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
					open('typeperf_error_log.txt', 'a') { |f|
						f.puts Time.now.asctime + " typeperf failed"
					}
				end
			}
		rescue Timeout::Error
			puts "windowsdiskusage timed out"
		end
  end
end
