kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/aio/deploy/recommended.yaml
kubectl apply -f dashboard-admin.yml
# get the token
bash get_token.sh
kubectl proxy