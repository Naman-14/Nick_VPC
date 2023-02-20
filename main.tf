# Creating a VPC
resource "aws_vpc" "nick-vpc"{
    cidr_block = var.vpc_cidr_block
    tags={
        Name="${var.env_prefix}-vpc"
    }
}

# Creating first subnet
resource "aws_subnet" "nick-subnet-1"{
    vpc_id = aws_vpc.nick-vpc.id
    cidr_block = var.subnet1_cidr_block
    availability_zone = var.avail_zone
    tags={
        Name="${var.env_prefix}-subnet-1"
    }
}

# Creating second subnet
resource "aws_subnet" "nick-subnet-2"{
    vpc_id = aws_vpc.nick-vpc.id
    cidr_block = var.subnet2_cidr_block
    availability_zone = var.avail_zone
    tags={
        Name="${var.env_prefix}-subnet-2"
    }
}

# Creating internet gateway
resource "aws_internet_gateway" "nick-igw"{
    vpc_id = aws_vpc.nick-vpc.id
    tags = {
        Name="${var.env_prefix}-igw"
    }
}

# Creating route table
resource "aws_route_table" "nick-route-table"{
    vpc_id = aws_vpc.nick-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.nick-igw.id
    }
    tags = {
        Name="${var.env_prefix}-rtb"
    }
}

# Creating subnet association with first subnet
resource "aws_route_table_association" "a-rtb-subnet-1"{
    subnet_id = aws_subnet.nick-subnet-1.id
    route_table_id = aws_route_table.nick-route-table.id
}

# Creating subnet association with second subnet
resource "aws_route_table_association" "a-rtb-subnet-2"{
    subnet_id = aws_subnet.nick-subnet-2.id
    route_table_id = aws_route_table.nick-route-table.id
}

# Creating two EC-2 instance in first subnet
resource "aws_instance" "nick-ec2-1" {
  ami = "ami-0f8ca728008ff5af4"
  instance_type = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.nick-sg.id}"]
  subnet_id = "${aws_subnet.nick-subnet-1.id}"

  
  count = 2
  associate_public_ip_address = true
  tags = {
    Name = "${var.env_prefix}-ec2-1"
    Owner = "naman.moolri@cloudeq.com"
    Purpose = "training"
  }

  volume_tags = {
    Name = "${var.env_prefix}-ec2-1"
    Owner = "naman.moolri@cloudeq.com"
    Purpose = "training"
  }
}

# Creating two EC-2 instance in second subnet
resource "aws_instance" "nick-ec2-2" {
  ami = "ami-0f8ca728008ff5af4"
  instance_type = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.nick-sg.id}"]
  subnet_id = "${aws_subnet.nick-subnet-2.id}"

  
  count = 2
  associate_public_ip_address = true
  tags = {
    Name = "${var.env_prefix}-ec2-2"
    Owner = "naman.moolri@cloudeq.com"
    Purpose = "training"
  }

  volume_tags = {
    Name = "${var.env_prefix}-ec2-2"
    Owner = "naman.moolri@cloudeq.com"
    Purpose = "training"
  }
}

