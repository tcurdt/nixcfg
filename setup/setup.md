# setup machine

```
curl https://raw.githubusercontent.com/elitak/nixos-infect/master/nixos-infect | NIX_CHANNEL=nixos-23.11 bash -x
```

```
nix-shell -p gitMinimal
cd && git clone git@github.com:tcurdt/nixcfg.git && cd nixcfg
nixos-rebuild switch --flake .#hetzner
```

```
nixos-rebuild switch --option "tarball-ttl 0" --flake git+ssh://git@github.com/tcurdt/nixcfg.git#hetzner
```

# queries

```
total = from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "disk")
  |> filter(fn: (r) => r["_field"] == "total")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
  |> yield(name: "Total")

free = from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "disk")
  |> filter(fn: (r) => r["_field"] == "free")
  |> aggregateWindow(every: v.windowPeriod, fn: mean, createEmpty: false)
  |> yield(name: "Free")

union(tables:[total, free])
  |> difference()

total = from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "disk")
  |> filter(fn: (r) => r["_field"] == "total")
  |> yield(name: "Total")

free = from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r["_measurement"] == "disk")
  |> filter(fn: (r) => r["_field"] == "free")
  |> yield(name: "Free")

union(tables:[total, free])
  |> difference()

from(bucket: "telegraf")
  |> range(start: v.timeRangeStart, stop: v.timeRangeStop)
  |> filter(fn: (r) => r._measurement == "disk")
  |> filter(fn: (r) => r["_field"] == "total" or r["_field"] == "free")
  |> pivot(rowKey:["_time"], columnKey: ["_field"], valueColumn: "_value")
  |> map(
      fn: (r) => ({
          _time: r._time,
          _measurement: r._measurement,
          _field: "mem_used_percent",
          _value: float(v: r.total) / float(v: r.free) * 100.0
      }),
  )
```
