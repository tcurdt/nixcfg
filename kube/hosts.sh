#!/usr/bin/env bash
set -e

lookup() {
  service_name=$1
  coredns_ip=$2

  result=$(dig +short @$coredns_ip $service_name)

  if [ -n "$result" ]; then
    echo "$result"
  else
    echo "failed to find ip for $service_name"
    exit 1
  fi
}


filename="/etc/hosts"
filename_tmp="/etc/hosts.tmp"

coredns_ip="10.43.0.10"

caddy=$(lookup "caddy.default.svc.cluster.local" $coredns_ip)
postgres=$(lookup "postgres.default.svc.cluster.local" $coredns_ip)
valkey=$(lookup "valkey.default.svc.cluster.local" $coredns_ip)
backend_live=$(lookup "backend.live.svc.cluster.local" $coredns_ip)
backend_test=$(lookup "backend.test.svc.cluster.local" $coredns_ip)

content=$(cat <<EOF
# marker

$caddy caddy.default.svc.cluster.local
$postgres postgres.default.svc.cluster.local
$valkey valkey.default.svc.cluster.local
$backend_live backend.live.svc.cluster.local
$backend_test backend.test.svc.cluster.local

EOF
)

marker_found=false
while IFS= read -r line; do
  if [[ $line == "# marker" ]]; then
    marker_found=true
    echo "$content"
  else
    echo "$line"
  fi
done < "$filename" > "$filename_tmp"

if ! $marker_found; then
  echo "" >> "$filename_tmp"
  echo "$content" >> "$filename_tmp"
fi

# mv "$filename_tmp" "$filename"
