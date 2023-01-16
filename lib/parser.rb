class Parser
    def initialize
        @report = Report.new
    end

    def read_file(file_path)
        IO.foreach(file_path) do |line|
            web, ip = line.split(' ', 2)
            @report.add_metric(web, ip)
        end
    end

    def report_visits_count
        format_output(@report.get_visits, "visits")
    end

    def report_unique_visits_count
        format_output(@report.get_unique_visits, "unique visits")
    end

    private

    def format_output(metrics, description)
        metrics.each{|k, v| puts "#{k} #{v} #{description}"}
    end
end
