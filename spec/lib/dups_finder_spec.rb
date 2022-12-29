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

  it 'selects bigger' do
    begin
      DupsFinder.new.call(
        paths_new: ['./spec/fixtures/dups_finder/similar'],
        paths_old: ['./spec/fixtures/dups_finder/similar'],
        path_dups_from_old: './spec/tmp',
        path_dups_from_new: './spec/tmp'
      )
      content_old = File.read(File.join('./spec/tmp', 'dups-from-old.json'))
      content_new = File.read(File.join('./spec/tmp', 'dups-from-new.json'))

    ensure
      FileUtils.remove_entry('./spec/tmp/dups-from-old.json')
      FileUtils.remove_entry('./spec/tmp/dups-from-new.json')
    end

    expected_old = IO.read('./spec/fixtures/dups_finder/similar/dups-from-old.json')
    expect(content_old.strip).to eq(expected_old.strip)

    expected_new = IO.read('./spec/fixtures/dups_finder/similar/dups-from-new.json')
    expect(content_new.strip).to eq(expected_new.strip)
  end
end
