# Makefile at the root directory

.PHONY: all build release clean

# Default target (no-op)
all: build

# Install dependencies
build:
	cd ror && bundle install

# Prepare assets for production (if needed)
release:
	cd ror && bundle exec rake assets:precompile

# Remove any temporary files or build artifacts (optional)
clean:
	cd ror && bundle exec rake tmp:clear