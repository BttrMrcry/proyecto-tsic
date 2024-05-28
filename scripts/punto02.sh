# Paso 2: Desplegar la Aplicación Web en Kubernetes

vi deployment.yaml

# 2.1 Crear el archivo de despliegue de Kubernetes para la aplicación web (deployment.yaml)
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
---
apiVersion: v1
kind: Service
metadata:
  name: django-service
spec:
  selector:
    app: django-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8000
  type: NodePort

# Verificacion
kubectl apply -f deployment.yaml
kubectl get pods  # debería mostrar los pods de la aplicación Django en estado 'Running'
kubectl get svc  # debería mostrar el servicio django-service



vi db-deployment.yaml

# 2.2 Crear un archivo de despliegue para la base de datos (db-deployment.yaml)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - name: db
        image: mysql:5.7
        env:
        - name: MYSQL_DATABASE
          value: "dbname"
        - name: MYSQL_USER
          value: "dbuser"
        - name: MYSQL_PASSWORD
          value: "dbpassword"
        - name: MYSQL_ROOT_PASSWORD
          value: "rootpassword"
        ports:
        - containerPort: 3306
        volumeMounts:
        - mountPath: /var/lib/mysql
          name: mysql-persistent-storage
      volumes:
      - name: mysql-persistent-storage
        persistentVolumeClaim:
          claimName: mysql-pvc
---
apiVersion: v1
kind: Service
metadata:
  name: db-service
spec:
  selector:
    app: db
  ports:
    - protocol: TCP
      port: 3306
      targetPort: 3306
  type: ClusterIP


# Verificacion
kubectl apply -f db-deployment.yaml
kubectl get pods  # debería mostrar los pods de la base de datos en estado 'Running'
kubectl get svc  # debería mostrar el servicio db-service