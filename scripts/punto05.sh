vi deployment.yaml

# 5.1 Añadir Sidecars de Prometheus en deployment.yaml
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
      - name: prometheus
        image: prom/prometheus
        ports:
        - containerPort: 9090

# Verificacion
kubectl apply -f deployment.yaml
kubectl get pods  # debería mostrar los pods con los contenedores de Django y Prometheus en estado 'Running'


vi grafana-deployment.yaml

# 5.2 Desplegar Grafana en grafana-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana
        ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: grafana-service
spec:
  selector:
    app: grafana
  ports:
    - protocol: TCP
      port: 80
      targetPort: 3000
  type: NodePort

# Verificacion
kubectl apply -f grafana-deployment.yaml
kubectl get pods  # debería mostrar el pod de Grafana en estado 'Running'
kubectl get svc  # debería mostrar el servicio grafana-service