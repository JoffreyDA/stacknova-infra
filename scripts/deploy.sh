#!/bin/bash
set -e

echo "=== StackNova Infra : déploiement environnement recette ==="

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo ""
echo "=== Étape 1 : Terraform init ==="
cd "$PROJECT_ROOT/terraform"
terraform init

echo ""
echo "=== Étape 2 : Terraform apply ==="
terraform apply -auto-approve

echo ""
echo "=== Étape 3 : Attente du démarrage du conteneur ==="
sleep 3

echo ""
echo "=== Étape 4 : Configuration Ansible ==="
cd "$PROJECT_ROOT/ansible"
ansible-playbook -i inventory.ini playbook.yml

echo ""
echo "=== Déploiement terminé avec succès ==="
echo "URL : http://localhost:8080"
