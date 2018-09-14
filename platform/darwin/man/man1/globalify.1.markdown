globalify(1) -- make your Australian contact entries work internationally
=========================================================================

## SYNOPSIS

`globalify`

## DESCRIPTION

The globalify(1) command updates all non-internationally prefixed Australian (see [CAVEATS][]) with a +61 prefix, so your address book works if you jump to an international carrier.

## CAVEATS

  * Only formats numbers with a leading zero.
  * Assumes any number beginning with a 0 MUST be an Australian number.
  * Is naive about "trimming" and formatting numbers (read: won't write pretty numbers, macOS/iOS will display them nicely though).
  * Success is indicated by the output of "missing value" >_>.


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[CAVEATS]: #CAVEATS "CAVEATS"


[globalify(1)]: globalify.1.html
[lstcp(1)]: lstcp.1.html
[np(1)]: np.1.html
[pbcopyfile(1)]: pbcopyfile.1.html
[textual-thumbnails-off(1)]: textual-thumbnails-off.1.html
[textual-thumbnails-on(1)]: textual-thumbnails-on.1.html
[tweetbot-thumbnails-off(1)]: tweetbot-thumbnails-off.1.html
[tweetbot-thumbnails-on(1)]: tweetbot-thumbnails-on.1.html
