SERVICES=postgresql mongodb azurite cosmosdb
SHELL_FILES=lib/*.sh src/*.sh

.DEFAULT_GOAL := help

help:
	@printf '%s\n' 'Available targets:'
	@for service in $(SERVICES); do \
		printf '  %-20s %s\n' "start-$$service" "Start $$service"; \
		printf '  %-20s %s\n' "stop-$$service" "Stop $$service"; \
	done
	@printf '  %-20s %s\n' "lint" "Lint shell scripts"
	@printf '  %-20s %s\n' "format" "Format shell scripts"
	@printf '  %-20s %s\n' "format-check" "Check shell script formatting"
	@printf '  %-20s %s\n' "check" "Run lint and format-check"

start-%:
	@if [ -z "$(filter $*,$(SERVICES))" ]; then \
		printf 'Unsupported service: %s\n' "$*" >&2; \
		exit 1; \
	fi
	@./src/$*.sh

stop-%:
	@if [ -z "$(filter $*,$(SERVICES))" ]; then \
		printf 'Unsupported service: %s\n' "$*" >&2; \
		exit 1; \
	fi
	@./lib/stop.sh $*

lint:
	@command -v shellcheck >/dev/null 2>&1 || { printf 'Missing shellcheck. Install it and retry.\n' >&2; exit 1; }
	@bash -n $(SHELL_FILES)
	@shellcheck -x -P lib $(SHELL_FILES)

format:
	@command -v shfmt >/dev/null 2>&1 || { printf 'Missing shfmt. Install it and retry.\n' >&2; exit 1; }
	@shfmt -w $(SHELL_FILES)

format-check:
	@command -v shfmt >/dev/null 2>&1 || { printf 'Missing shfmt. Install it and retry.\n' >&2; exit 1; }
	@shfmt -d $(SHELL_FILES)

check: lint format-check

.PHONY: \
	help \
	lint \
	format \
	format-check \
	check
