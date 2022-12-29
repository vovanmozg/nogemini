require './src/lib/meta_file_iterator'
require './src/lib/phash_comparator'
require './src/lib/dups_finder'

class DupsFinder
  def call(options)
    paths_old = options[:paths_old]
    paths_new = options[:paths_new]
    path_dups_from_old = options[:path_dups_from_old]
    path_dups_from_new = options[:path_dups_from_new]

    ii_old = MetaFileIterator.new(paths_old, subdirectories: true)
    ii_new = MetaFileIterator.new(paths_new, subdirectories: true)
    ii_old.preheat
    info("Preheat for old dir finished")
    ii_new.preheat
    info("Preheat for new dir finished")

    comparator = PHashComparator

    compares = 0
    missing_files = 0
    start = Time.now.to_f

    dups = {
      from_new: [],
      from_old: []
    }

    cmps = {}

    ii_new.each_file do |file_new_path, data_new|
      ii_old.each_file do |file_old_path, data_old|
        next if file_new_path == file_old_path

        phash_old = data_old['phash']
        phash_new = data_new['phash']
        next unless validate_phash(phash_old, phash_new)

        if is_phash_similar(data_old, data_new, comparator)
          # If path_old and path_new are the same then we should not compare again
          check_repeats_key = file_new_path + file_old_path
          next if cmps[check_repeats_key]
          cmps[check_repeats_key] = true
          cmps[file_old_path + file_new_path] = true

          dup_data = {}

          if options[:priority] != 'new' && options[:priority] != 'old'
            begin
              # unless File.exist?(file_old_path)
              #   missing_files += 1
              #   next
              # end
              #
              # unless File.exist?(file_new_path)
              #   missing_files += 1
              #   next
              # end

              # Если размер нового файла больше, чем старого, значит
              # дубликатом нужно считать старый файл
              if is_new_bigger(data_old, data_new)
                options[:priority] = 'new'
              else
                options[:priority] = 'old'
              end
            rescue Errno::ENOENT => e
              next
            end
          end
          if options[:priority] == 'new'
            dup_data[:original] = file_new_path
            dup_data[:copy] = file_old_path
            dup_data[:original_source] = :new
            dup_data[:destination] = file_old_path.gsub(data_old['root_path'], path_dups_from_old)
          elsif options[:priority] == 'old'
            dup_data[:original] = file_old_path
            dup_data[:copy] = file_new_path
            dup_data[:original_source] = :old
            dup_data[:destination] = file_new_path.gsub(data_new['root_path'], path_dups_from_new)
          end

          add_dup(dup_data, dups)
        end

        # Print progress bar
        compares += 1
        print '.' if compares % 10_000_000 == 0
      end
    end
    print "\n"

    if path_dups_from_old
      File.write(File.join(path_dups_from_old, 'dups-from-old.json'), JSON.pretty_generate(dups[:from_old]))
    end

    if path_dups_from_new
      File.write(File.join(path_dups_from_new, 'dups-from-new.json'), JSON.pretty_generate(dups[:from_new]))
    end

    # info("compares: #{compares} in #{Time.new.to_f - start} s")
    # info("dups: #{dups[:from_new].size + dups[:from_old].size}")
    # info("missing files: #{missing_files}")

    return {
      compares: compares,
      dups_from_new: dups[:from_new].size,
      dups_from_old: dups[:from_old].size,
      missing_files: missing_files,
      time: Time.new.to_f - start
    }
  end

  def validate_phash(v1, v2)
    !v1.nil? && !v2.nil?
  end

  def is_phash_similar(data_old, data_new, comparator)
    distance = comparator.cmp(data_old, data_new)[:distance]
    distance == 0
  end

  def add_dup(dup_data, dups)
    if dup_data[:original_source] == :old
      dups[:from_new] << dup_data
    end

    if dup_data[:original_source] == :new
      dups[:from_old] << dup_data
    end
  end

  def is_new_bigger(data_old, data_new)
    data_new['geometry']['width'] > data_old['geometry']['width'] &&
      data_new['geometry']['height'] > data_old['geometry']['height']
    # File.size(file_new_path) > File.size(file_old_path)
  end
end
