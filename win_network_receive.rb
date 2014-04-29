require 'timeout'
class WindowsNetworkReceive < Scout::Plugin
  def build_report
		begin
			Timeout::timeout(15) {
				if results = `typeperf \"\\Network Interface(*)\\Bytes Received/sec\" -sc 1`
					labels = []
					data = []
					lines = results.split("\n")
					lines.each do |line|
						columns = line.split(",")
						columns.each do |column|
							if column.match(/Network Interface\((.+)\)/)
								labels << $1
							elsif column.match(/^\"(\d*\.\d*)\"$/)
								data << $1
							end
						end
					end
					labels.each_with_index do |label, index|
						report "#{label} MB Received/sec" => data[index].to_f/1E6
					end
				else
					raise "Couldn't use `typepref` as expected."
				end
			}
		rescue Timeout::Error
			puts "win_network_receive timed out"
		end
  end
end

