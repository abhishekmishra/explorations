.PHONY: all clean build

all: build

run:
	pwsh -Command "cd dist; love .; cd .."

# Run the $env:LITPD_HOME/litpd.ps1 script to build the README.md file
build:
	@echo "Building README.md"
	# create dist directory if it doesn't exist
	pwsh -Command "if (-not (Test-Path dist)) { New-Item -ItemType Directory -Path dist }"
	pwsh -Command "../.luaenv/bin/activate.ps1 ; cd dist ; ${LITPD_HOME}\litpd.ps1 ../README.md -o README.html --to=html --standalone --toc; cd .. "

clean:
	@echo "Cleaning up"
	# remove dist directory, ignore errors
	pwsh -Command "Remove-Item -Recurse -Force -ErrorAction SilentlyContinue dist; exit 0"