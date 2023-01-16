require 'set'

class MetricItem
    attr_reader :web_address, :ip_addresses, :visit_count
    def initialize(web_address:, ip_address:)
        @web_address = web_address
        @visit_count = 1
        @ip_addresses = Set.new([ip_address])
    end

    def add_ip(ip)
        @visit_count += 1
        @ip_addresses << ip
    end
end
