require 'timeout'
require 'time'
class TestWindowsAvailableMemory < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(5) {
				while 1 do
					result = `typeperf \"\\Memory\\Available bytes\" -sc 1`
					if result =~ /,\"(\d*\.\d*)\"\n/
						report "GB Free" => $1.to_f/1E9
						break
					end
				end
			}
		rescue Timeout::Error
			puts "win_mem_avail timed out"
		end
  end
end
