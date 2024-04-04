<!-- vim: set tw=80: -->
# Introduction

This exploration is not a visual simulation. However it is quite important from
lua and love2d environment setup.

# Problem

## Part I: Native Shared Library Module Loading

For quite some time I've been using love2d to build simulations. When I need
some functionality not available in love2d, I've used a 3-rd party open source
lua library. However I've only been able to use "pure lua" libraries. Any
libraries that are built as a native shared-library has been a problem.

## Part II: Missing FileSystem API Support

Love2d for good reasons supports reading and writing to just one folder on the
file system. This is to maintain compatibility with mobile operating system
environements. However if one is writing an application which will only run on
desktop OSes, then we have the entire file system available. In such a case the
love.filesystem API is not useful, and one needs to use something like
lfs/luafilesystem.

# Solution

## Build an lfs.dll Compatible with Love2d

### Pre-requisites

Love2d is binary compatible with Luajit 2.1 and Lua 5.1. This means we need to
create a Lua installation for one of these versions to be able to build an *lfs*
version compatible with love2d.

So we need:
1. Setup Love2d compatible Lua environment
2. Install luarocks in the same environment
3. Build and install luafilessytem using luarocks in the above environment.
4. Use lfs.dll build in step#3 in love2d.


### Hererocks Luajit environment (Step 1 & 2 above)

Install hererocks using `pip`.

```
pip install git+https://github.com/luarocks/hererocks
```

Open "x64 Visual Studio Tools" command prompt and use hererocks to build luajit
environment.

The command below installs luajit v2.1 and latest luarocks:

```
hererocks luajit21_love -j 2.1 -r latest
```

### Install LFS (Step 3)
Activate the newly created lua environment

```
luajit21_love\bin\activate.bat
```

Install lfs using luarocks

```
luarocks install luafilesystem
```

### Use lfs.dll (Step 4)

Copy the resultant lfs.dll into the love2d program folder.

```
copy luajit21_love\lib\lua\5.1\lfs.dll <lua_program_folder>\
```

Now one can use `love .` in the **<lua_program_folder>** with `require 'lfs'` in
main.lua. See the `main.lua` in this simulation to see how to use lfs in love2d.


