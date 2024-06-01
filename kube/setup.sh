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


cat <<EOF > kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- backend-live.yaml
- backend-test.yaml
EOF

kustomize edit set image hashicorp/http-echo:live=hashicorp/http-echo:sha-live
kustomize edit set image hashicorp/http-echo:test=hashicorp/http-echo:sha-test

imagePullPolicy: Always
terminationGracePeriodSeconds: 30
kubectl rollout restart deployment/my-deployment
kubectl set image deployment/my-deployment my_container=my_image
kubectl apply -f - --record

echo "foo" > /srv/volumes/cdn/foo
curl -k --resolve cdn.vafer.org:443:127.0.0.1  https://cdn.vafer.org/foo
curl -k --resolve live.vafer.org:443:127.0.0.1 https://live.vafer.org
curl -k --resolve test.vafer.org:443:127.0.0.1 https://test.vafer.org

kubectl delete -f .



REPO_URL="https://github.com/yourusername/infra.git"
TARGET_DIR="/home/ops/infra"

if [ ! -d "$TARGET_DIR" ]; then
  git clone "$REPO_URL" "$TARGET_DIR"
else
  cd "$TARGET_DIR" || exit
  git reset --hard HEAD
  git clean -fd
  git pull
fi

CHANGES=$(oci-resolve)
echo $CHANGES
bash <(echo $CHANGES)

kubectl kustomize kube/ | kubectl apply -f -