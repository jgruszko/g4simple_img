#!/bin/bash -e

(
    cd "$MGDODIR"
    test -f Makefile \
        || ./configure --prefix="$MGDODIR/install" --enable-majorana-all
    make && make install && echo "MJDO installation successfull." >&2
)

(
    cd "$SIGGENDIR"
    make && echo "mjd_siggen build successfull." >&2
)

(
    cd "$GATDIR"
    make && echo "GAT build successfull." >&2
)

(
    cd "$MJORDIR"
    make && echo "MJOR build successfull." >&2
)
