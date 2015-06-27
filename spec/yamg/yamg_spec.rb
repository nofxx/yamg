require 'spec_helper'

describe YAMG do
  it 'should instantiate' do
    stub_const('YAML', y = class_double('YAML'))
    expect(y).to receive(:load_file).and_return({})

    expect { YAMG.new }.to_not raise_error
  end

  describe 'stubbed' do
    let :conf do
      stub_const('YAML', class_double('YAML'))
    end

    it 'should read conf icon' do
      expect(conf).to receive(:load_file).and_return(icon: {})
      expect(YAMG.new.config).to eq(icon: {})
    end

    describe 'simple setup' do
      it 'should map true to media' do
        expect(conf).to receive(:load_file).and_return({})
        expect(YAMG.new.setup_for(true)).to eq('path' => './media')
      end
    end
  end
end
