#!/bin/sh

G="${0%/*}"; [ "$G" = "$0" ] && G=.; G="$G/gae"

. "$G" && gae_configure "$G.conf" && run_python "$GAE_PYV" "$@" || exit $?
