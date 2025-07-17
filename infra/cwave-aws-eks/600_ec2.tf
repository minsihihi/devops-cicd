# TLS 프라이빗 키 생성 (공개 키 포함)
resource "tls_private_key" "example" {
    algorithm = "RSA"
    rsa_bits  = 2048
}

# AWS에서 키 페어 생성
resource "aws_key_pair" "ec2_key" {
    key_name   = "ec2-key" # AWS에서 사용할 키 페어 이름
    public_key = tls_private_key.example.public_key_openssh
}

# -------^ ec2 instace 접속 키페어 생성 ^------------

# EC2 인스턴스 생성
resource "aws_instance" "nginx_instance" {
    ami             = "ami-08b09b6acd8d62254" # Amazon Linux 2 AMI (리전별로 AMI ID가 다를 수 있음)
    instance_type   = "t2.micro"
    key_name        = aws_key_pair.ec2_key.key_name # AWS에서 생성한 SSH 키 적용
    security_groups = [aws_security_group.nginx_sg.name]

    # 인스턴스를 다시 만들때 빠르게 교체 하기 위한 옵션
    # user_data가 변경된다고 해서 인스턴스 안바뀐다.
    lifecycle {
        create_before_destroy = true
    }

    # EC2 시작 시 Nginx 설치 및 실행을 위한 User Data
    # 인스턴스 최초 생성될 때 딱 한 번 생성된다!!!!!
    # 이후에 수정해서 terraform apply해도 반영 안됨
    # 특정 조건 하에 인스턴스 삭제 후 재실행 해야 다시 apply되고 반영된다.
    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                amazon-linux-extras install nginx1 -y
                systemctl start nginx
                systemctl enable nginx
                EOF
    tags = {
    Name = "nginx-server"
    }
}


# 출력: EC2 인스턴스의 퍼블릭 IP 주소
output "nginx_instance_public_ip" {
    value       = aws_instance.nginx_instance.public_ip
    description = "Public IP of the Nginx EC2 instance"
}

# 출력: SSH 접속에 사용할 Private Key
output "ssh_private_key_pem" {
    value       = tls_private_key.example.private_key_pem
    description = "Private key for SSH access"
    sensitive   = true
}