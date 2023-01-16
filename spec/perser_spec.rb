require 'metric_item.rb'
require 'metrics.rb'

describe MetricItem do
    let(:item_instance) {MetricItem.new(web_address: "/web_adress", ip_address: "255.255.255.255")}

    it "should raise error when creating without arguments" do
        expect {MetricItem.new}.to raise_error(ArgumentError)
    end

    it "should receive two arguments when initialized" do
        metric_item = item_instance
        expect(metric_item.web_address).to eql "/web_adress"
        expect(metric_item.ip_addresses).to eql Set["255.255.255.255"]
    end

    it "should count as a visit when initialized" do
        metric_item = item_instance
        expect(metric_item.visit_count).to eql 1
    end

    context "MetricItem class should add ip addresses" do

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
    it "should be initialized with empty hash" do
        metrics = Metrics.new
        expect(metrics.get_metrics).to eql Hash.new
    end

    it "should implement add_metric" do
        expect(Metrics.new).to respond_to(:add_metric)
    end

    it "should add page if not already existing" do
        metrics = Metrics.new

        metrics.add_metric("/web_adress", "255.255.255.255")
        metrics.add_metric("/home", "255.255.255.255")

        expect(metrics.get_metrics.keys).to eq ["/web_adress", "/home"]

    end

    it "should add ip address if page already exists" do
        metrics = Metrics.new

        metrics.add_metric("/web_adress", "255.255.255.255")
        metrics.add_metric("/home", "255.255.255.255")
        metrics.add_metric("/home", "255.255.255.254")

        expect(metrics.get_metrics.keys.size).to eq 2
        expect(metrics.get_metrics["/home"].ip_addresses).to eq Set["255.255.255.255", "255.255.255.254"]
    end
end
