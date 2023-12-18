https://www.youtube.com/watch?v=G5f6GC7SnhU

echo "secrets/age.key" >> .gitignore
mkdir -p secrets && cd secrets

rm -f age.key
age-keygen -o age.key
SOPS_AGE_KEY_FILE=$(pwd)/age.key
cat age.key | grep public | awk '{print $4}' > age.pubs


echo "foo: bar" > utm.yaml

export SOPS_AGE_RECIPIENTS=$(cat age.pubs)

sops --encrypt -i utm.yaml
sops --decrypt utm.yaml
sops utm.yaml

