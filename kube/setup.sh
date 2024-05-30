mkdir -p /srv/volumes/cdn && chown 65534:65534 /srv/volumes/cdn
mkdir -p /srv/volumes/loki && chown 10001:10001 /srv/volumes/loki
mkdir -p /srv/volumes/thanos && chown 65534:65534 /srv/volumes/thanos
mkdir -p /srv/volumes/grafana && chown 65534:65534 /srv/volumes/grafana
mkdir -p /srv/volumes/postgres && chown 65534:65534 /srv/volumes/postgres
mkdir -p /srv/volumes/prometheus && chown 65534:65534 /srv/volumes/prometheus

kubectl create secret generic postgres-superuser \
--from-literal=username=postgres \
--from-literal=password=secret \
-n infra

# kubectl create secret generic postgres-superuser \
# --from-file=username=./username.txt \
# --from-file=password=./password.txt
# -n infra

# export GITHUB_USER=tcurdt
# export GITHUB_TOKEN=...

# kubectl create secret docker-registry github \
# --docker-server=https://ghcr.io \
# --docker-username=$GITHUB_USER \
# --docker-password=$GITHUB_TOKEN \
# --docker-email=tcurdt@vafer.org
# -n live

# kubectl create secret docker-registry github \
# --docker-server=https://ghcr.io \
# --docker-username=$GITHUB_USER \
# --docker-password=$GITHUB_TOKEN \
# --docker-email=tcurdt@vafer.org
# -n test

kubectl apply \
 -f namespaces.yaml

kubectl apply \
 -f caddy.yaml

kubectl apply \
 -f postgres.yaml

kubectl apply \
 -f backend-test.yaml

kubectl apply \
 -f backend-live.yaml

# kubectl apply \
#  -f valkey.yaml

# kubectl apply \
#  -f monitoring

echo "foo" > /srv/volumes/cdn/foo
curl -k --resolve cdn.vafer.org:443:127.0.0.1  https://cdn.vafer.org/foo
curl -k --resolve live.vafer.org:443:127.0.0.1 https://live.vafer.org
curl -k --resolve test.vafer.org:443:127.0.0.1 https://test.vafer.org


# -----------


# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo update
# helm upgrade -i prometheus prometheus-community/prometheus

# kubectl apply \
#  -f postgres-backup.yaml


# kubectl apply -f https://raw.githubusercontent.com/stakater/Reloader/master/deployments/kubernetes/reloader.yaml
# kubectl rollout restart deployment/caddy


# kubectl get pods --all-namespaces -o wide | grep Evicted | awk '{print $1,$2}' | xargs -L1 kubectl delete pod -n
# kubectl get pods --all-namespaces -o wide | grep Error | awk '{print $1,$2}' | xargs -L1 kubectl delete pod -n
# kubectl get pods --all-namespaces -o wide | grep Completed | awk '{print $1,$2}' | xargs -L1 kubectl delete pod -n
# kubectl describe -A pvc | grep -E "^Name:.*$|^Namespace:.*$|^Used By:.*$" | grep -B 2 "<none>" | grep -E "^Name:.*$|^Namespace:.*$" | cut -f2 -d: | paste -d " " - - | xargs -n2 bash -c 'kubectl -n ${1} delete pvc ${0}'
# kubectl get pvc --all-namespaces | tail -n +2 | grep -v Bound | awk '{print $1,$2}' | xargs -L1 kubectl delete pvc -n
# kubectl get pv | tail -n +2 | grep -v Bound | awk '{print $1}' | xargs -L1 kubectl delete pv


# kubectl apply \
#  -f echo.yaml \
#  --namespace live

# kubectl apply \
#  -f echo.yaml \
#  --namespace test

kubectl create secret generic influxdb-creds \
  --from-literal=INFLUXDB_DB=monitoring \
  --from-literal=INFLUXDB_USER=user \
  --from-literal=INFLUXDB_USER_PASSWORD=secret \
  --from-literal=INFLUXDB_READ_USER=readonly \
  --from-literal=INFLUXDB_USER_PASSWORD=secret \
  --from-literal=INFLUXDB_ADMIN_USER=root \
  --from-literal=INFLUXDB_ADMIN_USER_PASSWORD=secret \
  --from-literal=INFLUXDB_HOST=influxdb  \
  --from-literal=INFLUXDB_HTTP_AUTH_ENABLED=true

kubectl create secret generic grafana-creds \
  --from-literal=GF_SECURITY_ADMIN_USER=admin \
  --from-literal=GF_SECURITY_ADMIN_PASSWORD=secret

kubectl create secret generic mysql-superuser \
--from-literal=password=secret

kubectl apply \
 -f mysql-volume.yaml \
 -f mysql-deployment.yaml


kubectl apply \
 -f grafana-volume.yaml \
 -f grafana-deployment.yaml

kubectl apply \
 -f telegraf-config.yaml \
 -f telegraf-daemonset.yaml

kubectl create namespace monitoring

helm repo add influxdata https://helm.influxdata.com/
helm install influxdata/influxdb2 --generate-name
helm install influxdata/telegraf --generate-name

helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana/grafana --generate-name

kubectl create secret generic influxdb-auth \
  --from-literal=admin-password=foo \
  --from-literal=admin-token=token

helm repo add bitnami https://charts.bitnami.com/bitnami
helm install bitnami/postgresql --generate-name \
  --set primary.persistence.existingClaim=pg-pvc \
  --set auth.postgresPassword=pgpass \
  --set volumePermissions.enabled=true
helm install my-release oci://registry-1.docker.io/bitnamicharts/postgresql


deploymentMode: SingleBinary
loki:
  commonConfig:
    replication_factor: 1
  storage:
    type: 'filesystem'
  schemaConfig:
    configs:
    - from: 2024-01-01
      store: tsdb
      index:
        prefix: loki_index_
        period: 24h
      object_store: filesystem # we're storing on filesystem so there's no real persistence here.
      schema: v13
singleBinary:
  replicas: 1
read:
  replicas: 0
backend:
  replicas: 0
write:
  replicas: 0

helm install --values values.yaml loki --namespace=loki grafana/loki

# kubectl exec -it pod/postgres-5f8c6bcbc8-n7s9v -- psql -U postgres
# kubectl exec -it pod/mysql-5f8c6bcbc8-n7s9v -- mysql -u root -p

# kubectl exec -it postgres-665b7554dc-cddgq -- pg_dump -U postgres -d database > db_backup.sql
# kubectl cp db_backup.sql postgres-665b7554dc-cddgq:/tmp/db_backup.sql
# kubectl exec -it postgres-665b7554dc-cddgq -- /bin/bash
# psql -U ps_user -d ps_db -f /tmp/db_backup.sql
