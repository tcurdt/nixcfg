export GITHUB_USER=tcurdt
export GITHUB_TOKEN=...

kubectl create secret docker-registry github \
--docker-server=https://ghcr.io \
--docker-username=$GITHUB_USER \
--docker-password=$GITHUB_TOKEN \
--docker-email=tcurdt@vafer.org

kubectl create secret generic mysql-superuser \
--from-literal=password=secret

kubectl create secret generic postgres-superuser \
--from-literal=password=secret

kubectl apply \
 -f postgres-volume.yaml \
 -f postgres-deployment.yaml \
 -f postgres-service.yaml

kubectl apply \
 -f mysql-volume.yaml \
 -f mysql-deployment.yaml \
 -f mysql-service.yaml

# kubectl exec -it pod/postgres-5f8c6bcbc8-n7s9v -- psql -U postgres
# kubectl exec -it pod/mysql-5f8c6bcbc8-n7s9v -- mysql -U root

# kubectl exec -it postgres-665b7554dc-cddgq -- pg_dump -U ps_user -d ps_db > db_backup.sql
# kubectl cp db_backup.sql postgres-665b7554dc-cddgq:/tmp/db_backup.sql
# kubectl exec -it postgres-665b7554dc-cddgq -- /bin/bash
# psql -U ps_user -d ps_db -f /tmp/db_backup.sql
# kubectl create secret generic postgres-superuser \
# --from-file=username=./username.txt \
# --from-file=password=./password.txt
