# Paso 3: Configurar Volúmenes Persistentes

# 3.1 Crear los volúmenes lógicos
sudo lvcreate -n lv_db -L 10G vg_proyecto_final
sudo lvcreate -n lv_web -L 10G vg_proyecto_final
sudo lvs  # Verificación

# 3.2 Formatear y montar los volúmenes
sudo mkfs.ext4 /dev/vg_proyecto_final/lv_db
sudo mkfs.ext4 /dev/vg_proyecto_final/lv_web
sudo mkdir /mnt/db
sudo mkdir /mnt/web
sudo mount /dev/vg_proyecto_final/lv_db /mnt/db
sudo mount /dev/vg_proyecto_final/lv_web /mnt/web
df -h  # Verificación

# 3.3 Añadir al fstab para persistencia
echo '/dev/vg_proyecto_final/lv_db /mnt/db ext4 defaults 0 0' | sudo tee -a /etc/fstab
echo '/dev/vg_proyecto_final/lv_web /mnt/web ext4 defaults 0 0' | sudo tee -a /etc/fstab
cat /etc/fstab  # Verificación

vi pv-pvc.yaml

# 3.4 Crear los PersistentVolume y PersistentVolumeClaim en Kubernetes
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-mysql
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/db"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-web
spec:
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/web"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: web-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
EOF

# Verificacion
kubectl apply -f pv-pvc.yaml
kubectl get pv  # debería mostrar pv-mysql y pv-web
kubectl get pvc  # debería mostrar mysql-pvc y web-pvc