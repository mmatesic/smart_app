require 'metric_item.rb'
require 'metrics.rb'
require 'report.rb'
require 'parser.rb'

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

describe Parser do
    let(:parser_instance) {Parser.new}

    it "should implement report_visits_count" do
        expect(parser_instance).to respond_to(:report_visits_count)
    end

    it "should implement report_unique_visits_count" do
        expect(parser_instance).to respond_to(:report_unique_visits_count)
    end

    context "When reading a file" do
        it "should return correct address visit counts" do
            parser = parser_instance
            allow(IO).to receive(:foreach).and_yield("/home 255.255.255.255\n").and_yield("/home 168.255.255.255\n").and_yield("/web_adress 168.255.255.255\n")

            parser.read_file('nofile.txt')
            expect { parser.report_visits_count }.to output("/home 2 visits\n/web_adress 1 visits\n").to_stdout
        end

        it "should return ordered results by counts descending" do
            parser = parser_instance
            allow(IO).to receive(:foreach).and_yield("/web_adress 168.255.255.255\n").and_yield("/home 255.255.255.255\n").and_yield("/web_adress 168.255.255.255\n")

            parser.read_file('nofile.txt')
            expect { parser.report_visits_count }.to output("/web_adress 2 visits\n/home 1 visits\n").to_stdout
        end

        it "should return correct address unique visit counts" do
            parser = parser_instance
            allow(IO).to receive(:foreach).and_yield("/home 255.255.255.255\n").and_yield("/home 255.255.255.255\n").and_yield("/home 168.255.255.255\n")

            parser.read_file('nofile.txt')
            expect { parser.report_unique_visits_count }.to output("/home 2 visits\n").to_stdout
        end

        it "should return ordered unique results by counts descending" do
            parser = parser_instance
            allow(IO).to receive(:foreach).and_yield("/web_adress 168.255.255.255\n").and_yield("/home 255.255.255.255\n").and_yield("/web_adress 168.255.255.255\n").and_yield("/home 168.255.255.255\n")

            parser.read_file('nofile.txt')
            expect { parser.report_unique_visits_count }.to output("/home 2 visits\n/web_adress 1 visits\n").to_stdout
        end
    end
end
