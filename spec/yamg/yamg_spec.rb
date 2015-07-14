require 'spec_helper'

describe YAMG do
  it 'should instantiate' do
    stub_const('YAML', y = class_double('YAML'))
    expect(y).to receive(:load_file).and_return({})

    expect { YAMG::CLI.new([]) }.to_not raise_error
  end

  describe 'stubbed' do
    let :conf do
      stub_const('YAML', class_double('YAML'))
    end
  end
end
