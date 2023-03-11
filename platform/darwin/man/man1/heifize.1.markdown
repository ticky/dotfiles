heifize(1) -- creates HEIF copies of images
===========================================

## SYNOPSIS

`heifize` [<var>image</var>...] <var>image</var>

## DESCRIPTION

The heifize(1) command creates HEIF copies of image file arguments, while preserving metadata

The output filename is the original filename with a "heif" extension

If parallel(1) is available, the operations will be parallelised to run on all CPU cores

## OPTIONS

* <var>image</var>:
  any image file sips supports.

## SEE ALSO

sips(1), parallel(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[OPTIONS]: #OPTIONS "OPTIONS"
[SEE ALSO]: #SEE-ALSO "SEE ALSO"


[globalify(1)]: globalify.1.html
[heifize(1)]: heifize.1.html
[lstcp(1)]: lstcp.1.html
[np(1)]: np.1.html
[pbcopyfile(1)]: pbcopyfile.1.html
[textual-thumbnails-off(1)]: textual-thumbnails-off.1.html
[textual-thumbnails-on(1)]: textual-thumbnails-on.1.html
[tweetbot-thumbnails-off(1)]: tweetbot-thumbnails-off.1.html
[tweetbot-thumbnails-on(1)]: tweetbot-thumbnails-on.1.html
