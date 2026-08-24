

## 1. Azure Landing Zone — Hub-and-Spoke Network

🔗 **Repo:** [azure-landing-zone-terraform](https://github.com/aniket-devop/azure-landing-zone-terraform)
`Terraform` `Azure Firewall` `Bastion` `Key Vault` `Private DNS` `GitHub Actions`

A hub-and-spoke enterprise network topology — the same pattern Microsoft recommends for real Azure landing zones — built entirely from reusable Terraform modules, with centralized security (Firewall + Bastion) and zero public exposure on workload VMs.

### Architecture Diagram

![Azure Landing Zone Architecture](https://raw.githubusercontent.com/aniket-devop/azure-landing-zone-terraform/main/diagrams/architecture.png)

<details>
<summary><b>📖 Architecture Flow — click to expand</b></summary>

1. Admin connects to **Azure Bastion** over HTTPS (443) — no VM ever has a public IP.
2. Bastion proxies RDP/SSH internally to VMs in the spoke VNets.
3. All inter-VNet traffic between hub and spokes flows through **VNet Peering**, routed and inspected by **Azure Firewall**.
4. Outbound internet access from spokes is forced through the firewall (no direct egress from workloads).
5. Application secrets/connection strings are pulled from **Key Vault** via a **Private Endpoint**, resolved through a **Private DNS Zone** — never over the public Key Vault endpoint.
6. Every subnet in the spokes sits behind a **deny-by-default NSG**; only explicitly required ports are opened.
7. Infrastructure changes go through GitHub Actions: `terraform plan` and `validate` run automatically on every PR, and `apply` requires manual approval — no direct `apply` from a laptop.

</details>

<details>
<summary><b>📁 Folder Structure</b></summary>

```
azure-landing-zone-terraform/
├── modules/
│   ├── networking/       # Hub + spoke VNets, subnets, peering
│   ├── firewall/         # Azure Firewall + rule collections
│   ├── bastion/          # Bastion host + NSG
│   ├── key-vault/        # Key Vault + private endpoint
│   └── storage/          # Remote state backend resources
├── environments/
│   ├── dev/
│   ├── qa/
│   └── staging/
├── .github/
│   └── workflows/
│       └── terraform.yml
├── main.tf
├── variables.tf
├── outputs.tf
└── README.md
```

</details>

### ⚙️ Features
- Fully modular Terraform — each network component is an independently testable, reusable module
- Environment isolation via separate `.tfvars` per environment (dev/QA/staging) on shared modules
- Reduced new-environment provisioning time from days to **under 15 minutes**

### 🔒 Security
- Deny-by-default NSGs on every spoke subnet
- Zero public IPs on workload VMs — access only via Bastion
- Key Vault reachable only through a private endpoint
- Centralized egress/ingress inspection through Azure Firewall

### 🔁 CI/CD
`PR opened` → **GitHub Actions** runs `terraform fmt` + `validate` + `plan` → plan output posted for review → **manual approval gate** → `terraform apply` on merge.

### 🖥️ Commands
```bash
terraform init -backend-config=environments/dev/backend.tfvars
terraform plan -var-file=environments/dev/dev.tfvars
terraform apply -var-file=environments/dev/dev.tfvars
```

### 📚 Learning
Designing for peered networks forced me to think in terms of blast radius and centralized control points rather than per-VM security — the firewall and Bastion become the two chokepoints everything must pass through.

### 🚀 Future Improvements
- Add Azure Policy for automated compliance enforcement across spokes
- Integrate Private DNS Resolver for hybrid on-prem resolution
- Add a 3rd spoke for a shared-services tier (DNS, patch management)

<br/>

---

<br/>

## 2. DevSecOps Pipeline for Microservices on AKS

🔗 **Repo:** [aks-devsecops-pipeline](https://github.com/aniket-devop/aks-devsecops-pipeline)
`AKS` `Docker` `Kubernetes` `Helm` `Trivy` `SonarQube` `Prometheus` `Grafana` `GitHub Actions`

A commit-to-cluster pipeline for a 4-service application where **security and quality gates block the deploy**, not just warn about it — paired with live pod-health observability post-deploy.

### Architecture Diagram

![AKS DevSecOps Pipeline Architecture](https://raw.githubusercontent.com/aniket-devop/aks-devsecops-pipeline/main/diagrams/architecture.png)

<details>
<summary><b>📖 Architecture Flow — click to expand</b></summary>

1. Developer merges a PR — GitHub Actions triggers the pipeline.
2. All 4 services are containerized and built in parallel Docker build stages.
3. Every image is scanned by **Trivy**; any critical CVE **fails the pipeline** before deploy.
4. Code quality runs through **SonarQube**; a failed quality gate also blocks the merge from deploying.
5. Only after both gates pass does **Helm** deploy the release to AKS.
6. **Ingress** routes external traffic to the correct service based on path/host rules.
7. **Prometheus** scrapes pod and node metrics continuously; **Grafana** visualizes health, latency, and resource usage in real time.

</details>

<details>
<summary><b>📁 Folder Structure</b></summary>

```
aks-devsecops-pipeline/
├── services/
│   ├── service-1/
│   ├── service-2/
│   ├── service-3/
│   └── service-4/
├── helm/
│   ├── Chart.yaml
│   ├── values-dev.yaml
│   ├── values-prod.yaml
│   └── templates/
│       ├── deployment.yaml
│       ├── service.yaml
│       └── ingress.yaml
├── monitoring/
│   ├── prometheus-values.yaml
│   └── grafana-dashboards/
├── .github/
│   └── workflows/
│       └── ci-cd.yml
└── README.md
```

</details>

### ⚙️ Features
- Parallel multi-service builds to keep pipeline time down
- Helm-driven pod scaling, service config, and ingress rules — no manual `kubectl apply`
- Full commit-to-deploy automation, merged PR to running pod on AKS in **under 10 minutes**

### 🔒 Security
- Trivy blocks any image with a critical/high CVE from being deployed
- SonarQube enforces a quality gate (coverage, code smells, duplication) before merge
- No manual production deploys — everything routed through the pipeline

### 🔁 CI/CD
`Merge to main` → Docker build → **Trivy + SonarQube gates (parallel)** → both must pass → Helm upgrade/install → AKS rollout → Prometheus starts scraping new pods.

### 📈 Monitoring
- Prometheus scrapes CPU/memory/pod-restart metrics from the cluster
- Grafana dashboards track per-service health and resource usage
- Alerting rules configured for pod crash-loop and high resource utilization

### 🖥️ Commands
```bash
docker build -t registry/service-1:$(git rev-parse --short HEAD) ./services/service-1
trivy image registry/service-1:latest --severity CRITICAL,HIGH --exit-code 1
helm upgrade --install my-app ./helm -f helm/values-prod.yaml --namespace production
kubectl get pods -n production -w
```

### 📚 Learning
Treating security scans as **hard gates** rather than advisory reports was the biggest shift — it forces you to fix vulnerabilities before they ever reach a cluster, not patch them after the fact.

### 🚀 Future Improvements
- Add canary/blue-green rollout strategy via Argo Rollouts
- Add distributed tracing (OpenTelemetry) across the 4 services
- Externalize secrets to Azure Key Vault via CSI driver instead of K8s secrets

<br/>

---

<br/>

## 3. AWS Landing Network (Personal Project)

🔗 **Repo:** [aws-terraform-landing-zone-project](https://github.com/aniket-devop/aws-terraform-landing-zone-project)
`Terraform` `VPC` `EC2` `ALB` `IAM` `S3` `DynamoDB`

A self-driven project to build AWS depth using the same "no direct internet exposure" principle as the Azure landing zone — multi-AZ, private compute, and locked-down remote state.

### Architecture Diagram

![AWS Landing Zone Architecture](https://raw.githubusercontent.com/aniket-devop/aws-terraform-landing-zone-project/main/diagrams/architecture.png)

> 📎 Full write-up and AWS Console deployment screenshots are in the [repo's README](https://github.com/aniket-devop/aws-terraform-landing-zone-project#readme).

<details>
<summary><b>📖 Architecture Flow — click to expand</b></summary>

1. All inbound traffic hits the **Internet Gateway**, then the **ALB** in the public subnets — nothing else is internet-facing.
2. The ALB forwards requests to EC2 instances in **private subnets across two AZs**, giving basic fault tolerance.
3. EC2 security groups accept traffic **only from the ALB's security group** — no direct internet access, no open ports.
4. Outbound-only internet access (package updates, external API calls) goes through the **NAT Gateway**.
5. Each EC2 instance assumes a **scoped IAM instance role** (least privilege) instead of a broad admin policy.
6. Terraform state is stored remotely in **S3**, with **DynamoDB** providing state locking to prevent concurrent-apply corruption.
7. Every PR runs `fmt`, `validate`, and `plan` via GitHub Actions before any human applies changes.

</details>

<details>
<summary><b>📁 Folder Structure</b></summary>

```
aws-terraform-landing-zone-project/
├── modules/                # VPC, ALB, EC2, IAM, etc. as reusable modules
├── environments/            # Environment-specific variable files
├── bootstrap/                # One-time setup for S3 + DynamoDB remote state
├── diagrams/
│   ├── architecture.png
│   └── README.md
├── images/                   # AWS Console screenshots (deployment proof)
│   ├── aws-subnets.png
│   ├── ec2-instance.png
│   ├── application-load-balancer.png
│   ├── alb-details.png
│   └── target-group-health.png
├── .github/
│   └── workflows/
├── backend.tf
├── main.tf
├── outputs.tf
├── providers.tf
├── variables.tf
├── versions.tf
└── README.md
```

</details>

### ⚙️ Features
- Multi-AZ design for basic high availability on the compute tier
- Fully private compute layer — EC2 instances have no public IPs
- Remote state with locking, safe for team/CI use without state corruption

### 🔒 Security
- Security groups scoped to ALB-only ingress on EC2
- IAM instance roles scoped to only the permissions the instance needs
- No inbound internet path to compute — only outbound, via NAT

### 🔁 CI/CD
`PR opened` → GitHub Actions runs `terraform fmt` → `validate` → `plan` → plan posted on PR for review → apply on approval/merge.

### 🖥️ Commands
```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -var-file=environments/dev/dev.tfvars
terraform apply -var-file=environments/dev/dev.tfvars
```

### 📚 Learning
Setting up S3 + DynamoDB remote state from scratch made the "why" behind state locking concrete — without it, two people (or two pipeline runs) applying at once can corrupt state.

### 🚀 Future Improvements
- Add Auto Scaling Group instead of fixed EC2 count
- Add AWS WAF in front of the ALB
- Migrate compute to ECS Fargate to remove instance management entirely

<br/>

---

<br/>

## 🎓 Education
**Bachelor of Computer Applications (BCA) — Chandigarh Group of Colleges, Mohali** · CGPA: 7.63/10

<br/>

## 📊 GitHub Stats

<div align="center">

<img src="https://streak-stats.demolab.com/?user=aniket-devop&hide_border=true&theme=dark&background=0D1117&ring=378ADD&fire=22C55E&currStreakLabel=378ADD" alt="GitHub Streak Stats"/>

</div>

<details>
<summary><b>📈 GitHub profile stats — click to expand</b></summary>
<br/>

<div align="center">

<img src="https://github-readme-stats.vercel.app/api?username=aniket-devop&show_icons=true&theme=default&hide_border=true&count_private=true" alt="GitHub Stats" height="165"/>
<img src="https://github-readme-stats.vercel.app/api/top-langs/?username=aniket-devop&layout=compact&hide_border=true&theme=default" alt="Top Languages" height="165"/>

</div>

</details>

<br/>

---

<div align="center">

### Let's build something reliable together

Open to full-time **Junior DevOps / Cloud Engineer** roles — always happy to connect with fellow engineers, hiring managers, and recruiters.

<br/>

<a href="https://linkedin.com/in/aniket484">
  <img src="https://raw.githubusercontent.com/aniket-devop/aniket-devop/main/icons/linkedin-pro.svg" width="48" height="48"/>
</a>
&nbsp;&nbsp;
<a href="https://github.com/aniket-devop">
  <img src="https://raw.githubusercontent.com/aniket-devop/aniket-devop/main/icons/github-pro.svg" width="48" height="48"/>
</a>
&nbsp;&nbsp;
<a href="mailto:aniketkmr484@gmail.com">
  <img src="https://raw.githubusercontent.com/aniket-devop/aniket-devop/main/icons/email-pro.svg" width="48" height="48"/>
</a>

<br/><br/>

**aniketkmr484@gmail.com** · **linkedin.com/in/aniket484** · **github.com/aniket-devop**

</div>
