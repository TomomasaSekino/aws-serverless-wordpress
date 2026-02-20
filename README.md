# Serverless-ish WordPress on AWS (Fargate + Aurora Serverless v2 + CloudFront + WAF) with Terraform

## Overview
コンテナ化したWordPressをECS Fargateで稼働させ、DBはAurora Serverless v2、配信はCloudFront + WAFで保護する構成。
Terraformでdev環境を再現可能にする。

## Architecture
```mermaid
flowchart LR
  U[User] --> CF[CloudFront]
  CF --> WAF[WAFv2]
  WAF --> ALB[Application Load Balancer]
  ALB --> ECS[ECS Fargate Service]
  ECS --> AUR[Aurora Serverless v2]

## Verification
- Open `http://<alb_dns_name>/`
- Expected: nginx welcome page is displayed (ECS Fargate behind ALB)

