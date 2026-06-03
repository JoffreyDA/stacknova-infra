# Architecture du projet

````html


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
│   ├── terraform_apply.png
│   ├── docker_ps.png
│   ├── ansible_playbook.png
│   ├── stacknova_page.png
│   └── deploy_script.png
│
├── .gitignore
└── README.md

````


Terraform Provisionnement de l'infrastructure

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
Technologie Rôle
Docker Conteneurisation
*Terraform* Provisionnement de l'infrastructure
Ansible Gestion de configuration
Bash Automatisation
Git Gestion de versions
GitHub Hébergement du code
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

application_url = "<http://localhost:8080>"
container_name = "stacknova-recette"
exposed_port = 8080
curl <http://localhost:8080>

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
curl <http://localhost:8080>

Résultat :

````html

<h1>StackNova</h1>
<p>Environnement : recette</p>
<p>Date de déploiement : ...</p>

````

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

Questions théoriques
Q1. Quelle est la différence entre Terraform et Ansible ? En quoi sont-ils complémentaires dans ce projet ?

Terraform est un outil de provisionnement permettant de créer et gérer l'infrastructure à partir d'une description déclarative. Dans ce projet, il crée l'image Docker et le conteneur Nginx.

Ansible est un outil de gestion de configuration permettant d'automatiser les modifications apportées à une machine ou à un conteneur existant. Dans ce projet, il personnalise le contenu du serveur web.

Ces deux outils sont complémentaires : Terraform crée l'infrastructure tandis qu'Ansible applique la configuration nécessaire au fonctionnement attendu.

Q2. À quoi sert le state file Terraform ? Quels risques pose sa mauvaise gestion en équipe ?

Le fichier terraform.tfstate contient l'état réel des ressources gérées par Terraform.

Il permet à Terraform de comparer l'infrastructure existante avec la configuration décrite dans les fichiers Terraform afin de déterminer les actions à réaliser.

Une mauvaise gestion du state peut entraîner des conflits entre collaborateurs, des suppressions accidentelles ou des incohérences d'infrastructure. En environnement professionnel, il est recommandé d'utiliser un backend distant sécurisé permettant le verrouillage du state.

Q3. Qu'est-ce que l'idempotence ? Donnez un exemple concret tiré de ce projet.

L'idempotence est la capacité d'un outil à produire le même résultat lorsqu'une opération est exécutée plusieurs fois.

Dans ce projet, l'exécution répétée de la commande terraform apply ne crée pas de nouveau conteneur si celui-ci existe déjà et correspond à la configuration définie.

Cette propriété garantit la stabilité et la reproductibilité des déploiements.

Q4. Quelle est la différence entre terraform apply et terraform apply -replace ? Dans quel cas utiliseriez-vous le second ?

La commande terraform apply applique uniquement les modifications nécessaires pour atteindre l'état désiré.

La commande terraform apply -replace force la destruction puis la recréation d'une ressource spécifique même si aucun changement n'est détecté dans la configuration.

Cette option est particulièrement utile lorsqu'une ressource est corrompue ou nécessite une reconstruction complète.

Q5. Pourquoi est-il déconseillé d'utiliser le tag latest en production ?

Le tag latest ne référence pas une version précise d'une image Docker.

Deux déploiements effectués à des dates différentes peuvent donc récupérer des versions différentes d'un même logiciel.

Cette pratique nuit à la reproductibilité, complique les opérations de maintenance et augmente le risque d'introduire des régressions ou des vulnérabilités. Il est préférable d'utiliser une version explicitement définie afin de garantir un comportement stable et prévisible.
