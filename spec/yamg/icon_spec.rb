require 'spec_helper'

describe YAMG::Icon do

  ICONS_PATH = Dir.pwd + '/spec/icons/'
  OUT_PATH = Dir.pwd + '/spec/out/'

  describe 'PNG flow' do
    it 'should outputs a png file the size I want' do
      out = OUT_PATH + 'i16.png'
      YAMG::Icon.new(ICONS_PATH, 16).image(OUT_PATH + 'i16.png')
      expect(File.exist?(out)).to be_truthy
      expect(File.size(out)).to eq(524) # transparency channel
      img = ::MiniMagick::Image.open out
      expect(img.width).to eq(16)
      expect(img.height).to eq(16)
    end

    it 'should outputs a png file the size I want 2' do
      out = OUT_PATH + 'i256.png'
      YAMG::Icon.new(ICONS_PATH, 256).image(OUT_PATH + 'i256.png')
      expect(File.exist?(out)).to be_truthy
      expect(File.size(out)).to eq(4952) # transparency channel
      img = ::MiniMagick::Image.open out
      expect(img.width).to eq(256)
      expect(img.height).to eq(256)
    end

    it 'should outputs a png file the size I want 2 with bg' do
      out = OUT_PATH + 'i256bg.png'
      YAMG::Icon.new(ICONS_PATH, 256, 'black').image(OUT_PATH + 'i256bg.png')
      expect(File.exist?(out)).to be_truthy
      expect(File.size(out)).to eq(5141) # transparency channel
      img = ::MiniMagick::Image.open out
      expect(img.width).to eq(256)
      expect(img.height).to eq(256)
    end

    it 'should outputs a png file the size I want 2 with round' do
      out = OUT_PATH + 'i256r.png'
      YAMG::Icon.new(ICONS_PATH, 256, nil, :round).image(out)
      expect(File.exist?(out)).to be_truthy
      expect(File.size(out)).to eq(5089) # transparency channel
      img = ::MiniMagick::Image.open out
      expect(img.width).to eq(256)
      expect(img.height).to eq(256)
    end

    it 'should outputs a png file the size I want 2 with bg & round' do
      out = OUT_PATH + 'i256bgr.png'
      YAMG::Icon.new(ICONS_PATH, 256, '#FF0000', :round).image(out)
      expect(File.exist?(out)).to be_truthy
      expect(File.size(out)).to eq(5089) # transparency channel
      img = ::MiniMagick::Image.open out
      expect(img.width).to eq(256)
      expect(img.height).to eq(256)
    end
  end

  describe 'ICO flow' do
    it 'should output a multiple size ico file' do
      out = OUT_PATH + 'i16.png'
      YAMG::Icon.new(ICONS_PATH, 16).image(OUT_PATH + 'i16.png')
      expect(File.exist?(out)).to be_truthy
      expect(File.size(out)).to eq(524) # transparency channel
    end
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
