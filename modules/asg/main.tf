resource "aws_autoscaling_group" "ecs_auto_scaling_group" {
  name                = "ASG"
  vpc_zone_identifier = var.private_subnets_id
  target_group_arns   = [var.target_group_arns]
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Default"
  }
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 3
  desired_capacity          = 2
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "EC2-${var.environment_name}"
    propagate_at_launch = true
  }
}

data "aws_ami" "awslinux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

resource "aws_launch_template" "ecs_launch_template" {
  name                   = "ecs_cluster"
  image_id               = data.aws_ami.awslinux.id
  vpc_security_group_ids = [aws_security_group.allow_ec2.id]
  instance_type          = var.instance_type
  key_name               = "terraform_admin"
  user_data              = base64encode("user_data.sh")
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_agent.name
  }
}

resource "aws_security_group" "allow_ec2" {
  vpc_id = var.vpc_id
  name   = "EC2 security group"
  dynamic "ingress" {
    for_each = var.sg_asg_ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.alb_sg]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "EC2 security group"
  }
}

data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
