require 'timeout'
require 'time'
class WindowsCPULoad < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(15) {
				if `typeperf \"\\Processor(_Total)\\% Processor Time\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
					report '% used' => $1.to_f
				else
					open('typeperf_error_log.txt', 'a') { |f|
						f.puts Time.now.asctime + " typeperf failed"
					}
				end
			}
		rescue Timeout::Error 
			puts "windowscpuload timed out"
		end
  end
end
