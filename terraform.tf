# Define provider (AWS in this case)
provider "aws" {
  region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create subnet within VPC
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Create internet gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

# Attach internet gateway to VPC
resource "aws_vpc_attachment" "my_attachment" {
  vpc_id             = aws_vpc.my_vpc.id
  internet_gateway_id = aws_internet_gateway.my_igw.id
}

# Create security group
resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "Allow SSH inbound traffic"

  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  key_name      = "my-keypair"
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "my-instance"
  }
}



resource "null_resource" "save_ip" {
  provisioner "local-exec" {
    command = "echo '[server3]' >> /home/vagrant/terraform2/host-inventory && echo '${aws_instance.web-3.public_ip}' >> /home/vagrant/terraform2/host-inventory"
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
