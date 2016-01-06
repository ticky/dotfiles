breakpt(1) -- console breakpoint shortcut function
==================================================

## SYNOPSIS

`breakpt` <var>breakpoint</var>

## DESCRIPTION

The breakpt(1) command tests the size of the terminal against preset [BREAKPOINTS][], which are sets of minimum and maximum sizes.

These [BREAKPOINTS][] are intended to be used for conditional formatting of the terminal, as in responsive web design.

## BREAKPOINTS

For each of these breakpoints, breakpt(1) will exit with status 0 if the terminal width is;

* `xs`:
  between 0 and 40 columns
* `sm`:
  between 40 and 60 columns
* `md`:
  between 60 and 90 columns
* `lg`:
  between 90 and 120 columns
* `sm-dn`:
  less than 60 columns
* `md-dn`:
  less than 90 columns
* `lg-dn`:
  less than 120 columns
* `sm-up`:
  more than 40 columns
* `md-up`:
  more than 60 columns
* `lg-up`:
  more than 90 columns
* `xl`, `xl-up`:
  more than 120 columns

## SEE ALSO

breakpt-test(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[BREAKPOINTS]: #BREAKPOINTS "BREAKPOINTS"
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
[movieme(1)]: movieme.1.html
[nps(1)]: nps.1.html
[nuname(1)]: nuname.1.html
[onchange(1)]: onchange.1.html
[pycturetube(1)]: pycturetube.1.html
[returnOneOf(1)]: returnOneOf.1.html
[selfie(1)]: selfie.1.html
[shttp(1)]: shttp.1.html
[simplify(1)]: simplify.1.html
[sshmux(1)]: sshmux.1.html
[tminus(1)]: tminus.1.html
[tmx(1)]: tmx.1.html
[untar(1)]: untar.1.html
[xbmcplay(1)]: xbmcplay.1.html
[xbmcqueue(1)]: xbmcqueue.1.html
[zdate(1)]: zdate.1.html
