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

  tags {
    Name = "allow_all"
  }
}


resource "aws_instance" "go_server" {
  ami           = "ami-f1d7c395"
  instance_type = "t2.micro"
  security_groups = ["allow_all"]
  key_name = "test"

  provisioner "file" {
    source      = "goserver/server"
    destination = "/tmp/server"
    connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key  = "${file("/Users/charliesmith/Downloads/test.pem")}"
   }
 }

  provisioner "remote-exec" {
    inline = [
        "chmod 755 /tmp/server",
        "/tmp/server"
    ]
    connection {
        type     = "ssh"
        user     = "ubuntu"
        private_key  = "${file("/Users/charliesmith/Downloads/test.pem")}"
   }
  }
}


