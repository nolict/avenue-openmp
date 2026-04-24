#!/bin/bash

# Mencari lokasi folder tempat script ini berada secara otomatis
# Ini akan menggantikan path hardcoded /home/abib/...
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Masuk ke folder compiler agar library (.so) terbaca secara dinamis
# Kita menggunakan path relatif terhadap lokasi script ini
export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$SCRIPT_DIR"

# Jalankan compiler dengan box86 (untuk environment ARM/chroot kamu)
# "$@" akan meneruskan semua argumen (include, flags, dll) dari VS Code
box86 "$SCRIPT_DIR/pawncc" "$@"
