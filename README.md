swarm
=====

Swarm is a tutorial and toolkit for offline Computercraft (without http)

1. Goal: Copy&paste
=============

First goal is to make it possible to copy multiline lua scripts from Windows text editor.

1.1. Step: 'r' run lua code from command line
==========

```shell
edit r
```

Manually type (or copy&paste line by line):

```lua
file=fs.open("b","w")
file.write(({...})[1])
file.close()
shell.run("b")
```

or as 1 line

```lua
file=fs.open("b","w")file.write(({...})[1])file.close()shell.run("b")
```

Press CTRL,ENTER,CTRL,RIGHT,ENTER

Test. Now you can lua from command line. Copy&paste this input computercraft shell:

```lua
r write("Hello!\n")
```
```
Hello!
```

Unfortunately you can't use SPACE or ENTER so its not so easy to write full "Hello World!":

Copy&Paste:
```lua
r write("Hello"..string.char(32).."World!\n")
```
```
Hello World!
```

1.2. Multiline copy&paste
=================

Let's try to make copypasting more handy

https://github.com/keneo/swarm/blob/master/ScriptMinifyFiddle.md

So now I assume you can copy paste very small programs into Computercraft (via fiddle page).

2. Make your files persistant
=============================

```
label set foobar
```
```
Computer label set to "foobar"
```

3. 't' DSL for turtle
=================

Check the t.lua file source and use https://github.com/keneo/swarm/blob/master/ScriptMinifyFiddle.md to upload it to your turtle.
I.e. (really build it yourself with https://github.com/keneo/swarm/blob/master/t.lua and https://github.com/keneo/swarm/blob/master/ScriptMinifyFiddle.md, this line below is outdated)
```
r shell.run("r","t=turtle;d={[\"f\"]=t.forward,[\"u\"]=t.up,[\"d\"]=t.down,[\"b\"]=t.back,[\"l\"]=t.turnLeft,[\"r\"]=t.turnRight,[\"F\"]=t.dig,[\"U\"]=t.digUp,[\"D\"]=t.digDown};({...})[1]:gsub(\".\",function(c)d[c]()end)")
```
(Since program is longer than 128 chars, you have to make 2 copypastes.)

Save as 't':
```
copy b t
```



Usage: t [code]

Code is a sequence of chars. 1 char = 1 command.

* f - turtle.forward()
* b - turtle.back()
* u - turtle.up()
* d - turtle.down()
* l - turtle.turnLeft()
* r - turtle.turnRight()
* F - turtle.dig()
* U - turtle.digUp()
* D - turtle.digDown()

4. First app for t
==================

Lets dig make stairs down of length 5. We need sth like:
```
UFDf UFDd
UFDf UFDd
UFDf UFDd
UFDf UFDd
UFDf UFDd
```
So we have to put:
```
t UFDfUFDdUFDfUFDdUFDfUFDdUFDfUFDdUFDfUFDd
```

Not very readable isn't.

It would be cool if we could:

```
t2 5x(UFDf_UFDd)
```

Or

```
t2 :M=UFD 5x(MfMd)
```

Continue???
===============
