require 'spec_helper'

describe YAMG::Icon do

  ICONS_PATH = Dir.pwd + '/spec/icons/'
  OUT_PATH = Dir.pwd + '/spec/out/'

  before do
    FileUtils.rm_rf OUT_PATH
    FileUtils.mkdir OUT_PATH
  end

  it 'should outputs a png file the size I want' do
    YAMG::Icon.new(ICONS_PATH, 16).write_out(OUT_PATH + 'foo.png')
  end

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
