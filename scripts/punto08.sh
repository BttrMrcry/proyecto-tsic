vi deployment.yaml

# Paso 8: Desplegar Deployment con 3 Réplicas en deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: django-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: django-app
  template:
    metadata:
      labels:
        app: django-app
    spec:
      containers:
      - name: django
        image: bttrmrcry/proyecto-tsic:latest
        ports:
        - containerPort: 8000
        env:
        - name: DATABASE_HOST
          value: "db-service"
        - name: DATABASE_USER
          value: "dbuser"
        - name: DATABASE_PASSWORD
          value: "dbpassword"
        - name: DATABASE_NAME
          value: "dbname"

# Verificacion
kubectl apply -f deployment.yaml
kubectl get deployment django-app  # debería mostrar 3 réplicas disponibles

# Comandos finales para desplegar todos los recursos de Kubernetes
kubectl apply -f pv-pvc.yaml
kubectl apply -f db-deployment.yaml
kubectl apply -f deployment.yaml
kubectl apply -f grafana-deployment.yaml
kubectl get all  # debería mostrar todos los recursos (pods, servicios, despliegues, etc.) en estado 'Running' o 'Available'

# Verificar que todos los nodos estén en estado 'Ready'
kubectl get nodes

# Verificar que los pods de la aplicación y la base de datos estén corriendo
kubectl get pods

# Verificar los servicios de Kubernetes
kubectl get svc