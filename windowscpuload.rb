require 'timeout'
require 'time'
class WindowsCPULoad < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(5) {
				while 1 do
					result = `typeperf \"\\Processor(_Total)\\% Processor Time\" -sc 1`
					if result =~ /,\"(\d*\.\d*)\"\n/
						report '% used' => $1.to_f
						break
					end
				end
			}
		rescue Timeout::Error 
			open('timeoutlog.txt', 'a') { |f|
				f.puts Time.now.asctime + " windowscpuload timed out"
			}
		end
  end
end
