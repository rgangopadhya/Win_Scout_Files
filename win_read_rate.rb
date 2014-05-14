require 'timeout'
require 'time'
class WindowsReadRate < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(5) {
				while 1 do
					result =`typeperf \"\\LogicalDisk(*)\\Disk Read Bytes/sec\" -sc 1`
					if result =~ /,\"(\d*\.\d*)\"\n/
						report "Disk Read MB/sec" => $1.to_f/1E6
						break
					end
				end
			}
		rescue Timeout::Error
			open('timeoutlog.txt', 'a') { |f|
				f.puts Time.now.asctime + " win_read_rate timed out"
			}
		end
  end
end
