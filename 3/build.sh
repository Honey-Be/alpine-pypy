#!/usr/bin/env sh
set -ex

CC=clang
CXX=clang++
BASE_DIR="/usr/src/pypy"
PYTHON="$(which pypy || which python)"

PYPY_NAME="pypy3"
PYPY_RELEASE_VERSION="${PYPY_RELEASE_VERSION:-$PYPY_VERSION}"
PYPY_ARCH="linux64"

# Translation
cd "$BASE_DIR"/pypy/goal
"$PYTHON" ../../rpython/bin/rpython --opt=jit -cc=clang –translation-jit_profiler=oprofile
PYTHONPATH=../.. ./pypy-c ../tool/build_cffi_imports.py

# Packaging
cd "$BASE_DIR"/pypy/tool/release
"$PYTHON" package.py --archive-name "$PYPY_NAME-v$PYPY_RELEASE_VERSION-$PYPY_ARCH"
