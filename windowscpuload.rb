require 'timeout'
class WindowsCPULoad < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(15) {
				if `typeperf \"\\Processor(_Total)\\% Processor Time\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
					report '% used' => $1.to_f
				else
					raise "Couldn't use `typepref` as expected."
				end
			}
		rescue Timeout::Error 
			puts "windowscpuload timed out"
		end
  end
end
