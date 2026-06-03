output "container_name" {
  description = "Nom du conteneur Docker créé"
  value       = docker_container.stacknova_recette.name
}

output "exposed_port" {
  description = "Port exposé sur la machine hôte"
  value       = 8080
}

output "application_url" {
  description = "URL de l'environnement de recette"
  value       = "http://localhost:8080"
}
