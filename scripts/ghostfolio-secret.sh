#!/usr/bin/env bash
# Generates random credentials for Ghostfolio and writes them straight into a
# SOPS-encrypted Secret. Plaintext never touches the disk.
# Run from the repo root. Needs: kubectl, sops, openssl.
set -euo pipefail

OUT="apps/staging/ghostfolio/ghostfolio-env-secret.yaml"
AGE_RECIPIENT="age1e8k7asxtckf8nmxnf8lvlp4dzcgsnaamdj6q9pl9e2w3mhhz69ts3pyhuz" # from clusters/staging/.sops.yaml

if [[ -e "$OUT" ]]; then
  echo "$OUT already exists. Refusing to overwrite: new passwords would lock Ghostfolio out of its existing database." >&2
  exit 1
fi

# Hex only, so the passwords are safe inside the DATABASE_URL without escaping
rand() { openssl rand -hex 32; }

PG_DB="ghostfolio"
PG_USER="ghostfolio"
PG_PASS="$(rand)"

kubectl create secret generic ghostfolio-env --dry-run=client -o yaml \
  --from-literal=POSTGRES_DB="$PG_DB" \
  --from-literal=POSTGRES_USER="$PG_USER" \
  --from-literal=POSTGRES_PASSWORD="$PG_PASS" \
  --from-literal=DATABASE_URL="postgresql://${PG_USER}:${PG_PASS}@postgres:5432/${PG_DB}?connect_timeout=300" \
  --from-literal=REDIS_PASSWORD="$(rand)" \
  --from-literal=ACCESS_TOKEN_SALT="$(rand)" \
  --from-literal=JWT_SECRET_KEY="$(rand)" \
| sops --encrypt \
    --age "$AGE_RECIPIENT" \
    --encrypted-regex '^(data|stringData)$' \
    --input-type yaml --output-type yaml \
    /dev/stdin > "$OUT"

echo "Wrote encrypted $OUT"
