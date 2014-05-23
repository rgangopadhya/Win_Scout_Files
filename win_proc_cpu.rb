require 'timeout'
require 'time'

class Win_Proc_CPU < Scout::Plugin
	def build_report
		begin
			Timeout::timeout(10) {
				proc_list = ['vizqlserver', 'tdeserver64', 'backgrounder', 'tabprotosrv', 'postgres', 'tabadmin', 'tabrepo', 'dataserver', 
							'tabspawn', 'tabsvc', 'tabsvcmonitor', 'wgserver']
				results = `typeperf \"\\Process(*)\\% Processor Time\" -sc 1`
				lines = results.split("\n")
				column_names = lines[1].split(",")
				values = lines[2].split(",")
				comb = column_names.zip(values)
				out_data = Hash.new 0
				tot_proc = 800.0
				check_tot = 0
				comb.each do |col, val|
					if col.match(/Process\((\w+)(#\d+)?\)/)
						name = $1
						if val.match(/^\"(\d+\.\d+)\"$/)
							val = $1.to_f
							if name == "_Total"
								tot_proc = val
							else 
								out_data[name] += val
								check_tot += val
							end
						end
					end
				end
				out_data.each do |key, val|
					if proc_list.include? key
						report "#{key} % CPU Used" => val/tot_proc
					end
				end
			}
		rescue Timeout::Error
			open('timeoutlog.txt', 'a') { |f|
				f.puts Time.now.asctime + " win_proc_cpu timed out"
			}
		end
	end
end
