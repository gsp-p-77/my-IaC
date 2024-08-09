provider "google" {
  project = "your-gcp-project-id"  # Replace with your GCP project ID
  region  = "us-central1"          # Replace with your preferred region
}

resource "google_compute_network" "vpc_network" {
  name = "yocto-vpc-network"
}

resource "google_compute_firewall" "default" {
  name    = "yocto-allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "yocto_builder" {
  name         = "yocto-builder-instance"
  machine_type = "n2-standard-64" # Example machine type with 64 vCPUs; adjust based on your needs
  zone         = "us-central1-a"  # Adjust based on your preferred zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2204-jammy-v20230802"  # Ubuntu 22.04 LTS image for GCP
      size  = 100                            # Disk size in GB
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {
      # Include this block to give the instance a public IP address
    }
  }

  metadata_startup_script = <<-EOF
              #!/bin/bash
              set -e
              set -x

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
              echo '' >> /home/ubuntu/provision.sh
              echo 'echo "Yocto build environment setup complete!"' >> /home/ubuntu/provision.sh

              # Make the script executable
              chmod +x /home/ubuntu/provision.sh
  EOF

  tags = ["http-server", "https-server"]
}

output "instance_ip" {
  description = "The public IP of the Google Cloud instance"
  value       = google_compute_instance.yocto_builder.network_interface[0].access_config[0].nat_ip
}
