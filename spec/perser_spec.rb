require 'metric_item.rb'

describe MetricItem do
    let(:item_instance) {MetricItem.new(web_address: "/web_adress", ip_address: "255.255.255.255")}

    it "should receive two arguments when initialized" do
        metric_item = item_instance
        expect(metric_item.web_address).to eql "/web_adress"
        expect(metric_item.ip_addresses).to eql Set["255.255.255.255"]
    end
end
