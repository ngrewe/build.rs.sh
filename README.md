# Build.rs.sh

This build script starts up a docker container to build static rust binaries
using the musl libc. It takes care of mounting volumes into the container so
that your binaries end up on the host filesystem.

## Usage

You just provide the script with the paths to your rust project and a directory 
where to store the produced artefacts (currently, that's the content of the entire
`target/` directory).

```sh
./build.rs.sh ./path/to/rust/project ./path/where/to/store/output 
```

Any parameters passed after these two paths will be processed by cargo inside the
container. If you want to override the container image with your own, you can 
set the `BUILD_RS_IMAGE` environment variable.

## Acknowledgements

* [Taking Rust everywhere with rustup](https://blog.rust-lang.org/2016/05/13/rustup.html)
* [muslrust](https://github.com/clux/muslrust)
