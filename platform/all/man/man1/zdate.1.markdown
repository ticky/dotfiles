zdate(1) -- zsh-powered date formatting
=======================================

## SYNOPSIS

`zdate` <var>format</var> [<var>datestamp</var>]

## DESCRIPTION

The zdate(1) command formats a date using your system's strftime(3) via the zsh/datetime module, and some custom additions.

## OPTIONS

* <var>format</var>:
  specifies the format to display the time in. Accepts either one of the [PRESET FORMATS][], or a full format string like strftime(3), with additions as specified in the [FORMAT][] section.

* [<var>datestamp</var>]:
  Unix time to render. If unset, the current date and time are retrieved automatically.

## FORMAT

The format options are identical to your system's strftime(3), with the following additions;

* `%P`:
  is replaced with either "am" or "pm" as appropriate. This token is normalised to render the same across BSD strftime(3) and GNU strftime(3).

* `%i`:
  is replaced with the current Swatch Internet Time (Beats)

## PRESET FORMATS

* `beats`, `b`:
  Swatch Internet Time - "@778". Equivalent to "@%i"
* `short`, `s`:
  time only - "9:41 am". Equivalent to "%L:%M %P"
* `medium`, `m`:
  time and day - "Tue 9:41 am". Equivalent to "%a %L:%M %P"
* `long`, `l`:
  date, month, day of month and time - "Tue Jan 9 9:41 am". Equivalent to "%a %b %f %L:%M %P"
* `full`, `f`:
  long date, month, day of month and time - "Tuesday, January 9 2007 9:41:00 am". Equivalent to "%A, %B %f %G %L:%M:%S %P"
* `8601`, `iso`, `i`:
  ISO 8601-style format - "2007-01-09T09:41:00-0800". Equivalent to "%Y-%m-%dT%H:%M:%S%z"

## SEE ALSO

date(1), strftime(3), zshmodules(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[OPTIONS]: #OPTIONS "OPTIONS"
[FORMAT]: #FORMAT "FORMAT"
[PRESET FORMATS]: #PRESET-FORMATS "PRESET FORMATS"
[SEE ALSO]: #SEE-ALSO "SEE ALSO"


[28point8(1)]: 28point8.1.html
[anycopy(1)]: anycopy.1.html
[anypaste(1)]: anypaste.1.html
[breakpt-test(1)]: breakpt-test.1.html
[breakpt(1)]: breakpt.1.html
[chcase(1)]: chcase.1.html
[colourtest(1)]: colourtest.1.html
[divider(1)]: divider.1.html
[ellipse(1)]: ellipse.1.html
[fn(1)]: fn.1.html
[git-push-all(1)]: git-push-all.1.html
[gravatar(1)]: gravatar.1.html
[gz(1)]: gz.1.html
[ipgrep(1)]: ipgrep.1.html
[mansi(1)]: mansi.1.html
[mdwrap(1)]: mdwrap.1.html
[nuname(1)]: nuname.1.html
[pycturetube(1)]: pycturetube.1.html
[returnOneOf(1)]: returnOneOf.1.html
[shttp(1)]: shttp.1.html
[simplify(1)]: simplify.1.html
[sshmux(1)]: sshmux.1.html
[tminus(1)]: tminus.1.html
[tmx(1)]: tmx.1.html
[untar(1)]: untar.1.html
[xbmcplay(1)]: xbmcplay.1.html
[xbmcqueue(1)]: xbmcqueue.1.html
[zdate(1)]: zdate.1.html
