require 'json'
require './lib/image_info_cache'

describe ImageInfoCache do
  # it 'dsfd' do
  #   content = "1.jpg  #{{ phash: '123123123123123' }.to_json}\n" +
  #     "2.jpg  #{{ phash: '444' }.to_json}\n"
  #
  #   IO.write('./spec/fixtures/info_file.txt', content)
  # end

  describe '#read_data' do
    it 'reads lines' do
      iic = ImageInfoCache.new('1.jpg')
      allow(iic).to receive(:read_lines).and_return([%{1.jpg\t{"phash":"444"}}])
      expect(iic.send(:read_data)).to eq({'1.jpg' => { 'phash' => '444' } })
    end
  end

  describe '#write_data' do
    it 'writes data' do
      iic = ImageInfoCache.new('1.jpg')
      allow(iic).to receive(:write_lines)
      iic.send(:write_data, {'1.jpg' => { 'phash' => '444' } })
      expect(iic).to have_received(:write_lines).with([%{1.jpg\t{"phash":"444"}}])
    end
  end
end