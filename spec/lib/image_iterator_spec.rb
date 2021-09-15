require './lib/image_iterator'

describe ImageIterator do
  let(:fixtures_dir) { './spec/fixtures' }

  it 'returns filenames' do
    ii = ImageIterator.new(fixtures_dir)
    expect(ii.each_file).to eq(%w(./spec/fixtures/2.jpg ./spec/fixtures/1.jpg))
  end

  it 'returns filenames' do
    ii = ImageIterator.new(fixtures_dir)
    files = []
    ii.each_file.each { |file| files << file }
    expect(files).to eq(%w(./spec/fixtures/2.jpg ./spec/fixtures/1.jpg))
  end
end

