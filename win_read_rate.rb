require 'timeout'
class WindowsReadRate < Scout::Plugin

  def build_report
		begin
			Timeout::timeout(15) {
				if `typeperf \"\\LogicalDisk(*)\\Disk Read Bytes/sec\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
					report "Disk Read MB/sec" => $1.to_f/1E6
				else
					raise "Couldn't use `typepref` as expected."
				end
			}
		rescue Timeout::Error
			puts "win_read_rate timed out"
		end
  end
end
