require 'spec_helper'

describe YAMG::Icon do
  it 'should have a nice find icon 16' do
    expect(YAMG).to receive(:load_images).with('foo')
                     .and_return(['16.png', '32.png', '64.png'])
    icon = YAMG::Icon.new('foo', 16)
    expect(icon.find_closest_gte_icon).to eq('16.png')
  end

  it 'should have a nice find icon 48' do
    expect(YAMG).to receive(:load_images).with('foo')
                     .and_return(['16.png', '32.png', '64.png'])
    icon = YAMG::Icon.new('foo', 48)
    expect(icon.find_closest_gte_icon).to eq('64.png')
  end

  it 'should have a nice find icon 256' do
    expect(YAMG).to receive(:load_images).with('foo')
                     .and_return(['16.png', '32.png', '64.png'])
    icon = YAMG::Icon.new('foo', 256)
    expect(icon.find_closest_gte_icon).to eq('64.png')
  end

  it 'should have a nice find icon mixed names' do
    expect(YAMG).to receive(:load_images).with('foo')
                     .and_return(['xx16.png', '32oo.png', 'x64o.png'])
    icon = YAMG::Icon.new('foo', 64)
    expect(icon.find_closest_gte_icon).to eq('x64o.png')
  end
end
