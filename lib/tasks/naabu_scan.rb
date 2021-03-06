module Intrigue
  module Task
  class NaabuScan < BaseTask
  
    def self.metadata
      {
        :name => "naabu_scan",
        :pretty_name => "Naabu Scan",
        :authors => ["jcran"],
        :description => "This task runs an naabu scan on the target host or domain.",
        :references => [],
        :type => "discovery",
        :passive => false,
        :allowed_types => ["IpAddress", "Domain", "DnsRecord"],
        :example_entities => [{"type" => "DnsRecord", "details" => {"name" => "intrigue.io"}}],
        :allowed_options => [],
        :created_types => [ "DnsRecord", "IpAddress", "NetworkService", "Uri" ],
        :queue => "task_scan"
      }
    end
  
    ## Default method, subclasses must override this
    def run
      super

      ip_address = _get_entity_name

      unless ip_address =~ ipv4_regex
        _log_error "Unable to support non-ipv4 addresses!"
        return
      end

      command = "naabu -host #{ip_address} -p #{scannable_tcp_ports.join(",")} -silent -json"
      _log "Running: #{command}"
      out = _unsafe_system(command, 120)
      
      # handle the no-result case
      unless out 
        _log "No output! returning!"
        return
      end

      # otherwise, create network services 
      lines = out.split("\n")
      lines.each do |l|
        j = JSON.parse(l)
        port = "#{j["port"]}".to_i
        return unless scannable_tcp_ports.map{|x| x.to_i }.include? port
        _create_network_service_entity(@entity, port, "tcp")
      end

    end
  
  end
  end
  end
  