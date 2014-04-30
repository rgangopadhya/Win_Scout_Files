require 'timeout'
require 'time'
class WindowsDiskTime < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(15) {
				if `typeperf \"\\LogicalDisk(*)\\% Disk Time\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
					report "% Disk Time" => $1.to_f
				else
					open('typeperf_error_log.txt', 'a') { |f|
						f.puts Time.now.asctime + " typeperf failed"
					}
				end
			}
		rescue Timeout::Error
			puts "windowsdisktime timed out"
		end
  end
end
