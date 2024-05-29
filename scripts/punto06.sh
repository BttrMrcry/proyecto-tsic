vi deployment.yaml

# 6.1 Añadir Sidecars para Elasticsearch en deployment.yaml
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
      - name: elasticsearch
        image: docker.elastic.co/elasticsearch/elasticsearch:7.9.2
        ports:
        - containerPort: 9200


# Verificacion
kubectl apply -f deployment.yaml
kubectl get pods  # debería mostrar los pods con los contenedores de Django y Elasticsearch en estado 'Running'