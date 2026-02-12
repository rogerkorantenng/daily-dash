#!/bin/bash
# Quick run script - copies Steam Runtime libs and launches the compiled game
GAMEDIR=~/GameMakerStudio2/vm/DailyDash/AppDir/usr/bin
RTDIR=~/steam-runtime/lib/x86_64-linux-gnu

# Copy required libraries from Steam Runtime
cp "$RTDIR/libcrypto.so.1.0.0" "$GAMEDIR/" 2>/dev/null
cp "$RTDIR/libssl.so.1.0.0" "$GAMEDIR/" 2>/dev/null

# Launch
cd "$GAMEDIR"
LD_LIBRARY_PATH=. ./DailyDash
