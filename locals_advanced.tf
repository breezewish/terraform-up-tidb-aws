# Changes to these locals are easy to break something. Ensure you know what you are doing (see each comment).

locals {
  # image is region-local. If you changed region, please also change image.
  region = "us-west-2"
  image  = "ami-03f65b8614a860c29" # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-05-16

  # If you want to change instance type, ensure that GP3 EBS is available in the instance type.
  tidb_instance    = "c5.2xlarge"
  tikv_instance    = "r5.2xlarge"
  pd_instance      = "c5.2xlarge"
  tiflash_instance = "r5.2xlarge"
  center_instance  = "c5.2xlarge"

  master_ssh_key         = "./master_key"
  master_ssh_public      = "./master_key.pub"
  alternative_ssh_public = "~/.ssh/id_rsa.pub"
}
