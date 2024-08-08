# Specify the AWS provider
provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Create a security group to allow necessary traffic
resource "aws_security_group" "example" {
  name        = "example-security-group"
  description = "Allow inbound SSH and other necessary traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Optionally, you can open additional ports if needed
  # e.g., allow HTTP
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-04a81a99f5ec58529" # Ubuntu 25.04 LTS AMI, change as needed
  instance_type = "t2.micro"              # Change instance type if needed
  key_name      = "ubuntu-devEnv-key"     # Change to your key pair name

  # Security group attachment
  security_groups = [aws_security_group.example.name]

  # User data to install Docker, Docker Compose, and other tools
  user_data = <<-EOF
              #!/bin/bash
              # Add Docker's official GPG key
              sudo apt-get update -y
              sudo apt-get install -y ca-certificates curl
              sudo install -m 0755 -d /etc/apt/keyrings
              sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
              sudo chmod a+r /etc/apt/keyrings/docker.asc

              # Add the repository to Apt sources
              echo \
                "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
                $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
                sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
              sudo apt-get update -y

              # Install Docker and Docker Compose
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

              # Add ubuntu user to docker group
              sudo usermod -aG docker ubuntu
              
              # Install unzip and development tools
              sudo apt-get install -y unzip cmake g++ build-essential \
              libboost-all-dev libssl-dev libcurl4-openssl-dev git gdb valgrind gcovr lcov
              EOF

  tags = {
    Name = "01-base-machine"
  }
}

# Output instance details
output "instance_id" {
  value = aws_instance.example.id
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

