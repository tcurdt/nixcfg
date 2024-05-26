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

    echo=$(lookup "echo.default.svc.cluster.local" $coredns_ip)

    echo "" | tee $hosts_new

    echo "$echo echo.service" | tee -a $hosts_new

}

create_hosts_file
