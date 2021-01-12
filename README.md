# A k8s demo cluster
1. install vagrant and some plugins (vagrant-cachier, vagrant-hostmanager)
2. install ansible, Helm (v3), kubectl 
3. pip install pyhelm; 
4. `vagrant up`
5. (optional) proxy kubernetes dashboard: `provisioners/deploy_dashboard.sh`

## to deploy Ingress

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx
```