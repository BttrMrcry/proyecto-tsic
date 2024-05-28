# 7.1 Instalar Jenkins
sudo dnf install -y java-11-openjdk-devel wget
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo dnf install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Verificación de Jenkins
sudo systemctl status jenkins

# 7.2 Configurar Jenkins para CI/CD
# Abre Jenkins en el navegador (http://<tu-servidor>:8080) y completa la configuración inicial
echo "Por favor, abre Jenkins en tu navegador e completa la configuración inicial."

# Instalar los plugins necesarios para Kubernetes y Docker desde "Manage Jenkins" -> "Manage Plugins"

echo "Después de completar la configuración inicial, instala los plugins necesarios para Kubernetes y Docker desde 'Manage Jenkins' -> 'Manage Plugins'."

# Crear dos pipelines en la interfaz de Jenkins: Pipeline version 1 y Pipeline version 2
echo "Crea dos pipelines en la interfaz de Jenkins: Pipeline version 1 y Pipeline version 2."

# Verificación
echo "Verifica que los pipelines se crean correctamente y están listos para ser ejecutados."

bash setup_jenkins.sh