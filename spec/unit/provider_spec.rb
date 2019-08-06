require 'spec_helper'

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
end