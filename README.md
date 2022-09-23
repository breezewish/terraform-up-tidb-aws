# terraform-up-tidb-aws

A sample to create VMs for deploying TiDB in AWS using [Terraform](https://www.terraform.io) with these default topology:

| Usage                                       | Size   | Count | Private IP                  |
| ------------------------------------------- | ------ | ----- | --------------------------- |
| TiKV                                        | 8c 64g | 3     | 172.31.6.1, 172.31.6.2, ... |
| TiDB                                        | 8c 16g | 2     | 172.31.7.1, 172.31.7.2, ... |
| PD + Grafana + Monitoring                   | 8c 16g | 1     | 172.31.8.1                  |
| TiFlash                                     | 8c 64g | 0     | 172.31.9.1, 172.31.9.2, ... |
| Center VM, you can run benchmarks and so on | 8c 16g | 1     | 172.31.1.1                  |

The topology and instance size can be customized via [`locals_common.tf`](./locals_common.tf) and [`locals_advanced.tf`](./locals_advanced.tf).

## Prerequisite

- [Terraform](https://www.terraform.io) must be installed.

- `~/.ssh/id_rsa.pub` must present, can be used as the public key to access VMs.

## Getting Started

### 1. Clone and create project

```shell
git clone https://github.com/breeswish/terraform-up-tidb-aws
cd terraform-up-tidb-aws

# Generate a master key for intra cluter access (no password)
ssh-keygen -t rsa -b 4096 -f ./master_key -q -N ""

# Load terraform modules
terraform init
```

### 2. Optional: Configure

Customize the number of TiDB and TiKV VMs in [`locals_common.tf`](./locals_common.tf).

**Example:**

```terraform
locals {
  name      = "foo-benchmark"
  n_tidb    = 1  # default 2
  n_tikv    = 3  # default 3
  n_tiflash = 0  # default 0
}
```

### 3. Create and start VMs

```shell
terraform apply -auto-approve
```

Terraform will output like this, which contains information you need to connect to VMs:

```plain
private-ip-pd = [
  "172.31.8.1",
]
private-ip-tidb = [
  "172.31.7.1",
  "172.31.7.2",
]
private-ip-tiflash = []
private-ip-tikv = [
  "172.31.6.1",
  "172.31.6.2",
  "172.31.6.3",
]
ssh-center = "ssh ubuntu@<center_vm_ip>"
tidb-dashboard = "http://<pd_vm_ip>:2379/dashboard"
```

### 4. Connect to Center VM and deploy cluster

You can now connect to the center VM and deploy a TiDB cluster in these VMs:

```shell
ssh ubuntu@<center_vm_ip>
# or
# ssh -i ./master_key ubuntu@<center_vm_ip>

# The topology.yaml is already created for you
tiup cluster deploy tidb-test nightly ./topology.yaml --user ubuntu -i ~/.ssh/id_rsa --yes
tiup cluster start tidb-test
```

### 5. Connect to TiDB

A HAProxy is deployed in the Center VM, load balancing multiple TiDB instances:

```shell
ssh ubuntu@<center_vm_ip>
mysql -u root --host 127.0.0.1 --port 4000
```

### 6. Finally, destroy VMs

When everything is done, you can destroy all of your VMs and resources with one line:

```shell
terraform destroy -auto-approve
```

## Features

| Status | Feature                                    |
| ------ | ------------------------------------------ |
| ✅     | Ubuntu 20.04 (x86_64)                      |
| ✅     | Intra-host public key authentication       |
| ✅     | HAProxy for multiple TiDB instances        |
| ✅     | Expose PD and Grafana for public access    |
| ✅     | Customize instance count and size          |
| ✅     | Enable core dump                           |
| ✅     | With zsh                                   |
| ✅     | TiDB recommended kernal parameters         |
| ✅     | Support TiFlash                            |
| ✅     | Instance size is identical with TiDB Cloud |
| ✅     | EC2 IAM Profile to access S3 without AK, SK |
