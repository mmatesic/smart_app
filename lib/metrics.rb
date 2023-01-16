class Metrics
    def initialize()
        @log_metrics = Hash.new
    end

    def add_metric(address, ip)
        if @log_metrics[address].nil?
            metric_item = MetricItem.new(web_address: address, ip_address: ip)
            @log_metrics[address] = metric_item
        else
            metric_item = @log_metrics[address]
            metric_item.add_ip(ip)
            @log_metrics[address] = metric_item
        end
    end

    def get_metrics
        @log_metrics
    end
end
