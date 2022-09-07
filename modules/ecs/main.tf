resource "aws_ecs_cluster" "python_app_cluster" {
  name = "python-app-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#Service that is running based on the task definition
resource "aws_ecs_service" "python_service" {
  name                 = "service-for-python-app"
  force_new_deployment = true
  cluster              = aws_ecs_cluster.python_app_cluster.id
  task_definition      = aws_ecs_task_definition.python_task.arn
  desired_count        = 1
  iam_role             = aws_iam_role.ecs_service_role.arn
  depends_on           = [aws_iam_role_policy.ecs_policy, aws_ecs_task_definition.python_task]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = var.target_group_arns
    container_name   = var.container_name
    container_port   = var.container_port
  }
}

resource "aws_ecs_task_definition" "python_task" {
  family = "service"
  container_definitions = jsonencode([
    {
      name = var.container_name
      #image     = "${var.ecr_url}:${var.image_tag}"
      image     = "${format("%s:%s", var.ecr_url, var.image_tag)}"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = 0
        }
      ]
    },
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

}

resource "aws_iam_role" "ecs_service_role" {
  name = "ec2_service_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "ecs_service_role"
  }
}

resource "aws_iam_role_policy" "ecs_policy" {
  name = "ecs_policy"
  role = aws_iam_role.ecs_service_role.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ECSTaskManagement",
        "Effect" : "Allow",
        "Action" : [
          "ec2:AttachNetworkInterface",
          "ec2:CreateNetworkInterface",
          "ec2:CreateNetworkInterfacePermission",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteNetworkInterfacePermission",
          "ec2:Describe*",
          "ec2:DetachNetworkInterface",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:DeregisterTargets",
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "elasticloadbalancing:RegisterTargets",
          "route53:ChangeResourceRecordSets",
          "route53:CreateHealthCheck",
          "route53:DeleteHealthCheck",
          "route53:Get*",
          "route53:List*",
          "route53:UpdateHealthCheck",
          "servicediscovery:DeregisterInstance",
          "servicediscovery:Get*",
          "servicediscovery:List*",
          "servicediscovery:RegisterInstance",
          "servicediscovery:UpdateInstanceCustomHealthStatus"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AutoScaling",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:Describe*"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AutoScalingManagement",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling:DeletePolicy",
          "autoscaling:PutScalingPolicy",
          "autoscaling:SetInstanceProtection",
          "autoscaling:UpdateAutoScalingGroup"
        ],
        "Resource" : "*",
        "Condition" : {
          "Null" : {
            "autoscaling:ResourceTag/AmazonECSManaged" : "false"
          }
        }
      },
      {
        "Sid" : "AutoScalingPlanManagement",
        "Effect" : "Allow",
        "Action" : [
          "autoscaling-plans:CreateScalingPlan",
          "autoscaling-plans:DeleteScalingPlan",
          "autoscaling-plans:DescribeScalingPlans"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "CWAlarmManagement",
        "Effect" : "Allow",
        "Action" : [
          "cloudwatch:DeleteAlarms",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:PutMetricAlarm"
        ],
        "Resource" : "arn:aws:cloudwatch:*:*:alarm:*"
      },
      {
        "Sid" : "ECSTagging",
        "Effect" : "Allow",
        "Action" : [
          "ec2:CreateTags"
        ],
        "Resource" : "arn:aws:ec2:*:*:network-interface/*"
      },
      {
        "Sid" : "CWLogGroupManagement",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:DescribeLogGroups",
          "logs:PutRetentionPolicy"
        ],
        "Resource" : "arn:aws:logs:*:*:log-group:/aws/ecs/*"
      },
      {
        "Sid" : "CWLogStreamManagement",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:log-group:/aws/ecs/*:log-stream:*"
      },
      {
        "Sid" : "ExecuteCommandSessionManagement",
        "Effect" : "Allow",
        "Action" : [
          "ssm:DescribeSessions"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "ExecuteCommand",
        "Effect" : "Allow",
        "Action" : [
          "ssm:StartSession"
        ],
        "Resource" : [
          "arn:aws:ecs:*:*:task/*",
          "arn:aws:ssm:*:*:document/AmazonECS-ExecuteInteractiveCommand"
        ]
    }] }

  )
}
