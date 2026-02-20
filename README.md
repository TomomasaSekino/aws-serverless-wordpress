# Serverless-ish WordPress on AWS (ECS Fargate + Aurora Serverless v2) with Terraform

Terraformで **ECS Fargate + ALB + Aurora Serverless v2** を構築し、WordPressを動作させるサンプルです。  
「オンプレ運用経験を土台に、AWSで再現性のある環境をIaCで構築できる」ことを示す目的で作成しています。

---

## Architecture

```mermaid
flowchart LR
  U[User] --> ALB[Application Load Balancer\nPublic]
  ALB --> ECS[ECS Fargate Service\nWordPress Container]
  ECS --> AUR[Aurora Serverless v2 (MySQL)\nPrivate Subnets]

  subgraph VPC
    ALB
    ECS
    AUR
  end
  ```

  Key Points (What this repo demonstrates)

IaC (Terraform) による再現性ある環境構築（terraform applyでdev環境作成）

コンテナ実行基盤はFargate（EC2運用を排除）

DBはAurora Serverless v2（需要変動に追従しやすいスケーリングモデル）

ALB配下にECS（一般的なWeb構成のベースを押さえる）

DBは private subnet に配置し、Security Groupで ECSタスクからのみ接続許可

Repository Structure

aws-serverless-wordpress/
  envs/dev/                # dev environment root
  modules/
    vpc/                   # VPC, subnets, routing (minimal)
    alb/                   # ALB + target group + listener
    ecs_fargate/           # ECS cluster/service/task definition
    aurora_serverless_v2/  # Aurora cluster (Serverless v2)
    ecr/                   # ECR repository (optional, for future)


Prerequisites

Terraform >= 1.6

AWS credentials configured (e.g. aws configure)

Region: ap-northeast-1 (Tokyo)

Deploy (dev)

⚠️ terraform.tfvars や tfstate はGitHubにコミットしないでください（.gitignore 済み）。

cd envs/dev
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvars の db_master_password を変更

terraform init
terraform plan
terraform apply

Verification

Terraform outputs の alb_dns_name を開きます：

http://<alb_dns_name>/

WordPressの言語選択画面が表示されればOK（ALB → ECS(Fargate) → Aurora の疎通が成立）


Notes / Security

現時点は「最短で動かすdev構成」です。ポートフォリオとして段階的に拡張予定：

ECSを private subnet + NAT に移行（より本番寄り）

DBパスワードを Secrets Manager に移行（tfvars直書き脱却）

入口を CloudFront + WAF に追加（防御・TLS・キャッシュ）

ログ（ALBアクセスログ / CloudWatch Logs / VPC Flow Logs）追加



Clean up (to avoid cost)
cd envs/dev
terraform destroy

Author

Tomomasa Sekino (GitHub: TomomasaSekino)

