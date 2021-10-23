# Using


Index

First you should index all your photos. The index is the database with 
an information about every file: path, size, and other properties (depends
on start arguments).

`bin/index`

Find duplicates

You can find similar photos based on indexed attributes such as width,
height, perceptual hash and etc. 

`bin/find-similar DIRECTORY_PATH`

Process duplicates

You can move or delete duplicates

`bin/reorganize`


# Requirements

- imagemagic
- exiftool
- phash


# TODO
- Add fast comparing type (by size, by content)
