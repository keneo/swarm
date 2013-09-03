swarm
=====

Swarm is a tutorial and toolkit for offline Computercraft (without http)

1. Copy&paste
==========

First goal is make it possible to copy my lua code from my Windows text editor.

```shell
edit r
```

Manually type:

```lua
file=fs.open("b","w")
a={...}
file.write(a[1])
file.close()
shell.run("b")
```

Press CTRL,ENTER,CTRL,RIGHT,ENTER

Test. Now you can copy&paste somethig:

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

Let's try to make copypasting more handy

http://jsfiddle.net/9WbbP/2/

NOTE: Minecraft copy&paste appears to limit the copypaste to 128 chars (?) :\

So here is more HC version:

http://jsfiddle.net/MZ4Vt/2/

So now I assume you can copy paste very small programs into Computercraft.

2. Make your files persistant
=============================

```
label set foobar
```
```
Computer label set to "foobar"
```

3. DSL for turtle
=================

Check the t.lua file source and use http://jsfiddle.net/MZ4Vt/2/ to upload it to your turtle.
I.e.
```
r shell.run("r","t=turtle;a={...};p=a[1];d={[\"f\"]=t.forward,[\"u\"]=t.up,[\"d\"]=t.down,[\"b\"]=t.back,[\"l\"]=t.turnLeft,[\"r\"]=t.turnRight,[\"F\"]=t.dig,[\"U\"]=t.digUp,[\"D\"]=t.digDown};p:gsub(\".\",function(c)d[c]()end)")
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
