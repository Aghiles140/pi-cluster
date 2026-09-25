#!/usr/bin/env bash
# Asks for the Tailscale OAuth client credentials and writes them straight into
# a SOPS-encrypted Secret. Nothing is echoed, nothing lands on disk in clear.
# Run from the repo root. Needs: kubectl, sops.
set -euo pipefail

OUT="infrastructure/controllers/staging/tailscale-operator/operator-oauth-secret.yaml"
AGE_RECIPIENT="age1e8k7asxtckf8nmxnf8lvlp4dzcgsnaamdj6q9pl9e2w3mhhz69ts3pyhuz" # from clusters/staging/.sops.yaml

if [[ -e "$OUT" ]]; then
  echo "$OUT already exists. Delete it first if you are rotating the OAuth client." >&2
  exit 1
fi

read -r  -p "OAuth client ID: " CLIENT_ID
read -rs -p "OAuth client secret (hidden): " CLIENT_SECRET; echo
[[ -n "$CLIENT_ID" && "$CLIENT_SECRET" == tskey-client-* ]] || {
  echo "Unexpected input: the secret should start with tskey-client-" >&2; exit 1; }

# The chart looks for exactly this name and these keys
kubectl create secret generic operator-oauth --dry-run=client -o yaml \
  --from-literal=client_id="$CLIENT_ID" \
  --from-literal=client_secret="$CLIENT_SECRET" \
| sops --encrypt \
    --age "$AGE_RECIPIENT" \
    --encrypted-regex '^(data|stringData)$' \
    --input-type yaml --output-type yaml \
    /dev/stdin > "$OUT"

echo "Wrote encrypted $OUT"
