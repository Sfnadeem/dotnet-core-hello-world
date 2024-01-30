variable "region" {
  type    = string
  default = "us-east-2"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source.
source "amazon-ebs" "windows-packer" {
  ami_name      = "packer-windows-demo-${local.timestamp}"
  communicator  = "winrm"
  instance_type = "t2.micro"
  region        = "${var.region}"
#   source_ami_filter {
#     filters = {
#       name                = "Windows_Server-2019-English-Full-Base*"
#       root-device-type    = "ebs"
#       virtualization-type = "hvm"
#     }
#     most_recent = true
#     owners      = ["amazon"]
#   }
  source_ami = "ami-0c51b48047ff6f325"
  user_data_file = "./bootstrap_win.txt"
  winrm_password = "SuperS3cr3t!!!!"
  winrm_username = "Administrator"
  iam_instance_profile = "pws-packer-test-role"
}

# a build block invokes sources and runs provisioning steps on them.
build {
  name    = "windows-packer"
  sources = ["source.amazon-ebs.windows-packer"]

  provisioner "powershell" {
    environment_vars = ["DEVOPS_LIFE_IMPROVER=PACKER"]
    inline           = ["Write-Host \"HELLO NEW USER; WELCOME TO $Env:DEVOPS_LIFE_IMPROVER\"", "Write-Host \"You need to use backtick escapes when using\"", "Write-Host \"characters such as DOLLAR`$ directly in a command\"", "Write-Host \"or in your own scripts.\""]
  }
  provisioner "windows-restart" {}
  provisioner "powershell" {
    inline = [
      # Install Git
      "Write-Host 'Cloning .NET application from GitHub'",
      "git clone https://github.com/Sfnadeem/dotnet-core-hello-world.git C:\\DotnetApp",
      "Write-Host 'Building and running .NET application'",
      # Build and run your .NET application
      "cd C:\\DotnetApp",
      "dotnet build",
      "dotnet run"
    ]
  }

}


// {
//     "builders": [
//       {
//         "type": "amazon-ebs",
//         "region": "us-east-2",
//         "source_ami": "ami-06fe4639440b3ab22",
//         "instance_type": "t2.micro",
//         "user_data_file": "./bootstrap_win.txt",
//         "ami_name": "my-windows-ami-{{timestamp}}",
//         "communicator": "winrm",
//         "winrm_username": "Administrator",
//         "winrm_password": "SuperS3cr3t!!!!",
//         "winrm_use_ssl": true,
//         "winrm_insecure": true,
//         "iam_instance_profile": "pws-packer-test-role"
//       }
//     ]
//   }

