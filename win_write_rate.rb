class WindowsWriteRate < Scout::Plugin

  def build_report
    if `typeperf \"\\LogicalDisk(*)\\Disk Write Bytes/sec\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
      report "Disk Write MB/sec" => $1.to_f/1E6
    else
      raise "Couldn't use `typepref` as expected."
    end
  rescue Exception
    error "Error determining load", $!.message
  end

end
