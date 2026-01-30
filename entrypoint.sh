#!/bin/sh
set -e

# Seed persistent data volume if it's empty/missing required files.
if [ ! -f /app/data/extraDrops.json ]; then
  echo "[bootstrap] seeding /app/data from image defaults"
  mkdir -p /app/data
  if [ -d /app/data.default ]; then
    cp -a /app/data.default/. /app/data/
  fi
fi

exec python3 _httpserver_test.py
