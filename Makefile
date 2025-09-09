.PHONY: help luaenv luaenv51 luaenv54 loveluaenv l2dproject

help: ## Show this help message
	@echo "Available targets:"
	@echo ""
	@echo "  help         - Show this help message"
	@echo "  luaenv       - Set up Lua environment (defaults to Lua 5.1)"
	@echo "  luaenv51     - Set up Lua environment with Lua 5.1 and luarocks"
	@echo "  luaenv54     - Set up Lua environment with Lua 5.4 and luarocks"
	@echo "  loveluaenv   - Set up Love2D Lua environment with LuaJIT 2.1"
	@echo "  l2dproject   - Create a new Love2D project (Usage: make l2dproject PROJECT_NAME=your_project_name)"
	@echo ""

luaenv: luaenv51

luaenv54:
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
	pwsh -Command ".luaenv/bin/activate.ps1 ; luarocks install luafilesystem"

loveluaenv:
	@echo "Setting up loveluaenv (with luajit 2.1 and latest luarocks)... "
	@echo "IMPORTANT: RUN this from x64 Native Tools Command Prompt for VS"
	hererocks .loveluaenv --luajit 2.1 --luarocks latest
	pwsh -Command ".loveluaenv/bin/activate.ps1 ; luarocks install luafilesystem"

l2dproject:
	@if [ -z "$(PROJECT_NAME)" ]; then \
		echo "Error: PROJECT_NAME is required. Usage: make l2dproject PROJECT_NAME=your_project_name"; \
		exit 1; \
	fi
	@echo "Creating Love2D project: $(PROJECT_NAME)"
	python empty_love2d_project.py $(PROJECT_NAME)
