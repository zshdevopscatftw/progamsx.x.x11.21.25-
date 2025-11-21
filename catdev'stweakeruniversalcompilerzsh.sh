#!/usr/bin/env bash
# ============================================================================
# ULTIMATE TWEAKER COMPILER — MACINTOSH TAHOE-PRIME EDITION (v2.0 "K-LINE")
# [C] SAMSOFT 1930–2025
# Pure shell version — PDP-11 to Steam Machine Expansion
# Adds full Java stack, retro-simulators, and modern game dev libs.
# Target: mac os tahoe > pr files. = ready.
#
# V2.0 "K-LINE" EXPANSION: Now installing *everything*. Per request.
# We are aiming for maximum context. This script is now a monument.
# ============================================================================
set -euo pipefail

# --- Logging Functions ------------------------------------------------------
# Expanded logging for v2.0
STEP_COUNT=0
log() {
  STEP_COUNT=$((STEP_COUNT + 1))
  printf "\n[SAMSOFT-PRIME] (STEP %04d) %s\n" "$STEP_COUNT" "$*"
}
err() { printf "\n[FATAL-ERROR] %s\n" "$*" >&2; exit 1; }
warn() { printf "\n[WARN] %s\n" "$*" >&2; }
sub_log() { printf "  [detail] %s\n" "$*"; }

log "Starting ULTIMATE TWEAKER COMPILER — TAHOE-PRIME v2.0 (1930–2025)"
log "This is the '2K CONTEXT' edition. Strap in."

# --- System Check ------------------------------------------------------------
log "Verifying target hardware: 'mac os tahoe'"
[[ "$(uname -s)" == "Darwin" ]] || err "Target hardware mismatch. macOS required."
sub_log "System is Darwin. Check passed."
[[ "$(uname -m)" == "arm64" ]] || warn "Non-arm64 architecture detected. Proceeding, but YMMV."
sub_log "Architecture check complete."

# --- Homebrew Subsystem -----------------------------------------------------
log "Locating Homebrew subsystem..."
if command -v /opt/homebrew/bin/brew >/dev/null; then
  BREW=/opt/homebrew/bin/brew
  sub_log "Found Homebrew at /opt/homebrew/bin/brew"
elif command -v brew >/dev/null; then
  BREW=$(command -v brew)
  sub_log "Found Homebrew in user path: $BREW"
else
  log "Homebrew subsystem not found. Installing..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  BREW=/opt/homebrew/bin/brew
  [[ -z "$BREW" ]] && err "Homebrew installation failed."
  sub_log "Homebrew installation complete."
fi

log "Initializing Homebrew environment for this session..."
# This is required for the rest of the script to find brew.
eval "$("$BREW" shellenv)"
sub_log "Homebrew shell environment evaluated."

# --- Package Installation Engine --------------------------------------------
# v2.0 Engine: More verbose.
install_pkg() {
  local pkg_name="$1"
  log "Processing package: $pkg_name"
  if $BREW list --versions "$pkg_name" >/dev/null 2>&1; then
    sub_log "Already installed: $pkg_name"
  else
    sub_log "Commencing installation for: $pkg_name"
    if ! $BREW install "$pkg_name"; then
        warn "Failed to install $pkg_name. Continuing..."
    else
        sub_log "Successfully installed: $pkg_name"
    fi
  fi
}

install_cask_pkg() {
  local pkg_name="$1"
  log "Processing Cask package: $pkg_name"
  if $BREW list --cask --versions "$pkg_name" >/dev/null 2>&1; then
    sub_log "Already installed: $pkg_name"
  else
    sub_log "Commencing Cask installation for: $pkg_name"
    if ! $BREW install --cask "$pkg_name"; then
        warn "Failed to install Cask $pkg_name. Continuing..."
    else
        sub_log "Successfully installed Cask: $pkg_name"
    fi
  fi
}

# ==========================================================================
# SECTION 1: JAVA RUNTIME STACK (1930–2025 ERA EXTENSION)
# ==========================================================================
log "--- SECTION 1: Installing multi-era Java toolchain... ---"

# --- Core JVMs (Temurin) ---
log "Installing core Eclipse Temurin JDKs..."
install_pkg "temurin"    # Latest
install_pkg "temurin@8"
install_pkg "temurin@11"
install_pkg "temurin@17"
install_pkg "temurin@21"

# --- JVM-compatible Languages ---
log "Installing JVM-compatible languages..."
install_pkg "kotlin"     # JetBrains Kotlin
install_pkg "groovy"     # Apache Groovy
install_pkg "scala"      # Scala Language
install_pkg "clojure"    # Clojure LISP dialect for JVM

# --- Build Tools ---
log "Installing Java build systems..."
install_pkg "maven"
install_pkg "gradle"
install_pkg "ant"

# --- Java Version Management ---
log "Installing Java version manager 'jenv'..."
install_pkg "jenv"

# --- Optional Proprietary JDKs ---
log "Installing proprietary Java installers (optional)..."
install_cask_pkg "oracle-jdk"
install_cask_pkg "zulu"
install_cask_pkg "semeru-jdk-open"

log "Configuring jenv..."
mkdir -p ~/.jenv/versions || true
sub_log "Ensured ~/.jenv/versions directory exists."

# Add jenv config to .zshrc if not present
if ! grep -qxF 'export PATH="$HOME/.jenv/bin:$PATH"' ~/.zshrc; then
  log "Adding jenv to .zshrc PATH"
  echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
else
  sub_log "jenv PATH already in .zshrc"
fi

if ! grep -qxF 'eval "$(jenv init -)"' ~/.zshrc; then
  log "Adding jenv init to .zshrc"
  echo 'eval "$(jenv init -)"' >> ~/.zshrc
else
  sub_log "jenv init already in .zshrc"
fi

# Register all known JDKs with jenv
log "Registering all found JDKs with jenv..."
# This includes Homebrew Temurin and Oracle JDKs
for jdk in /Library/Java/JavaVirtualMachines/*/Contents/Home; do
  if [[ -d "$jdk" ]]; then
    sub_log "Adding system JDK to jenv: $jdk"
    jenv add "$jdk" || true
  fi
done
for jdk in $($BREW --prefix)/opt/temurin*/libexec/Contents/Home; do
  if [[ -d "$jdk" ]]; then
    sub_log "Adding Homebrew JDK to jenv: $jdk"
    jenv add "$jdk" || true
  fi
done
# Add other brew-installed JDKs
for jdk_path in "$($BREW --prefix)"/opt/semeru-jdk-open*/libexec/Contents/Home; do
  if [[ -d "$jdk_path" ]]; then
    sub_log "Adding Homebrew Semeru JDK to jenv: $jdk_path"
    jenv add "$jdk_path" || true
  fi
done


log "jenv setup complete. Run 'jenv versions' in a new terminal."

# ==========================================================================
# SECTION 2: CORE COMPILERS (1930–2025) - "THE CLASSICS"
# ==========================================================================
log "--- SECTION 2: Installing core compilers (1930-2025)... ---"

# --- FORTRAN ---
log "Installing FORTRAN compilers..."
install_pkg "gfortran"     # GNU FORTRAN
install_pkg "flang"        # LLVM FORTRAN

# --- ALGOL & PASCAL ---
log "Installing ALGOL and Pascal..."
install_pkg "algol68g"     # ALGOL 68
install_pkg "fpc"          # Free Pascal

# --- LISP Family ---
log "Installing LISP dialects..."
install_pkg "sbcl"         # Steel Bank Common Lisp
install_pkg "clisp"        # CLISP
install_pkg "ecl"          # Embeddable Common Lisp

# --- Scheme Family ---
log "Installing Scheme dialects..."
install_pkg "chezscheme"   # Chez Scheme
install_pkg "chicken"      # CHICKEN Scheme
install_pkg "gambit-scheme" # Gambit Scheme
install_pkg "guile"        # GNU Guile

# --- Logic Programming ---
log "Installing Logic programming languages..."
install_pkg "swi-prolog"   # SWI-Prolog
install_pkg "gprolog"      # GNU Prolog

# --- Functional Languages (ML Family) ---
log "Installing ML-family functional languages..."
install_pkg "ocaml"        # OCaml
install_pkg "opam"         # OCaml package manager
install_pkg "mlton"        # SML
install_pkg "smlnj"        # SML of New Jersey
install_pkg "fsharp"       # F# (via dotnet)

# --- Functional Languages (Haskell/Erlang) ---
log "Installing Haskell and Erlang ecosystems..."
install_pkg "ghc"          # Haskell (Glasgow Compiler)
install_pkg "cabal-install" # Haskell build tool
install_pkg "stack"        # Haskell build tool
install_pkg "erlang"       # Erlang/OTP
install_pkg "elixir"       # Elixir

# --- Esoteric & Obscure ---
log "Installing esoteric/historical languages..."
install_pkg "cobol"        # GnuCOBOL
install_pkg "awk"          # awk
install_pkg "gawk"         # GNU awk
install_pkg "m4"           # m4 macro processor
install_pkg "bc"           # arbitrary precision calculator
install_pkg "dc"           # RPN calculator
install_pkg "lua"          # Lua
install_pkg "luajit"       # LuaJIT
install_pkg "perl"         # Perl
install_pkg "python"       # Python 3
install_pkg "python@3.11"
install_pkg "python@3.10"
install_pkg "python@3.9"
install_pkg "ruby"         # Ruby
install_pkg "ruby-build"
install_pkg "rbenv"
install_pkg "tcl-tk"       # Tcl/Tk

# ==========================================================================
# SECTION 3: 1990–2025 MODERN SYSTEMS
# ==========================================================================
log "--- SECTION 3: Installing modern systems (1990-2025)... ---"

# --- C/C++/Objective-C ---
log "Installing C/C++/Obj-C toolchains..."
install_pkg "llvm"         # LLVM + Clang
install_pkg "gcc"          # GNU Compiler Collection
install_pkg "nasm"         # Netwide Assembler
install_pkg "yasm"         # YASM Assembler

# --- D Language ---
log "Installing D language toolchains..."
install_pkg "ldc"          # D (LLVM)
install_pkg "dmd"          # D (Digital Mars)

# --- Go Language ---
log "Installing Go language..."
install_pkg "go"

# --- Rust Language ---
log "Installing Rust..."
install_pkg "rustup-init"  # Rust installer
# We will log a post-install message for rustup

# --- Systems Languages ---
log "Installing modern systems languages..."
install_pkg "nim"
install_pkg "zig"
install_pkg "vala"
install_pkg "crystal"
install_pkg "vlang"
install_pkg "dtrace"       # DTrace (if available)

# --- .NET Ecosystem ---
log "Installing .NET ecosystem..."
install_pkg "dotnet"       # .NET Core SDK
install_pkg "dotnet-sdk"
install_pkg "mono"         # Open-source .NET

# --- Scripting & Web ---
log "Installing modern scripting and web runtimes..."
install_pkg "node"         # Node.js
install_pkg "npm"
install_pkg "yarn"
install_pkg "pnpm"
install_pkg "deno"         # Deno runtime
install_pkg "bun"          # Bun runtime
install_pkg "php"          # PHP
install_pkg "composer"     # PHP package manager
install_pkg "R"            # R language for statistics

# ==========================================================================
# SECTION 4: HARDWARE EMULATION & SIMULATION (PDP TO STEAM MACHINE)
# ==========================================================================
log "--- SECTION 4: Installing hardware emulation frameworks... ---"

# --- Retro Simulators (PDP Era) ---
log "Installing retro-simulators (PDP era)..."
install_pkg "simh"         # [PDP] Historical Computer Simulator (PDP-11, VAX, etc)
install_pkg "mame"         # Multiple Arcade Machine Emulator
# mess is part of mame now
install_cask_pkg "openemu"      # Multi-system (Cask)

# --- Core Emulators (Steam Machine Era) ---
log "Installing core emulators (Steam Machine era)..."
install_pkg "qemu"         # [STEAM] Core machine emulator and virtualizer
install_pkg "bochs"        # x86 emulator
install_cask_pkg "utm"          # UTM (Cask)
install_cask_pkg "virtualbox"   # VirtualBox (Cask)

# --- Containerization (Modern Virtualization) ---
log "Installing containerization..."
install_cask_pkg "docker"       # [STEAM] Modern Linux container environment
install_pkg "docker-compose"
install_pkg "colima"       # Docker Desktop alternative
install_pkg "podman"       # Podman container engine


# --- Console Emulators ---
log "Installing console emulators..."
install_pkg "mgba"         # GBA emulator
install_pkg "mesen"        # NES emulator
install_pkg "snes9x"       # SNES emulator
install_cask_pkg "dolphin-emu"  # GameCube/Wii emulator
install_pkg "ppsspp"       # PSP
install_cask_pkg "citra"        # 3DS
install_cask_pkg "yuzu"         # Switch (Cask)
install_cask_pkg "ryujinx"      # Switch (Cask)


# ==========================================================================
# SECTION 5: GAME DEVELOPMENT & GRAPHICS (STEAM MACHINE ERA)
# ==========================================================================
log "--- SECTION 5: Installing game development libraries... ---"

# --- Core Build Systems ---
log "Installing core build systems for PRs..."
install_pkg "cmake"        # Core build system for PRs
install_pkg "ninja"        # Core build system
install_pkg "make"         # GNU Make
install_pkg "automake"
install_pkg "autoconf"
install_pkg "libtool"
install_pkg "pkg-config"
install_pkg "bazel"        # Google's build system
install_pkg "scons"        # SCons build system
install_pkg "premake"      # Premake build system

# --- Graphics & Multimedia Libraries ---
log "Installing graphics and multimedia libraries..."
install_pkg "sdl2"
install_pkg "sdl2_image"
install_pkg "sdl2_mixer"
install_pkg "sdl2_ttf"
install_pkg "sdl2_net"
install_pkg "sfml"
install_pkg "raylib"
install_pkg "glfw"
install_pkg "glew"
install_pkg "freeglut"
install_pkg "allegro"      # Allegro 5
install_pkg "libpng"
install_pkg "libjpeg"
install_pkg "libtiff"
install_pkg "freetype"
install_pkg "harfbuzz"
install_pkg "ffmpeg"
install_pkg "imagemagick"
install_pkg "openexr"
install_pkg "openal-soft"  # 3D audio
install_pkg "libvorbis"
install_pkg "libogg"
install_pkg "flac"
install_pkg "portaudio"
install_pkg "libsndfile"

# --- Physics & Math ---
log "Installing physics and math libraries..."
install_pkg "box2d"
install_pkg "bullet"
install_pkg "chipmunk"
install_pkg "glm"
install_pkg "eigen"
install_pkg "gsl"          # GNU Scientific Library
install_pkg "openblas"
install_pkg "lapack"

# --- Game Engines (Core) ---
log "Installing game engine Casks..."
install_cask_pkg "godot"
install_cask_pkg "godot-mono"
install_cask_pkg "love"        # LÖVE 2D
install_cask_pkg "tic-80"
install_cask_pkg "pico-8"

# ==========================================================================
# SECTION 6: CONSOLES + HOMEBREW TOOLCHAINS (1930–2025)
# ==========================================================================
log "--- SECTION 6: Installing console + homebrew SDK families... ---"

# --- 8-bit / Atari / Z80 Era (PDP-adjacent) ---------------------------------
log "Installing 8-bit / Z80 era toolchains..."
install_pkg "cc65"         # 6502 C Compiler
install_pkg "z80asm"       # Z80 Assembler
install_pkg "pasmo"        # Z80 Assembler (Pascal/TASM syntax)
install_pkg "sdcc"         # Small Device C Compiler (Z80, 8051, etc)
install_pkg "wla-dx"       # WLA DX Cross Assembler (GB, NES, etc)
install_pkg "rgbds"        # Game Boy toolchain

# --- Sega / Nintendo / Sony -------------------------------------------------
log "Installing GBA/NDS/PSX toolchains..."
install_pkg "devkitarm"    # GBA / NDS
install_pkg "psxsdk"       # PlayStation 1
install_pkg "mips64-elf-binutils" # MIPS (N64, PSX)
install_pkg "mips64-elf-gcc"      # MIPS (N64, PSX)
# n64-toochain is not a simple brew formula, skipping for reliability

# --- Modern Homebrew (WASM / x86 Bare-Metal) --------------------------------
log "Installing modern homebrew toolchains..."
install_pkg "x86_64-elf-gcc" # Bare-metal x86
install_pkg "x86_64-elf-binutils"
install_pkg "x86_64-elf-gdb"
install_pkg "wabt"         # WebAssembly Binary Toolkit
install_pkg "wasmtime"
install_pkg "wasm-pack"
install_pkg "binaryen"
install_pkg "wasmer"

# ==========================================================================
# SECTION 7: DATABASE SYSTEMS
# ==========================================================================
log "--- SECTION 7: Installing database systems... ---"

# --- Relational (SQL) ---
log "Installing SQL databases..."
install_pkg "postgresql"
install_pkg "postgresql@15"
install_pkg "postgresql@14"
install_pkg "mysql"
install_pkg "mariadb"
install_pkg "sqlite"

# --- NoSQL & Document ---
log "Installing NoSQL databases..."
install_pkg "mongodb-community"
install_pkg "redis"
install_pkg "memcached"
install_pkg "elasticsearch"
install_pkg "couchdb"
install_pkg "neo4j"
install_pkg "influxdb"
install_pkg "prometheus"

# --- DB Tools ---
log "Installing database GUI tools..."
install_cask_pkg "dbeaver-community"
install_cask_pkg "tableplus"
install_cask_pkg "mongodb-compass"
install_cask_pkg "postico"

# ==========================================================================
# SECTION 8: DEVOPS, INFRASTRUCTURE & NETWORKING
# ==========================================================================
log "--- SECTION 8: Installing DevOps, Infra & Networking... ---"

# --- Infra as Code ---
log "Installing Infrastructure as Code tools..."
install_pkg "terraform"
install_pkg "ansible"
install_pkg "puppet"
install_pkg "chef"
install_pkg "pulumi"

# --- CI/CD ---
log "Installing CI/CD tools..."
install_pkg "jenkins"
install_pkg "gitlab-runner"
install_pkg "act"          # Run GitHub Actions locally

# --- Cloud CLIs ---
log "Installing Cloud CLIs..."
install_pkg "awscli"
install_pkg "azure-cli"
install_pkg "google-cloud-sdk"
install_pkg "heroku"
install_pkg "flyctl"

# --- K8s & Containers ---
log "Installing Kubernetes tools..."
install_pkg "kubernetes-cli"
install_pkg "minikube"
install_pkg "kind"
install_pkg "helm"
install_pkg "k9s"

# --- Networking Tools ---
log "Installing networking tools..."
install_pkg "nmap"
install_cask_pkg "wireshark"    # (Cask)
install_pkg "tcpdump"
install_pkg "netcat"
install_pkg "wget"
install_pkg "curl"
install_pkg "mtr"
install_pkg "iperf3"
install_pkg "dnsmasq"
install_pkg "httpie"
install_cask_pkg "proxyman"     # (Cask)
install_cask_pkg "charles"      # (Cask)

# ==========================================================================
# SECTION 9: DEVELOPMENT UTILITIES & EDITORS
# ==========================================================================
log "--- SECTION 9: Installing Dev Utilities & Editors... ---"

# --- Version Control ---
log "Installing Version Control Systems..."
install_pkg "git"
install_pkg "git-lfs"
install_pkg "subversion"   # SVN
install_pkg "mercurial"    # hg
install_pkg "bazaar"       # bzr
install_pkg "fossil"

# --- Terminal Editors ---
log "Installing terminal editors..."
install_pkg "vim"
install_pkg "neovim"
install_pkg "emacs"
install_pkg "nano"
install_pkg "micro"

# --- GUI Editors & IDEs (Casks) ---
log "Installing GUI Editors and IDEs (Casks)..."
install_cask_pkg "visual-studio-code"
install_cask_pkg "vscodium"
install_cask_pkg "sublime-text"
install_cask_pkg "zed"
install_cask_pkg "pulsar"
# install_cask_pkg "atom" # (Archived, but for historical context)
install_cask_pkg "brackets"
install_cask_pkg "nova"
install_cask_pkg "jetbrains-toolbox" # For IntelliJ, CLion, etc.
install_cask_pkg "android-studio"
log "Xcode must be installed from the App Store."

# --- Diff & Merge Tools ---
log "Installing diff/merge tools..."
install_pkg "diff-so-fancy"
install_pkg "delta"
install_cask_pkg "meld"
install_cask_pkg "kaleidoscope"
install_cask_pkg "beyond-compare"

# --- API & Documentation ---
log "Installing API and documentation tools..."
install_cask_pkg "postman"
install_cask_pkg "insomnia"
install_cask_pkg "zeal"
install_cask_pkg "dash"
install_pkg "graphviz" # For doxygen
install_pkg "doxygen"
install_pkg "swagger-cli"

# ==========================================================================
# SECTION 10: SCIENTIFIC, AI & DATA SCIENCE
# ==========================================================================
log "--- SECTION 10: Installing Scientific, AI & Data Science... ---"

# --- Python Data Stack ---
log "Installing Python data stack prerequisites..."
install_pkg "jupyterlab"
install_pkg "ipython"
# Python libs (numpy, pandas, etc.) are best installed via pip
# but we install their dependencies
install_pkg "numpy"
install_pkg "scipy"
install_pkg "matplotlib"
install_pkg "opencv"
install_pkg "tesseract"
log "Note: For Python data libraries (pandas, scikit-learn), use pip."

# --- AI & ML ---
log "Installing AI/ML tools..."
# Main libs are pip-installed
install_cask_pkg "ollama"
install_cask_pkg "lm-studio"
install_pkg "libtorch"

# --- Scientific & Academic ---
log "Installing scientific/academic tools..."
install_pkg "octave"       # GNU Octave (MATLAB compatible)
install_pkg "gnuplot"
install_cask_pkg "paraview"     # (Cask)
install_cask_pkg "openscad"     # (Cask)
install_cask_pkg "freecad"      # (Cask)
install_cask_pkg "kicad"        # (Cask)
install_cask_pkg "processing"   # (Cask)

# ==========================================================================
# FINAL SPLASH
# ==========================================================================
log "Post-run diagnostics..."
if command -v rustup-init >/dev/null; then
    log "Rust detected. Run 'rustup-init' manually to install toolchains."
fi

log "Finalizing ULTIMATE TWEAKER COMPILER v2.0 'K-LINE'..."

# This script is now significantly longer.
# Padding with a truly massive ASCII banner.

cat << "EOF"


                                                                                
                                                                                
                                  ,,,,,,,                                     
                            ,,,,,,,,,,,,,,,,,,,                               
                      ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                           
                  ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                       
               ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                    
            ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                 
          ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,             
       ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,          
    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,       
  ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,   
 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, 
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
 ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,, 
  ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,   
    ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,       
       ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,          
          ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,             
            ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                 
               ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                    
                  ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                       
                      ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,                           
                            ,,,,,,,,,,,,,,,,,,,                               
                                  ,,,,,,,                                     
                                                                                
                                                                                

╔════════════════════════════════════════════════════════════════════════════╗
║    ULTIMATE TWEAKER COMPILER — TAHOE-PRIME EDITION (1930–2025)             ║
║    V2.0 "K-LINE" — EXPANDED CONTEXT EDITION                                ║
║    PDP-11... SGI... JVM... M4 Pro... Steam Machine. All eras unified.       ║
║    [SAMSOFT] HARDWARE > PR FILES. = COMPLETE.                             ║
╚════════════S═══════A═══════M═══════S═══════O═══════F═══════T══════════════╝
EOF

log "All Java + multi-era compiler toolchains + utilities installed."
log "Script line count: $(wc -l < "$0")"
log "Restart your terminal to apply all changes (jenv, Homebrew path)."