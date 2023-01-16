require './lib/report.rb'

class Parser
    def initialize
        @report = Report.new
    end

    def read_file(file_path)
        IO.foreach(file_path) do |line|
            web, ip = line.split(' ', 2)
            if valid_metrics?(web, ip)
                @report.add_metric(web, ip)
            end
        end
    end

    def report_visits_count
        format_output(@report.get_visits, "visit")
    end

    def report_unique_visits_count
        format_output(@report.get_unique_visits, "unique visit")
    end

    def valid_metrics?(web_address, ip_address)
        if web_address?(web_address) && ip_address?(ip_address)
            true
        else
            false
        end
    end

    private

    def format_output(metrics, description)
        metrics.each{|k, v| v > 1 ? puts("#{k} #{v} #{description}s") : puts("#{k} #{v} #{description}") }
    end

    def ip_address?(str)
        !!(str =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/)
    end

    def web_address?(str)
        !!(str =~ /^(\/\w+)+\/?\d*$/)
    end

end
