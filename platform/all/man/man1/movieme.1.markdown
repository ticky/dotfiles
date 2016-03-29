movieme(1) -- create an animated gif from a movie file
======================================================

## SYNOPSIS

`movieme` <var>path</var> [`--start` <var>start-time</var>] [`--duration` <var>duration</var>] [`--framerate` <var>framerate</var>] [`--width` <var>width</var>] [`--no-dither`] [`--interactive` | `--continue`] [`--cleanup`]

## DESCRIPTION

The movieme(1) command creates an animated gif from a movie file

## OPTIONS

* <var>path</var>:
  path to the movie we're converting
* `--start`, `-s`:
  start time of the finished product  
  Default: <var>0</var>
* `--duration`, `-d`:
  duration of the video sequence  
  Default: <var>5</var>
* `--framerate`, `-f`:
  target framerate of the gif  
  Default: <var>7</var>
* `--no-dither`, `-n`:
  disable dithering of the output gif. Can reduce file size in some cases
* `--width`, `-w`:
  target width of the gif  
  Default: <var>500</var>
* `--interactive`, `-i`:
  extract frames, then exit to allow modifying individual frames
* `--continue`:
  continue conversion after calling `--interactive`
* `--cleanup`:
  delete temporary files after completion. Cannot be used with `--interactive`

## SEE ALSO

ffmpeg(1), convert(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[OPTIONS]: #OPTIONS "OPTIONS"
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
[git-develop(1)]: git-develop.1.html
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
