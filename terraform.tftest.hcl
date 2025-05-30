# プランのテスト（実際にリソースを作成しない）
run "validate_plan" {
  command = plan

  variables {
    instance_type = "t2.micro"
    environment   = "test"
  }

  assert {
    condition     = aws_instance.web.instance_type == "t2.micro"
    error_message = "Instance type should be t2.micro"
  }

  assert {
    condition     = aws_instance.web.tags.Environment == "test"
    error_message = "Environment tag should be set to 'test'"
  }

  assert {
    condition     = length(aws_security_group.web.ingress) >= 2
    error_message = "Security group should have at least 2 ingress rules (HTTP and HTTPS)"
  }
}

run "validate_security_group" {
  command = plan

  assert {
    condition = length([
      for rule in aws_security_group.web.ingress :
      rule if rule.from_port == 80
    ]) > 0
    error_message = "Security group should allow HTTP traffic"
  }

  assert {
    condition = length([
      for rule in aws_security_group.web.ingress :
      rule if rule.from_port == 443
    ]) > 0
    error_message = "Security group should allow HTTPS traffic"
  }
}

# 実際のリソースを作成してテスト
run "validate_apply" {
  command = apply

  variables {
    instance_type = "t2.micro"
    environment   = "test"
  }

  assert {
    condition     = aws_instance.web.state == "running"
    error_message = "Instance should be in running state"
  }

  assert {
    condition     = can(regex("^i-[0-9a-f]{8,17}$", aws_instance.web.id))
    error_message = "Instance ID should be valid"
  }

  assert {
    condition     = aws_instance.web.public_ip != ""
    error_message = "Instance should have a public IP"
  }
}

# アウトプットのテスト
run "validate_outputs" {
  command = apply

  assert {
    condition     = can(regex("^http://", output.web_url))
    error_message = "Web URL should start with http://"
  }

  assert {
    condition     = output.instance_id != ""
    error_message = "Instance ID output should not be empty"
  }
}