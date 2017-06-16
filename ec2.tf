provider "aws" {
  region     = "eu-west-2"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_all"
  }
}


resource "aws_instance" "go_server" {
  ami           = "ami-f1d7c395"
  instance_type = "t2.micro"
  security_groups = ["allow_all"]
  key_name = "test_s"
  
  provisioner "remote-exec" {
    inline = [
        "sudo apt-get update",
        "sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common",
        "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
        "sudo apt-key fingerprint 0EBFCD88",
        "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
        "sudo apt-get update",
        "sudo apt-get -y install docker-ce",
        "sudo docker pull chazsmi1/goserver",
        "sudo docker run -d -p 80:8000 chazsmi1/goserver",
    ]
    connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key  = "${file("/Users/charlie.smith1/Downloads/test_s.pem")}"
   }
  }
}


