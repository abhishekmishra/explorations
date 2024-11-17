.PHONY: luaenv luaenv51 loveluaenv

luaenv:
	@echo "Setting up luaenv (with lua 5.4 and latest luarocks)... "
	@echo "IMPORTANT: RUN this from x64 Native Tools Command Prompt for VS"
	hererocks .luaenv --lua 5.4 --luarocks latest
	pwsh -Command ".luaenv/bin/activate.ps1 ; luarocks install busted"
	pwsh -Command ".luaenv/bin/activate.ps1 ; luarocks install luafilesystem"

luaenv51:
	@echo "Setting up luaenv (with lua 5.1 and latest luarocks)... "
	@echo "IMPORTANT: RUN this from x64 Native Tools Command Prompt for VS"
	hererocks .luaenv --lua 5.1 --luarocks latest
	pwsh -Command ".luaenv/bin/activate.ps1 ; luarocks install busted"

loveluaenv:
	@echo "Setting up loveluaenv (with luajit 2.1 and latest luarocks)... "
	@echo "IMPORTANT: RUN this from x64 Native Tools Command Prompt for VS"
	hererocks .loveluaenv --luajit 2.1 --luarocks latest
	pwsh -Command ".loveluaenv/bin/activate.ps1 ; luarocks install luafilesystem"

