# Securing Sensitive Workloads with Cilium in Kubernetes

## Overview
Securing sensitive workloads such as databases is a critical challenge. With Kubernetes becoming a dominant platform for managing microservices and applications, it is essential to enforce security at the network layer to protect critical resources from unauthorized access. 

This project focuses on securing a **user service** built in **Golang** with a **MySQL backend**, deployed in a Kubernetes cluster. The primary emphasis is on leveraging **Cilium** to enforce network policies that regulate traffic to the MySQL database, allowing only authorized services to communicate with it.

The project demonstrates how unauthorized pods attempting to access the database can be detected and blocked using Cilium’s policies. Additionally, **Hubble** and **Grafana** are used to monitor network traffic in real time, visualize policy enforcement, and showcase potential intrusion attempts, providing a comprehensive security framework.

---

## Scope of Work
The project will:
- Implement **Kubernetes Network Policies** using **Cilium** to secure a **user service** with a MySQL backend.
- Enforce strict access controls to the MySQL service.
- Detect unauthorized access attempts.
- Showcase how network policies protect sensitive database workloads.
- Use **Hubble** and **Grafana** to visualize intrusions and network activity.

---


## Methodology

### Kubernetes Cluster Setup
1. Set up a **K0s Kubernetes cluster** using **Terraform** for Infrastructure as Code (IaC) to provision necessary AWS resources.

### User Service and Database Setup
2. Develop the **user service** in Golang with **MySQL** as the backend.
3. Dockerize both the user service and the MySQL database for deployment in the Kubernetes environment.

### Deploy Cilium Network Policies
4. Deploy **Cilium** as the Container Network Interface (CNI) to manage network policies.
5. Create policies to:
   - Permit communication between the **user service** and **MySQL**.
   - Deny access to unauthorized pods.

### Simulating an Unauthorized Pod
6. Deploy an unauthorized pod attempting to access the MySQL database:
   - This pod contains a MySQL client that repeatedly attempts to connect to the MySQL database.
   - Cilium's policies detect and block connection attempts, logging them via **Hubble**.

**Details:**
- Unauthorized connection attempts are logged as dropped packets or connection timeouts.
- Legitimate user service communications with the database remain unaffected.

### Monitoring and Visualization
7. Implement **Hubble** to monitor network traffic and log access attempts (authorized and unauthorized).
8. Set up **Grafana** to:
   - Visualize network traffic and policy enforcement in real time.
   - Pull data from Hubble’s metrics for insights into:
     - Allowed and blocked traffic between pods.
     - Dropped packets.
     - Connection latency.
     - Error codes associated with unauthorized access attempts.

---

## Tools and Technologies
- **Programming Language:** Golang
- **Database:** MySQL
- **Containerization:** Docker
- **Orchestration:** Kubernetes (K0s)
- **Infrastructure as Code (IaC):** Terraform
- **CNI:** Cilium
- **Monitoring:** Hubble
- **Visualization:** Grafana

---

## Expected Outcomes
- **Secure Communication:** MySQL service accessible only to the authorized user service.
- **Intrusion Detection:** Unauthorized pods are detected and blocked in real time.
- **Real-Time Monitoring:** Network activity visu
