.PHONY: all clean build

all: build

run:
	pwsh -Command "love ."

# Run the $env:LITPD_HOME/litpd.ps1 script to build the README.md file
build:
	@echo "Building README.md"
	pwsh -Command "../.luaenv/bin/activate.ps1 ; ${LITPD_HOME}\litpd.ps1 README.md -o README.html --to=html --standalone --toc"

	# Remove *.tmp files
	pwsh -Command "Remove-Item -Path *.tmp -Force -ErrorAction SilentlyContinue"

	${LITPD_HOME}\stylua main.lua

pdf: clean
	pwsh -Command "../.luaenv/bin/activate.ps1 ; ${LITPD_HOME}\litpd.ps1 README.md -o polar-noise-loops.pdf --to=pdf"

clean:
	@echo "Cleaning up"
	rm -f main.lua
	rm -f conf.lua
