#!/bin/bash
set -e

# Generate Self signed certs if not already present for https
# Note you won't be able to use https untill you trust the certs on your os. 
[ ! -f "priv/cert/selfsigned.pem" ] && mix phx.gen.cert

exec "$@"
