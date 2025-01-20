README: Ephemeris Binding Generator Script

Overview

This script automates the process of fetching, compiling, and setting up the correct filesystem for the Swiss Ephemeris C library directly within your Rust project. It turns one of the most tedious parts of the workflow into a joke—background noise you no longer need to think about—while providing a streamlined and transparent solution for integrating high-precision ephemeris data. Designed with performance and control in mind, it provides a streamlined and transparent solution for integrating high-precision ephemeris data into your Rust projects.

Why Use This Script?

1. Unmatched Performance

Unlike many bloated and limited ephemeris crates, this script ensures you work directly with the native Swiss Ephemeris library. By avoiding unnecessary overhead and intermediary layers, you unlock the maximum speed and efficiency for your computations.

2. Ultimate Control

All headers and bindings are generated as plaintext files, stored directly in your application folder. This transparency empowers you to:

Inspect and understand the underlying implementation.

Modify and optimize the bindings for your specific needs.

Avoid the frustration of poorly documented or opaque library behavior.

3. Lightweight and Customizable

Instead of relying on precompiled binaries or pre-generated bindings, this script compiles everything from source, ensuring compatibility with your environment and giving you the flexibility to adapt the setup to your unique requirements.

Features

Fully automated setup: Fetches the Swiss Ephemeris source files, compiles the library, and generates Rust bindings.

Customizable filesystem structure: You could extend the script to create any other files and folders you want, automatically.


How to Use

Clone this repository: $ git clone https://github.com/PARABOLAengineering/swephfetch

Run the script:

./generate_bindings.sh

This will:

Download and compile the Swiss Ephemeris library.

Set up the appropriate filesystem.

Generate Rust bindings using bindgen.

Include the appropriate bindings in your Rust project to start working with the Swiss Ephemeris.
