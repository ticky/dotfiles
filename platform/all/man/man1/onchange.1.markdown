onchange(1) -- run a command when the output of another changes
===============================================================

## SYNOPSIS

`onchange` <var>command</var> [`--interval` <var>seconds</var>] [`--onchange` <var>command</var>] [`--once`]

## DESCRIPTION

The onchange(1) command watches the output of a command, and triggers another when the output changes

## OPTIONS

* <var>command</var>:
  command to monitor the output of
* `--interval`, `-n`:
  seconds to wait before running <var>command</var> again  
  Default: <var>2</var>
* `--onchange`, `-c`:
  command to run when a change is detected
* `--once`, `-o`:
  exit when the first change is detected

## CAVEATS

Unlike watch(1), the output is neither displayed nor shown full-screen

## SEE ALSO

watch(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[OPTIONS]: #OPTIONS "OPTIONS"
[CAVEATS]: #CAVEATS "CAVEATS"
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
