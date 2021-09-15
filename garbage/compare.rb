#!/usr/bin/env ruby

require 'phashion'
require './src/shash'
require 'levenshtein'

DB = './data.pstore'

sh = SHash.new(DB)
h = sh.to_h


res = {}
out = ''

h.each do |k1, v1|
	h.each do |k2, v2|
		#res[k1][k2] = Levenshtein.normalized_distance v1.to_s, v2.to_s
		#res[k1][k2] = dl.distance(v1.to_s, v2.to_s)
		distance = Phashion.hamming_distance(v1[:phash], v2[:phash])
		res[k1] = {} if res[k1].nil?
		res[k1][k2] = distance

		out += "#{distance} "

	end

	out += "\n"

	print '.'
end

#p res
IO.write('out.txt', out)



