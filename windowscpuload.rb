require 'timeout'
require 'time'
class WindowsCPULoad < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(15) {
				while 1 do
					result = `typeperf \"\\Processor(_Total)\\% Processor Time\" -sc 1`
					if result =~ /,\"(\d*\.\d*)\"\n/
						report '% used' => $1.to_f
						break
					end
				end
			}
		rescue Timeout::Error 
			#puts "windowscpuload timed out"
			error "Error", $!.message
		end
  end
end
