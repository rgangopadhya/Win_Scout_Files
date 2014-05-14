require 'timeout'
require 'time'
class WindowsWriteRate < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(5) {
				while 1 do
					result = `typeperf \"\\LogicalDisk(*)\\Disk Write Bytes/sec\" -sc 1`
					if result =~ /,\"(\d*\.\d*)\"\n/
						report "Disk Write MB/sec" => $1.to_f/1E6
						break
					end
				end
			}
		rescue Timeout::Error
			open('timeoutlog.txt', 'a') { |f|
				f.puts Time.now.asctime + " win_write_rate timed out"
			}
		end
  end
end
