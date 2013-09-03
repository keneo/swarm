swarm
=====

Swarm is a tutorial and toolkit for offline Computercraft (without http)

First steps
===========

```shell
edit /r
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

Test. Now you can copy&paste:

```lua
r write("Hello!\n")
```
```
Hello!
```

Unfortunately you can't use spaces so its not easy to write full "Hello World!".

Copy&Paste:
```lua
r write("Hello"..string.char(32).."World!\n")
```
```
Hello World!
```






