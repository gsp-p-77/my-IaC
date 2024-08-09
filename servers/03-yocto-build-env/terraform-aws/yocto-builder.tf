provider "aws" {
  region = "us-east-1"  # Specify your desired AWS region
}

resource "aws_instance" "yocto_builder" {
  ami           = "ami-0a0e5d9c7acc336f1"  # Ubuntu 22.04 LTS in us-east-1 (update for your region)
  instance_type = "g4ad.8xlarge"             # Compute-optimized instance (~1.73 €/h, 32 vCPUs, 128 GiB memory)

  # SSH key to connect to the instance
  key_name = "generic-key"

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

  user_data = <<-EOF
              #!/bin/bash
              set -e
              set -x
              exec > /var/log/user-data.log 2>&1

              # Create the provisioning script
              echo '#!/bin/bash' > /home/ubuntu/provision.sh
              echo 'set -e' >> /home/ubuntu/provision.sh
              echo 'set -x' >> /home/ubuntu/provision.sh
              echo '' >> /home/ubuntu/provision.sh
              echo 'sudo apt-get update -y' >> /home/ubuntu/provision.sh
              echo 'sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib' >> /home/ubuntu/provision.sh
              echo 'sudo apt-get install -y build-essential chrpath socat cpio python3 python3-pip' >> /home/ubuntu/provision.sh
              echo 'sudo apt-get install -y python3-pexpect xz-utils debianutils iputils-ping' >> /home/ubuntu/provision.sh
              echo 'sudo apt-get install -y python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev' >> /home/ubuntu/provision.sh
              echo 'sudo apt-get install -y pylint3 xterm' >> /home/ubuntu/provision.sh
              echo 'sudo apt install -y zip' >> /home/ubuntu/provision.sh
              echo '' >> /home/ubuntu/provision.sh
              echo 'echo "Yocto build environment setup complete!"' >> /home/ubuntu/provision.sh

              # Make the script executable
              chmod +x /home/ubuntu/provision.sh
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
