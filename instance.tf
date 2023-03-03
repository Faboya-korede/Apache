resource "aws_key_pair" "mykeypair"{
  key_name   = "mykeypair"
  public_key = file("/home/vagrant/.ssh/id_rsa.pub")

}

resource "aws_instance" "web"{
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  key_name       = "mykeypair"
  associate_public_ip_address = true
  subnet_id      = aws_subnet.public-1-subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
tags = {
    Name = "web-1"
  }
connection {
  type        = "ssh"
  user        = "ubuntu"
  private_key = file("/home/vagrant/.ssh/id_rsa")
  host        = self.public_ip
}

}

# create aws instance
resource "aws_instance" "web-2"{
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  key_name       = "mykeypair"
  associate_public_ip_address = true
  subnet_id      = aws_subnet.public-1-subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
tags = {
    Name = "web-2"
  }

connection {
  type        = "ssh"
  user        = "ubuntu"
  private_key = file("/home/vagrant/.ssh/id_rsa")
  host        = self.public_ip
}
}

resource "aws_instance" "web-3"{
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.micro"
  key_name      = "mykeypair"
  associate_public_ip_address = true
  subnet_id      = aws_subnet.public-1-subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
tags = {
    Name = "web-3"
  }
connection {
  type        = "ssh"
  user        = "ubuntu"
  private_key = file("/home/vagrant/.ssh/id_rsa")
  host        = self.public_ip
}
}


resource "null_resource" "save_ip" {
  provisioner "local-exec" {
    command = "echo '[server3]' >> /home/vagrant/terraform2/host-inventory && echo '${aws_instance.web-3.public_ip}' >> /home/vagrant/terraform2/host-inventory"
  }

  provisioner "local-exec" {
    command = "echo '[server2]' >> /home/vagrant/terraform2/host-inventory && echo '${aws_instance.web-2.public_ip}' >> /home/vagrant/terraform2/host-inventory"
  }

  provisioner "local-exec" {
    command = "echo '[server1]' >> /home/vagrant/terraform2/host-inventory && echo '${aws_instance.web.public_ip}' >> /home/vagrant/terraform2/host-inventory"
  }


}


resource "null_resource" "ansible" {
provisioner "local-exec" {
  command = "ANSIBLE_HOST_KEY_CHECKING=False  ansible-playbook -i /home/vagrant/terraform2/host-inventory  /home/vagrant/terraform2/project.yml"
 }
depends_on = [
  aws_instance.web
  ,aws_instance.web-2
  ,aws_instance.web-3
]
}
