mkdir -p /srv/volumes/infra && chown 65534:101 /srv/volumes/infra
mkdir -p /srv/volumes/cdn && chown 65534:65534 /srv/volumes/cdn
mkdir -p /srv/volumes/loki && chown 10001:10001 /srv/volumes/loki
mkdir -p /srv/volumes/mysql && chown 65534:65534 /srv/volumes/mysql
mkdir -p /srv/volumes/thanos && chown 65534:65534 /srv/volumes/thanos
mkdir -p /srv/volumes/grafana && chown 65534:65534 /srv/volumes/grafana
mkdir -p /srv/volumes/postgres && chown 65534:65534 /srv/volumes/postgres
mkdir -p /srv/volumes/prometheus && chown 65534:65534 /srv/volumes/prometheus

kubectl apply -f namespaces.yaml

kubectl delete secret git-repo-infra -n infra
kubectl create secret generic git-repo-infra \
--from-literal=username= \
--from-literal=password= \
--from-literal=url=https://github.com/tcurdt/nixcfg.git \
-n infra

kubectl delete secret postgres-superuser -n infra
kubectl create secret generic postgres-superuser \
--from-literal=username=postgres \
--from-literal=password=secret \
--from-literal=url=postgres://postgres:secret@postgres:5432/postgres \
-n infra

kubectl delete secret mysql-superuser -n infra
kubectl create secret generic mysql-superuser \
--from-literal=username=root \
--from-literal=password=secret \
--from-literal=url=mysql://root:secret@mysql:3306/mysql \
-n infra

kubectl apply -f infra
