class Parser
    def initialize
        @report = Report.new
    end

    def read_file(file_name)
    end

    def report_visits_count
        @report.get_metrics
    end

    def report_unique_visits_count
        @report.get_unique_visits
    end
end
