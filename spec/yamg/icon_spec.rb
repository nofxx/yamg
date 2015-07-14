require 'spec_helper'

describe YAMG::Icon do

  ICONS_PATH = Dir.pwd + '/spec/icons/'
  OUT_PATH = Dir.pwd + '/spec/out/'

  before do
    FileUtils.rm_rf OUT_PATH
    FileUtils.mkdir OUT_PATH
  end

  it 'should outputs a png file the size I want' do
    YAMG::Icon.new(ICONS_PATH, 16).image(OUT_PATH + 'foo.png')
    expect(File.exist?(OUT_PATH + 'foo.png')).to be_truthy
    expect(File.size(OUT_PATH + 'foo.png')).to eq(524)
  end

  it 'should outputs a png file the size I want 2' do
    YAMG::Icon.new(ICONS_PATH, 256).image(OUT_PATH + 'foo.png')
    expect(File.exist?(OUT_PATH + 'foo.png')).to be_truthy
    expect(File.size(OUT_PATH + 'foo.png')).to eq(5230)
  end

  it 'should outputs a png file the size I want 2 with bg' do
    YAMG::Icon.new(ICONS_PATH, 256, '#323232').image(OUT_PATH + 'foo.png')
    expect(File.exist?(OUT_PATH + 'foo.png')).to be_truthy
    expect(File.size(OUT_PATH + 'foo.png')).to eq(5372) # transparency channel
  end

  it 'should outputs a png file the size I want 2 with round' do
    YAMG::Icon.new(ICONS_PATH, 256, nil, :round).image(OUT_PATH + 'foo.png')
    expect(File.exist?(OUT_PATH + 'foo.png')).to be_truthy
    expect(File.size(OUT_PATH + 'foo.png')).to eq(6596) # transparency channel
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
