provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}

resource "aws_instance" "yocto_builder" {
  ami           = "ami-0a0e5d9c7acc336f1"  # Ubuntu 22.04 LTS in us-east-1 (update for your region)
  instance_type = "c6in.16xlarge"             # Compute-optimized instance (~3.6 €/h, 64 vCPUs, 128 GiB memory)

  # SSH key to connect to the instance
  key_name = "yocto-builder-key"

  # EBS volume (100 GiB SSD)
  root_block_device {
    volume_size = 100
    volume_type = "gp3"  # General Purpose SSD
  }

  # Automatically associate a public IP
  associate_public_ip_address = true

  # Security group configuration
  vpc_security_group_ids = [aws_security_group.yocto_sg.id]

  # Instance tags
  tags = {
    Name = "Yocto-Bitbake-Builder"
  }

  # Improved provisioning script using user_data
  user_data = <<-EOF
              #!/bin/bash
              set -e  # Exit immediately if a command exits with a non-zero status
              set -x  # Print commands and their arguments as they are executed

              # Redirect all output to a logfile for debugging purposes
              exec > /var/log/user-data.log 2>&1

              # Update package lists
              sudo apt-get update -y

              # Install necessary packages for Yocto/Bitbake
              sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
                                      build-essential chrpath socat cpio python3 python3-pip \
                                      python3-pexpect xz-utils debianutils iputils-ping \
                                      python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
                                      pylint3 xterm

              sudo locale-gen en_US.UTF-8
              
              # Install additional tools if needed
              sudo apt-get install -y ccache

              # Create a file to indicate that setup is complete
              echo "Yocto build environment setup complete!" > /home/ubuntu/setup-complete.txt
              EOF
}

resource "aws_security_group" "yocto_sg" {
  name = "yocto_sg"

  # Allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Open SSH (consider restricting to your IP)
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_ip" {
  description = "The public IP of the EC2 instance"
  value       = aws_instance.yocto_builder.public_ip
}
