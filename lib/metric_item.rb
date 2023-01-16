require 'set'

class MetricItem
    attr_reader :web_address, :ip_addresses
    def initialize(web_address:, ip_address:)
        @web_address = web_address
        @ip_addresses = Set.new([ip_address])
    end
end
