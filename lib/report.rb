require './lib/metrics.rb'

class Report<Metrics
    def get_visits
        sort_metrics(super())
    end

    def get_unique_visits
        sort_metrics(super())
    end

    private

    def sort_metrics(metrics)
        metrics.sort_by{|k, v| [-v, k]}.to_h
    end
end
