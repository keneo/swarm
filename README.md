swarm
=====

Swarm is a tutorial and toolkit for offline Computercraft (without http)

Copy&paste
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

Copy&paste this:
```lua
r file=fs.open("b","w")file.write(read().."\n")file.write(read().."\n")file.close()shell.run("b")
write("Hello World!\n")

write("Hello World!\n")
```












