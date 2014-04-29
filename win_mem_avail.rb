require 'timeout'
class TestWindowsAvailableMemory < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(15) {
				if `typeperf \"\\Memory\\Available bytes\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
					report "GB Free" => $1.to_f/1E9
				else
					raise "Couldn't use `typepref` as expected."
				end
			}
		rescue Timeout::Error
			puts "win_mem_avail timed out"
		end
  end
end
