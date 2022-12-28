require './src/config/initialize'
require './src/lib/dups_finder'

describe DupsFinder do
  let(:fixtures_dir) { './spec/fixtures' }

  it 'keeps originals in old directory' do
    begin
      DupsFinder.new.call(
        paths_new: ['./spec/fixtures/dups_finder/new'],
        paths_old: ['./spec/fixtures/dups_finder/old'],
        path_dups_from_new: './spec/tmp',
        priority: 'old'
      )
      content = File.read(File.join('./spec/tmp', 'dups.json'))
    ensure
      FileUtils.remove_entry('./spec/tmp/dups.json')
    end
    expected = IO.read('./spec/fixtures/dups_finder/dups_from_new.json')
    expect(content.strip).to eq(expected.strip)
  end

  it 'keeps originals in new directory' do
    begin
      DupsFinder.new.call(
        paths_new: ['./spec/fixtures/dups_finder/new'],
        paths_old: ['./spec/fixtures/dups_finder/old'],
        path_dups_from_old: './spec/tmp',
        priority: 'new'
      )
      content = File.read(File.join('./spec/tmp', 'dups.json'))
    ensure
      FileUtils.remove_entry('./spec/tmp/dups.json')
    end
    expected = IO.read('./spec/fixtures/dups_finder/dups_from_old.json')
    expect(content.strip).to eq(expected.strip)
  end
end
