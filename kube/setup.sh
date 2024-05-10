export GITHUB_USER=tcurdt
export GITHUB_TOKEN=...

kubectl create secret docker-registry github \
--docker-server=https://ghcr.io \
--docker-username=$GITHUB_USER \
--docker-password=$GITHUB_TOKEN \
--docker-email=tcurdt@vafer.org

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

kubectl create secret generic postgres-superuser \
--from-literal=password=secret

mkdir -p /srv/volumes/grafana && chown 65534:65534 /srv/volumes/grafana

kubectl apply \
 -f postgres-volume.yaml \
 -f postgres-deployment.yaml \
 -f postgres-service.yaml

kubectl apply \
 -f mysql-volume.yaml \
 -f mysql-deployment.yaml \
 -f mysql-service.yaml

kubectl apply \
 -f valkey-deployment.yaml \
 -f valkey-service.yaml

kubectl apply \
 -f grafana-volume.yaml \
 -f grafana-deployment.yaml \
 -f grafana-service.yaml

kubectl apply \
 -f telegraf-config.yaml \
 -f telegraf-daemonset.yaml


# kubectl exec -it pod/postgres-5f8c6bcbc8-n7s9v -- psql -U postgres
# kubectl exec -it pod/mysql-5f8c6bcbc8-n7s9v -- mysql -u root -p

# kubectl exec -it postgres-665b7554dc-cddgq -- pg_dump -U postgres -d database > db_backup.sql

# kubectl cp db_backup.sql postgres-665b7554dc-cddgq:/tmp/db_backup.sql
# kubectl exec -it postgres-665b7554dc-cddgq -- /bin/bash
# psql -U ps_user -d ps_db -f /tmp/db_backup.sql

# kubectl create secret generic postgres-superuser \
# --from-file=username=./username.txt \
# --from-file=password=./password.txt
