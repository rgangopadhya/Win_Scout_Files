require 'timeout'
require 'time'
class WindowsDiskTime < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(5) {
				while 1 do
					result = `typeperf \"\\LogicalDisk(*)\\% Disk Time\" -sc 1` 
					if result =~ /,\"(\d*\.\d*)\"\n/
						report "% Disk Time" => $1.to_f
						break
					end
				end
			}
		rescue Timeout::Error
			open('timeoutlog.txt', 'a') { |f|
				f.puts Time.now.asctime + " windowsdisktime timed out"
			}
		end
  end
end
