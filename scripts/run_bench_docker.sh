#!/usr/bin/env bash

###
### Convenience script that runs the ipc_frontier benchmarks inside ipc-frontend-py's Docker runtime image.
###   - Ensures the latest runtime image is built from the current repo (multi-stage build)
###   - Constructs argument vector to pass to the `ipc-frontier` entrypoint from arguments to this script
###   - Runs a container for the runtime stage with the default entrypoint
###
###  The script attempts to mitigate sources of variance in runtime and other aspects of performance (e.g., pinning CPU
###  cores). Nevertheless, when feasible, it's advisable to compare these containerized benchmark results to results
###  measured on the same host without Docker. See the section "Running the Benchmarks - Run Locally" in the README for
###  instructions for running the benchmarks outside Docker.
###
### Usage:
###   scripts/run_bench_docker.sh -- [ipc-frontier args...]
###
### Env overrides:
###   IMAGE_TAG   : tag for the runtime image (default: ipc-frontier:runtime)
###   BUILD_FLAGS : extra flags for `docker build` (e.g., "--no-cache")
###   RUN_CPUS_OPT    : e.g., "--cpus=4" or "--cpuset-cpus=0-3" (default: empty)
###   RUN_NET_OPT     : e.g., "--network=host" (default: --network=host)
###   RUN_IPC_OPT     : e.g., "--shm-size=1g" or "--ipc=host" (default: --shm-size=1g)
###
### Examples:
###   $ ./scripts/run_bench_docker.sh -- --help
###
###   # RUN_CPUS_OPT="--cpuset-cpus=0-3" ./scripts/run_bench_docker.sh -- \
###       --backend proc-shm --sizes 65536 1048576 --items-per-size 2000 200 --repeats 3
###

set -euo pipefail

### Configurations
# Override any options below by setting the corresponding variable in the environment
IMAGE_TAG="${IMAGE_TAG:-ipc-frontier:runtime}"

BUILD_FLAGS="${BUILD_FLAGS:-}"

RUN_CPUS_OPT="${RUN_CPUS_OPT:---cpuset-cpus=0-3}"  # TODO
RUN_NET_OPT="${RUN_NET_OPT:---network=host}"
RUN_IPC_OPT="${RUN_IPC_OPT:---shm-size=1g}"  # TODO (--ipc=host)

### Helper functions
abort() {
    printf "ERROR: %s\n" "$*" >&2
    exit 1
}

need() {
    command -v "$1" >/dev/null 2>&1 || abort "Required command not found: $1"
}

### Preflight checks
need docker

if [[ ! -f "Dockerfile" ]]; then
    abort "Dockerfile not found in current working directory \"$(pwd)\". Run this script from the repository root."
fi

### Build to ensure up-to-date runtime image
# shellcheck disable=SC2086  # intentional word-splitting for flags
docker build ${BUILD_FLAGS} -t "${IMAGE_TAG}" --target runtime .

### Construct argument vector
# Forward all args to the container entrypoint; default to --help if none.
if (( $# == 0 )); then
  ARGS=( --help )
else
  ARGS=( "$@" )
fi

### Run runtime image
WORKDIR="$(pwd)"
set -x
# shellcheck disable=SC2086  # intentional word-splitting for flags
docker run --rm -it \
    ${RUN_CPUS_OPT} \
    ${RUN_NET_OPT} \
    ${RUN_IPC_OPT} \
    -e OMP_NUM_THREADS=1 \
    -e MKL_NUM_THREADS=1 \
    -e OPENBLAS_NUM_THREADS=1 \
    -v "${WORKDIR}:/workspace" \
    -w /workspace \
    "${IMAGE_TAG}" \
    "${ARGS[@]}"
set +x
