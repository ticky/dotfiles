git-changed(1) -- get a list of files which have changed
========================================================

## SYNOPSIS

`git changed`

## DESCRIPTION

Prints a list of files which differ from the "develop" or "master" branch, including those not yet staged.

Useful for, for instance, running specs only on applicable files;

`eslint $(git changed | grep .js$)`

`rspec $(git changed | grep _spec.rb$)`

## SEE ALSO

git-diff(1)
git-develop(1)


[SYNOPSIS]: #SYNOPSIS "SYNOPSIS"
[DESCRIPTION]: #DESCRIPTION "DESCRIPTION"
[SEE ALSO]: #SEE-ALSO "SEE ALSO"


[28point8(1)]: 28point8.1.html
[anycopy(1)]: anycopy.1.html
[anypaste(1)]: anypaste.1.html
[breakpt-test(1)]: breakpt-test.1.html
[breakpt(1)]: breakpt.1.html
[chcase(1)]: chcase.1.html
[colourtest(1)]: colourtest.1.html
[divider(1)]: divider.1.html
[dotfiles-undoc(1)]: dotfiles-undoc.1.html
[ellipse(1)]: ellipse.1.html
[ffcat(1)]: ffcat.1.html
[fn(1)]: fn.1.html
[gifdice(1)]: gifdice.1.html
[gifv(1)]: gifv.1.html
[git-changed(1)]: git-changed.1.html
[git-main(1)]: git-main.1.html
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
