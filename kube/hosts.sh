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

create_hosts_file() {
    coredns_ip="10.43.0.10"
    hosts_new="/etc/hosts.new"

    caddy=$(lookup "caddy.default.svc.cluster.local" $coredns_ip)
    postgres=$(lookup "postgres.default.svc.cluster.local" $coredns_ip)
    valkey=$(lookup "valkey.default.svc.cluster.local" $coredns_ip)
    backend_live=$(lookup "echo.live.svc.cluster.local" $coredns_ip)
    backend_test=$(lookup "echo.test.svc.cluster.local" $coredns_ip)

    echo "" | tee $hosts_new

    echo "$caddy caddy.default.svc.cluster.local"       | tee -a $hosts_new
    echo "$postgres postgres.default.svc.cluster.local" | tee -a $hosts_new
    echo "$valkey valkey.default.svc.cluster.local"     | tee -a $hosts_new
    echo "$backend_live backend.live.svc.cluster.local" | tee -a $hosts_new
    echo "$backend_test backend.test.svc.cluster.local" | tee -a $hosts_new
}

create_hosts_file
