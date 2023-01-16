require 'metric_item.rb'
require 'metrics.rb'
require 'report.rb'

describe MetricItem do
    let(:item_instance) {MetricItem.new(web_address: "/web_address", ip_address: "255.255.255.255")}

    it "should raise error when creating without arguments" do
        expect {MetricItem.new}.to raise_error(ArgumentError)
    end

    it "should receive two arguments when initialized" do
        metric_item = item_instance
        expect(metric_item.web_address).to eql "/web_address"
        expect(metric_item.ip_addresses).to eql Set["255.255.255.255"]
    end

    it "should count as a visit when initialized" do
        metric_item = item_instance
        expect(metric_item.visit_count).to eql 1
    end

    context "When testing add_ip method" do

        it "should implement add_ip" do
            expect(item_instance).to respond_to(:add_ip)
        end

        it "should add ip address" do
            metric_item = item_instance
            metric_item.add_ip("255.255.255.254")
            expect(metric_item.ip_addresses.size).to eq 2
            expect(metric_item.ip_addresses).to eq Set["255.255.255.255", "255.255.255.254"]
        end

        it "should not add ip address if already exists" do
            metric_item = item_instance
            metric_item.add_ip("255.255.255.255")
            expect(metric_item.ip_addresses.size).to eq 1
            expect(metric_item.ip_addresses).to eq Set["255.255.255.255"]
        end

        it "should count add_ip calls" do
            metric_item = item_instance
            metric_item.add_ip("186.111.000.255")
            expect(metric_item.visit_count).to eq 2
        end

        it "should count add_ip calls if value already exists" do
            metric_item = item_instance
            metric_item.add_ip("255.255.255.255")
            expect(metric_item.visit_count).to eq 2
        end
    end
end

describe Metrics do
    let(:metrics_instance) {Metrics.new}

    it "should be initialized with empty hash" do
        expect(metrics_instance.get_metrics).to eql Hash.new
    end

    context "When testing add_metric method" do

        it "should implement add_metric" do
            expect(metrics_instance).to respond_to(:add_metric)
        end

        it "should add page if not already existing" do
            metrics = metrics_instance
            metrics.add_metric("/web_address", "255.255.255.255")
            metrics.add_metric("/home", "255.255.255.255")

            expect(metrics.get_metrics.keys).to eq ["/web_address", "/home"]

        end

        it "should add ip address if page already exists" do
            metrics = metrics_instance
            metrics.add_metric("/web_address", "255.255.255.255")
            metrics.add_metric("/home", "255.255.255.255")
            metrics.add_metric("/home", "255.255.255.254")

            expect(metrics.get_metrics.keys.size).to eq 2
            expect(metrics.get_metrics["/home"].ip_addresses).to eq Set["255.255.255.255", "255.255.255.254"]
        end
    end
end

describe Report do
    let(:report_instance) {Report.new}

    it "should be kind of stats" do
        expect(report_instance).to be_kind_of Metrics
    end

    it "should implement get_visits" do
        expect(report_instance).to respond_to(:get_visits)
    end

    it "should implement get_unique_visits" do
        expect(report_instance).to respond_to(:get_unique_visits)
    end

    context "When testing correct values" do

        it "should return home address with 3 visits" do
            report = report_instance
            report.add_metric("/home", "255.255.255.255")
            report.add_metric("/home", "255.255.255.255")
            report.add_metric("/home", "168.200.255.254")

            expect(report.get_visits).to include("/home"=>3)
        end

        it "should return different addresses with correct visits count" do
            report = report_instance
            report.add_metric("/web_address", "255.255.255.255")
            report.add_metric("/home", "255.255.255.255")
            report.add_metric("/home", "168.200.255.254")

            expect(report.get_visits).to include("/web_address"=>1, "/home"=>2)
        end

        it "should return home address with 2 unique visits" do
            report = report_instance
            report.add_metric("/home", "255.255.255.255")
            report.add_metric("/home", "255.255.255.255")
            report.add_metric("/home", "168.200.255.254")

            expect(report.get_unique_visits).to include("/home"=>2)
        end

        it "should return different addresses with correct unique visits count" do
            report = report_instance
            report.add_metric("/web_address", "255.255.255.255")
            report.add_metric("/web_address", "255.255.255.255")
            report.add_metric("/home", "255.255.255.255")
            report.add_metric("/home", "255.255.255.255")

            expect(report.get_unique_visits).to include("/web_address"=>1, "/home"=>1)
        end
    end
end
