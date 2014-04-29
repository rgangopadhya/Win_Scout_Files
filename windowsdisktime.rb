require 'timeout'
class WindowsDiskTime < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(15) {
				if `typeperf \"\\LogicalDisk(*)\\% Disk Time\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
					report "% Disk Time" => $1.to_f
				else
					raise "Couldn't use `typepref` as expected."
				end
			}
		rescue Timeout::Error
			puts "windowsdisktime timed out"
		end
  end
end
