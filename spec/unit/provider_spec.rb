require 'spec_helper'
require 'vagrant-haipa/provider'

RSpec.describe VagrantPlugins::Haipa::Provider do
  include_context 'vagrant-unit'
  
  let(:machine){ double("machine") }
  let(:platform){ double("platform") }
  subject { described_class.new(machine) }

  before do
    stub_const("Vagrant::Util::Platform", platform)
    allow(machine).to receive(:id).and_return("foo")
  end
  
  describe "#driver" do
    it "is initialized" do
      expect(subject.driver).to be_kind_of(VagrantPlugins::Haipa::Driver)
    end
  end

  describe "#state" do
    it "returns not_created if no ID" do
      allow(machine).to receive(:id).and_return(nil)

      expect(subject.state.id).to eq(:not_created)
    end

    it "calls an action to determine the ID" do
      allow(machine).to receive(:id).and_return("foo")
      expect(machine).to receive(:action).with(:read_state).
        and_return({ machine_state_id: :bar })

      expect(subject.state.id).to eq(:bar)
    end
  end  
end