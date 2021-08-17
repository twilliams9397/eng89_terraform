# contains all networking instructions - Ig, route table, SG and nacls

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id 
  # takes id from created vpc above and links gateway to vpc

  tags = {
    Name = var.igw_name
  }
}

resource "aws_route_table" "terraform_rt" {
    # links route table to vpc
    vpc_id = aws_vpc.terraform_vpc.id
    
    route {
        # associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        gateway_id = aws_internet_gateway.terraform_igw.id
    }
    
    tags = {
        Name = var.rt_name
    }
}

# PUBLIC FOR APP SERVER

resource "aws_route_table_association" "terraform_rt_assoc" {
    # links the route table to the subnet
    subnet_id = aws_subnet.terraform_public_sub.id
    route_table_id = aws_route_table.terraform_rt.id
}

resource "aws_security_group" "app_sg" {
    # creates sg for vpc
    vpc_id = aws_vpc.terraform_vpc.id
    name = var.app_sg_name

# outbound rules
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1 # allow all
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }

# inbound rules
    # SSH rules
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
    }
    # If you do not add this rule, you can not reach the NGIX  
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
    # needed for reverse proxy
    ingress {
        from_port   = 3000
        to_port     = 3000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}


resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.terraform_vpc.id
  # links subnet to acl
  #subnet_ids = [aws_subnet.terraform_public_sub.id]

  egress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }
  egress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
    }
  egress {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }
  
  ingress {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    }
  ingress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
    }
  ingress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = var.my_ip
      from_port  = 22
      to_port    = 22
    }
  ingress {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }
  
  tags = {
    Name = var.public_acl_name
  }
}

# PRIVATE FOR DATABASE SERVER

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.terraform_vpc.id
  name = var.db_sg_name

  egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1 # allow all
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
        from_port       = 27017
        to_port         = 27017
        protocol        = "tcp"
        security_groups = [aws_security_group.app_sg.id]
  }
  ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [var.my_ip]
  }
}

resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.terraform_vpc.id
  #subnet_ids = [aws_subnet.terraform_private_sub.id]

  egress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
  }
  egress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
  }
  egress {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = var.public_cidr
      from_port  = 1024
      to_port    = 65535
  }

  ingress {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = var.my_ip
      from_port  = 22
      to_port    = 22
  }
  ingress {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = var.private_cidr
      from_port  = 27017
      to_port    = 27017
  }
  ingress {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
  }
  ingress {
      protocol   = "tcp"
      rule_no    = 140
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
  }
  ingress {
      protocol   = "tcp"
      rule_no    = 150
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
 }
}















