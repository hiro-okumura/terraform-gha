provider "aws" {
    profile = "terraform"
    region = "ap-northeast-1"
}

resource "aws_instance" "hello-world" {
    ami = "ami-037843ed9009f7d41"
    instance_type = "t2.micro"

    tags = {
        Name = "hello-world"
    }

    user_data = <<EOF
#!/bin/bash
amazon-linux-extras install -y nginx1
systemctl start nginx
EOF
}

