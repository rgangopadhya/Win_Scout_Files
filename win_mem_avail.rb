class TestWindowsAvailableMemory < Scout::Plugin

  def build_report
    if `typeperf \"\\Memory\\Available bytes\" -sc 1` =~ /,\"(\d*\.\d*)\"\n/
      report "GB Free" => $1.to_f/1E9
    else
      raise "Couldn't use `typepref` as expected."
    end
  rescue Exception
    error "Error determining load", $!.message
  end

end
