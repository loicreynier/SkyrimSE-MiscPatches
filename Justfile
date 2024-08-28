# `$MO2_OVERWRITE` and `$MO2_DOWNLOADS` are read from `.env`

set dotenv-load := true

data_dir := './data'
dist_dir := './dist'
name := `basename $(git rev-parse --show-toplevel)`
release := dist_dir / name + "-`git describe --always --dirt`.zip"

_list:
    @just --list --unsorted

make-readme:
    pandoc-bbcode_nexus description.md -o description.bbcode

release: make-readme
    @mkdir -p {{ dist_dir }}
    @cd {{ data_dir }} && zip -9 -r ../{{ release }} *

install-release: release
    @cp -v {{ release }} "$MO2_DOWNLOADS"
