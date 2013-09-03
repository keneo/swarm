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

Test:

```lua
r write("Hello World!")
```
