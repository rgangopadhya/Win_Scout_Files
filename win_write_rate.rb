require 'timeout'
require 'time'
class WindowsWriteRate < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(15) {
				if `typeperf \"\\LogicalDisk(*)\\Disk Write Bytes/sec\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
					report "Disk Write MB/sec" => $1.to_f/1E6
				else
					open('typeperf_error_log.txt', 'a') { |f|
						f.puts Time.now.asctime + " typeperf failed"
					}
				end
			}
		rescue Timeout::Error
			puts "win_write_rate timed out"
		end
  end
end
