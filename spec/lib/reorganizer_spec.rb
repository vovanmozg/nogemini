require './src/config/initialize'
require './src/lib/reorganizer'

describe Reorganizer do
  let(:fixtures_dir) { './spec/fixtures' }

  it 'moves files' do
    dir = Dir.mktmpdir
    FileUtils.mkdir_p(File.join(dir, 'old', 'subdir1'))
    FileUtils.mkdir_p(File.join(dir, 'new', 'subdir2'))
    Dir.mkdir(File.join(dir, 'dups'))
    FileUtils.touch(dir + '/old/subdir1/old1.jpg')
    begin
      dups = [
        {
          "copy": dir + '/old/subdir1/old1.jpg',
          "destination": dir + '/dups/subdir1/old1.jpg'
        }
      ]
      File.write(dir + '/dups.json', dups.to_json)

      Reorganizer.new.call(dir + '/dups.json')
      expect(File).not_to exist(dir + '/old/subdir1/old1.jpg')
      expect(File).to exist(dir + '/dups/subdir1/old1.jpg')

    ensure
      FileUtils.remove_entry(dir)
    end
  end
end
