#!/usr/bin/env bash
set -euo pipefail

version=3.15-4

which docker > /dev/null 2>&1 || { echo >&2 "Docker not found"; exit 1; }
which mvn > /dev/null 2>&1 || { echo >&2 "Maven not found"; exit 1; }

root_dir="$(dirname "$(readlink -f "${0}")")/.."
bin_dir="${root_dir}/bin"
build_dir="${root_dir}/build"
src_dir="${root_dir}/src"
tmp_dir="${root_dir}/tmp"

rm -rf "${build_dir}" && mkdir -p "${build_dir}"
rm -rf "${tmp_dir}" && mkdir -p "${tmp_dir}"

curl -Ls "https://github.com/tananaev/traccar/archive/v${version}.tar.gz" -o "${tmp_dir}/traccar.tar.gz"
tar -xzf "${tmp_dir}/traccar.tar.gz" -C "${tmp_dir}"
mv "${tmp_dir}/traccar-${version}" "${tmp_dir}/traccar"
mvn package -f "${tmp_dir}/traccar"

curl -Ls "https://github.com/tananaev/traccar-web/archive/v${version}.tar.gz" -o "${tmp_dir}/traccar-web.tar.gz"
tar -xzf "${tmp_dir}/traccar-web.tar.gz" -C "${tmp_dir}"
mv "${tmp_dir}/traccar-web-${version}" "${tmp_dir}/traccar-web"

cp -a "${src_dir}/." "${tmp_dir}"
"${tmp_dir}/traccar-web/tools/minify.sh"

cp -a "${tmp_dir}/traccar/schema" \
      "${tmp_dir}/traccar/setup/default.xml" \
      "${tmp_dir}/traccar/setup/traccar.xml" \
      "${tmp_dir}/traccar/target/lib" \
      "${tmp_dir}/traccar/target/tracker-server.jar" \
      "${tmp_dir}/traccar/templates" \
      "${tmp_dir}/traccar-web/web" \
      "${build_dir}"

docker build -t "agrocheck/traccar:${version}" "${root_dir}"
echo "Run ${bin_dir}/run.sh to execute Traccar locally"
