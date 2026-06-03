Architecture du projet
stacknov
a-infra/
├── terraform/
│   ├── providers.tf
│   ├── main.tf
│   └── outputs.tf
│
├── ansible/
│   ├── inventory.ini
│   └── playbook.yml
│
├── scripts/
│   └── deploy.sh
│
├── screens/
│   ├── Terraform Output.png
│   ├── docker.png
│   ├── ansible_playbook.png
│   ├── stacknova_page.png
│   └── Ansible.png
│
├── .gitignore
└── README.md
Prérequis
Vérification des versions
docker --version
terraform --version
ansible --version
Versions utilisées
Docker version 28.4.0, build d8eb465

Terraform v1.15.5
on linux_amd64

Provider :
registry.terraform.io/kreuzwerker/docker v3.9.0

ansible [core 2.19.4]

python version = 3.13.5
jinja version = 3.1.6
pyyaml version = 6.0.2
Technologies utilisées
Technologie	Rôle
Docker	Conteneurisation
Terraform	Provisionnement de l'infrastructure
Ansible	Gestion de configuration
Bash	Automatisation
Git	Gestion de versions
GitHub	Hébergement du code
Provisionnement avec Terraform
Objectif

Terraform est utilisé pour créer automatiquement l'environnement de recette.

Le provisionnement comprend :

Téléchargement de l'image Docker Nginx
Création du conteneur Docker
Attribution de labels métier
Exposition du service web sur le port 8080
Génération des outputs Terraform
Ressources créées
Image Docker
nginx:1.25.3

L'utilisation d'une version explicitement définie garantit la reproductibilité du déploiement.

Conteneur Docker
stacknova-recette
Labels appliqués
env=recette
project=stacknova
Port exposé
8080/tcp
Déploiement
cd terraform

terraform init

terraform plan

terraform apply
Vérification
docker ps

Résultat :

stacknova-recette
terraform output

Résultat :

application_url = "http://localhost:8080"
container_name = "stacknova-recette"
exposed_port = 8080
curl http://localhost:8080

Résultat :

Welcome to nginx!
Configuration avec Ansible
Objectif

Ansible est utilisé pour personnaliser automatiquement le conteneur créé par Terraform.

L'objectif est de remplacer la page par défaut de Nginx par une page StackNova personnalisée.

Inventaire

Le conteneur est déclaré dans l'inventaire Ansible.

[recette]
stacknova-recette ansible_connection=docker
Vérification de la connectivité
ansible -i inventory.ini recette -m raw -a "echo pong"

Résultat :

pong
Actions réalisées

Le playbook effectue les opérations suivantes :

Vérification du fonctionnement de Nginx
Déploiement d'une page HTML personnalisée
Affichage du nom du projet
Affichage de l'environnement
Affichage de la date et heure du déploiement
Vérification du résultat final
Exécution
ansible-playbook -i inventory.ini playbook.yml
Vérification
curl http://localhost:8080

Résultat :

<h1>StackNova</h1>
<p>Environnement : recette</p>
<p>Date de déploiement : ...</p>
Automatisation
Script deploy.sh

L'ensemble du déploiement est automatisé grâce à un script Bash unique.

bash scripts/deploy.sh

Le script réalise automatiquement :

Initialisation Terraform
Déploiement Terraform
Vérification du démarrage du conteneur
Exécution du Playbook Ansible
Vérification finale

Cette approche permet d'automatiser complètement la création de l'environnement.

Reproductibilité

L'un des principaux objectifs de l'Infrastructure as Code est la reproductibilité.

Pour valider ce principe, un test complet a été réalisé.

Destruction
cd terraform

terraform destroy -auto-approve
Redéploiement
cd ..

bash scripts/deploy.sh
Résultat

Le résultat obtenu est identique :

même image Docker
même conteneur
même configuration
même page web
mêmes outputs Terraform

L'environnement peut être reconstruit intégralement à tout moment.
# stacknova-infra
