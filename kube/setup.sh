mkdir -p /srv/volumes/cdn && chown 65534:65534 /srv/volumes/cdn
mkdir -p /srv/volumes/loki && chown 10001:10001 /srv/volumes/loki
mkdir -p /srv/volumes/thanos && chown 65534:65534 /srv/volumes/thanos
mkdir -p /srv/volumes/grafana && chown 65534:65534 /srv/volumes/grafana
mkdir -p /srv/volumes/postgres && chown 65534:65534 /srv/volumes/postgres
mkdir -p /srv/volumes/prometheus && chown 65534:65534 /srv/volumes/prometheus

kubectl apply \
 -f namespaces.yaml

kubectl delete secret postgres-superuser -n infra
kubectl create secret generic postgres-superuser \
--from-literal=username=postgres \
--from-literal=password=secret \
--from-literal=url=postgres://postgres:secret@postgres:5432/postgres \
-n infra

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
 -f infra

kubectl apply \
 -f backend-test.yaml

kubectl apply \
 -f backend-live.yaml

echo "foo" > /srv/volumes/cdn/foo
curl -k --resolve cdn.vafer.org:443:127.0.0.1  https://cdn.vafer.org/foo
curl -k --resolve live.vafer.org:443:127.0.0.1 https://live.vafer.org
curl -k --resolve test.vafer.org:443:127.0.0.1 https://test.vafer.org

kubectl delete -f .
