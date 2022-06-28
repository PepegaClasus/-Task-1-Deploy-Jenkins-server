resource "aws_vpc" "vpc_terraform" {
    cidr_block = var.vpc_cidr_block

    tags = {
      Name = "Main VPC"
    }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc_terraform.id
}

resource "aws_subnet" "Public_Subnet" {
  vpc_id     = aws_vpc.vpc_terraform.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.subnet_availability_zone

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "Private_Subnet" {
  vpc_id     = aws_vpc.vpc_terraform.id
  cidr_block = "10.0.2.0/24"
  availability_zone = var.subnet_availability_zone
    tags = {
    Name = "Private Subnet"
  }  
}

resource "aws_nat_gateway" "Private_NAT" {
  connectivity_type = "public"
  subnet_id = aws_subnet.Public_Subnet.id
  allocation_id = aws_eip.nat_eip.id
  tags = {
    name = "MyMAT"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
  depends_on = [aws_internet_gateway.ig]
}



resource "aws_route_table" "Public_Route_Table" {
  vpc_id = aws_vpc.vpc_terraform.id
  tags = {
    Name = "Public_Route_Table"
  }  
}

resource "aws_route_table" "Private_Route_Table" {
  vpc_id = aws_vpc.vpc_terraform.id
  tags = {
    Name = "Private_Route_Table"
  }    
}

resource "aws_route" "Public_IG" {
  route_table_id = aws_route_table.Public_Route_Table.id  
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ig.id
}

resource "aws_route" "Private_NAT" {
  route_table_id = aws_route_table.Private_Route_Table.id  
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.Private_NAT.id
}

resource "aws_route_table_association" "Public_Subnet_Association" {
  subnet_id = aws_subnet.Public_Subnet.id  
  route_table_id = aws_route_table.Public_Route_Table.id
}

resource "aws_route_table_association" "Private_Subnet_Association" {
  subnet_id = aws_subnet.Private_Subnet.id  
  route_table_id = aws_route_table.Private_Route_Table.id
}





resource "aws_security_group" "Docker_Agent_SG" {
  name        = "Docker_Agent_SG"
  vpc_id      = aws_vpc.vpc_terraform.id
  ingress {
    from_port        = 4243 #DockerAgentPort
    to_port          = 4243
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    "name" = "Docker_Agent_SG"
  }

}

resource "aws_security_group" "Jenkins_SG" {
  name        = "Jenkins_SG"
  vpc_id      = aws_vpc.vpc_terraform.id
  ingress {
    from_port        = 4243 
    to_port          = 4243
    protocol         = "tcp"
    cidr_blocks      = ["13.41.81.11/32"] #JenkinsIp
  }
  ingress {
    from_port        = 8080 
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["37.214.60.95/32"] #MyIP
  }  


  egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    "name" = "Jenkins_SG"
  }

}
