.PHONY: all clean build

all: build

run:
	pwsh -Command "love ."

# Run the $env:LITPD_HOME/litpd.ps1 script to build the README.md file
build: clean
	@echo "Building README.md"
	pwsh -Command "../.luaenv/bin/activate.ps1 ; ${LITPD_HOME}\litpd.ps1 README.md -o README.html --to=html --standalone --toc"

	# Remove *.tmp files
	pwsh -Command "Remove-Item -Path *.tmp -Force -ErrorAction SilentlyContinue"

md: clean
	pwsh -Command "../.luaenv/bin/activate.ps1 ; ${LITPD_HOME}\litpd.ps1 README.md -o simplex-terrain-generation.md --to=markdown+pipe_tables-simple_tables-multiline_tables-grid_tables --standalone --toc --wrap=none"

	# Remove *.tmp files
	pwsh -Command "Remove-Item -Path *.tmp -Force -ErrorAction SilentlyContinue"

clean:
	rm main.lua
	rm conf.lua
	rm terrain.lua
	rm simplex_terrain.lua
	@echo "Cleaning up"