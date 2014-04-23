class WindowsDiskTime < Scout::Plugin

  def build_report
    if `typeperf \"\\LogicalDisk(*)\\% Disk Time\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
      report "% Disk Time" => $1.to_f
    else
      raise "Couldn't use `typepref` as expected."
    end
  rescue Exception
    error "Error determining load", $!.message
  end

end
