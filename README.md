# Introduction
This repo contains all of the configuration and documentation of my homelab.

The purpose of my homelab is to learn and to have fun. Being a Devops Engineer by trade, I work with Kubernetes every day, and my homelab is the place where I can try out and learn new things. On the other hand, by self-hosting some applications, it makes me feel responsible for the entire process of deploying and maintaining an application from A to Z, it also gives me the ability to self-host applications that i use everyday. It forces me to think about backup strategies, security / secret management, scalability and the ease of deployment and maintenance.

# Cluster Provisioning & Architecture

I use k3s in my machine. I prefer k3s because it gives balance between ease of use and learning opportunities, k3s intallation is very easy ( one command ) and is relevant for Enterprise Kubernetes management since it powers Rancher.
It also allows me to use my Arch Linux Machine outside of homelabbing.

As i'm preparing for the Kubestronaut Certifications, i'll switch to Talos Linux to have a dedicated Control Plane for Kubernetes


# 💻 Hardware
## Nodes
---
For now i only use a Lenovo T460 as my control plane, i plan to buy refurbished HP ELITEDESK mini pc's, old laptops to have a multi-node setup. 

Lenovo T460 / i5/8GB/256GB SSD

# 🚀 Installed Apps & Tools
## Apps
---
 ### End User Applications 

| Logo | Name | Description |
| ---- | :----: | :----:        |
| ---- | Linkding | Bookmark Manager |
| ---- | AudioBookShelf | To store audiobooks and podcasts |

## Infrastructure
### Everything needed to run my cluster & deploy my applications

| Logo | Name | Description |
| ---- | :----: | :----:        |
| ---- | Flux CD | My GitOps solution of choice. Better than Argo. |
| ---- | Grafana | The open observability platform |
| ---- | Prometheus | An open-source monitoring system with a dimensional data model, flexible query language, efficient time series database and modern alerting approach. |
| ---- | Cloudflare Tunnels | Used for private tunnels to expose public services (without requiring a public IP), it's also my DNS registrar. |
| ---- | Renovate | Automated container updates via pull requests. |
