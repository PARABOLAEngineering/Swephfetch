#!/bin/bash

set -e  # Exit on any error

echo "🐍 Setting up Swiss Ephemeris and Rust bindings..."

# Create project structure
mkdir -p swisseph_sys/src
mkdir -p include
mkdir -p libs

# Clone Swiss Ephemeris if not already present
if [ ! -d "swisseph" ]; then
    echo "Cloning Swiss Ephemeris..."
    git clone https://github.com/aloistr/swisseph.git
fi

# Build Swiss Ephemeris
cd swisseph
make clean
make libswe.a  # This is the correct target
cd ..

# Copy necessary files
echo "Copying library and header files..."
cp swisseph/swephexp.h include/
cp swisseph/sweph.h include/
cp swisseph/sweodef.h include/
cp swisseph/libswe.a libs/

# Create wrapper.h
cat > swisseph_sys/wrapper.h << 'EOL'
#include "../include/swephexp.h"
#include "../include/sweph.h"
EOL

# Create build.rs
cat > swisseph_sys/build.rs << 'EOL'
use std::env;
use std::path::PathBuf;

fn main() {
    println!("cargo:rustc-link-search=native=../libs");
    println!("cargo:rustc-link-lib=static=swe");
    println!("cargo:rerun-if-changed=wrapper.h");

    let bindings = bindgen::Builder::default()
        .header("wrapper.h")
        .clang_arg("-I../include")
        .parse_callbacks(Box::new(bindgen::CargoCallbacks))
        .generate()
        .expect("Unable to generate bindings");

    let out_path = PathBuf::from(env::var("OUT_DIR").unwrap());
    bindings
        .write_to_file(out_path.join("bindings.rs"))
        .expect("Couldn't write bindings!");
}
EOL

# Create lib.rs
cat > swisseph_sys/src/lib.rs << 'EOL'
#![allow(non_upper_case_globals)]
#![allow(non_camel_case_types)]
#![allow(non_snake_case)]

include!(concat!(env!("OUT_DIR"), "/bindings.rs"));
EOL

# Create Cargo.toml for swisseph_sys
cat > swisseph_sys/Cargo.toml << 'EOL'
[package]
name = "swisseph_sys"
version = "0.1.0"
edition = "2021"

[lib]
name = "swisseph_sys"
path = "src/lib.rs"

[build-dependencies]
bindgen = "0.69.1"
EOL

# Create root Cargo.toml if it doesn't exist
if [ ! -f "Cargo.toml" ]; then
    cat > Cargo.toml << 'EOL'
[package]
name = "swebindings"
version = "0.1.0"
edition = "2021"

[dependencies]
swisseph_sys = { path = "./swisseph_sys" }
EOL
fi

echo "✨ Setup complete! Testing build..."

# Make sure all files are copied
echo "Verifying files..."
ls -l include/
ls -l libs/

# Test compilation
cargo clean
cargo build

if [ $? -eq 0 ]; then
    echo "🎉 Success! Swiss Ephemeris bindings are ready to use."
else
    echo "❌ Build failed. Please check the error messages above."
    exit 1
fi
