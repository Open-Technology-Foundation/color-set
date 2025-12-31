# color-set

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL%203.0-blue.svg)](LICENSE)
[![BCS Compliant](https://img.shields.io/badge/BCS-Compliant-green.svg)](https://github.com/Open-Technology-Foundation/bash-coding-standard)

A lightweight bash library for terminal color management using ANSI escape codes.

**Repository:** https://github.com/Open-Technology-Foundation/color-set

## Features

- **Dual-purpose**: Use as a sourceable library or standalone utility
- **Two-tier system**: Basic (5 colors) or Complete (12 colors + attributes)
- **Smart auto-detection**: Automatically disables colors when output is piped or redirected
- **Zero dependencies**: Pure bash, no external tools required
- **BCS-compliant**: Follows [Bash Coding Standard](https://github.com/Open-Technology-Foundation/bash-coding-standard)

## Quick Start

### As a Library

```bash
#!/bin/bash
# Traditional syntax
source color-set
color_set complete

# Or use enhanced syntax (auto-calls color_set)
source color-set complete

echo "${RED}Error:${NC} Something went wrong"
echo "${GREEN}Success:${NC} Operation completed"
echo "${BOLD}${UNDERLINE}Important${NC}"
```

### As a Command

```bash
# Show help
./color-set --help

# Show all color variables
./color-set complete verbose

# Test color output
./color-set complete
```

## Installation

```bash
# Clone from repository
git clone https://github.com/Open-Technology-Foundation/color-set
cd color-set

# Copy to a directory in your path
sudo cp color-set /usr/local/lib/

# Or source directly from your scripts
source /path/to/color-set
```

## Usage

### Function Signature

```bash
color_set [MODE] [TIER] [OPTIONS]
```

### Modes

| Mode | Description |
|------|-------------|
| `auto` | Auto-detect TTY (default) |
| `always` | Force colors on |
| `never` or `none` | Force colors off |

### Tiers

| Tier | Variables | Use Case |
|------|-----------|----------|
| `basic` | 5 colors (default) | Minimal namespace pollution |
| `complete` | 12 colors + attributes | Full feature set |

### Options

| Option | Description |
|--------|-------------|
| `verbose`, `-v`, `--verbose` | Print variable declarations |
| `flags` | Set standard BCS globals for _msg system:<br>- With `basic`: Sets VERBOSE only<br>- With `complete`: Sets VERBOSE, DEBUG, DRY_RUN, PROMPT |
| `--help`, `-h`, `help` | Display usage information (executable mode only) |

Flags can be combined in any order:
```bash
color_set complete always verbose
color_set auto basic
color_set never complete
```

## Color Variables

### Basic Tier (5 variables)

```bash
NC          # No Color / Reset
RED         # \033[0;31m
GREEN       # \033[0;32m
YELLOW      # \033[0;33m
CYAN        # \033[0;36m
```

### Complete Tier (+7 additional)

```bash
BLUE        # \033[0;34m
MAGENTA     # \033[0;35m
BOLD        # \033[1m
ITALIC      # \033[3m
UNDERLINE   # \033[4m
DIM         # \033[2m
REVERSE     # \033[7m
```

## Examples

### Basic Usage

```bash
source color-set
color_set basic

echo "${RED}Error${NC}"
echo "${GREEN}Success${NC}"
echo "${YELLOW}Warning${NC}"
```

### Complete Usage with Attributes

```bash
source color-set
color_set complete

echo "${BOLD}${RED}Critical Error${NC}"
echo "${ITALIC}${BLUE}Information${NC}"
echo "${UNDERLINE}Important${NC}"
echo "${DIM}Less important${NC}"
echo "${REVERSE}Highlighted${NC}"
```

### Combining Colors and Attributes

```bash
source color-set complete  # Enhanced syntax

echo "${BOLD}${UNDERLINE}${RED}CRITICAL${NC}"
echo "${ITALIC}${CYAN}Note: ${NC}${DIM}details...${NC}"
```

### Force Colors On/Off

```bash
# Force colors even when piped
color_set complete always
./my-script.sh | less -R

# Disable colors explicitly
color_set never
```

### Auto-Detection

```bash
# Colors when interactive
./color-set auto

# No colors when piped
./color-set auto > output.txt
./color-set auto | less
```

### Using with BCS _msg System

```bash
#!/bin/bash
# Enhanced syntax with flags
source color-set complete flags

# With complete: VERBOSE, DEBUG, DRY_RUN, PROMPT are all set
# With basic: Only VERBOSE is set
echo "${GREEN}[INFO]${NC} Verbose level: $VERBOSE"
echo "${YELLOW}[DEBUG]${NC} Debug mode: $DEBUG"
echo "${CYAN}[DRY_RUN]${NC} Dry run: $DRY_RUN"
```

## Technical Details

### Auto-Detection Logic

Colors are automatically disabled when:
- stdout is not a terminal (`! -t 1`)
- stderr is not a terminal (`! -t 2`)
- Mode is explicitly set to `never`

### Dual-Purpose Pattern

The script implements BCS010201 dual-purpose pattern:

```bash
# When sourced: provides color_set() function
source color-set
color_set complete

# Enhanced: Pass options directly when sourcing
source color-set complete flags

# When executed: demonstrates colors
./color-set complete verbose
```

The enhanced sourcing syntax automatically calls `color_set` with the provided arguments, eliminating the need for a separate function call.

### Why Two Tiers?

**Basic tier** avoids namespace pollution in scripts that only need simple status colors (errors, warnings, success).

**Complete tier** provides full ANSI capability for rich terminal UIs, progress indicators, or formatted output.

## Requirements

- Bash 5.2+
- Terminal with ANSI color support (most modern terminals)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue at:
https://github.com/Open-Technology-Foundation/color-set

## License

GPL-3.0 License - see [LICENSE](LICENSE) file for details.

Part of the [Open Technology Foundation](https://github.com/Open-Technology-Foundation) bash library collection.

## Related

- [Repository](https://github.com/Open-Technology-Foundation/color-set)
- [Bash Coding Standard](https://github.com/Open-Technology-Foundation/bash-coding-standard)
- BCS Rule BCS0706: Color Management Library
- BCS Rule BCS010201: Dual-Purpose Scripts
- BCS Rule BCS0701: Standardized Messaging and Color Support
- BCS Rule BCS0703: Core Message Functions

#fin
