resource "aws_instance" "launch" {
  ami                    = "ami-04e4606740c9c9381"
  instance_type          = "t3.micro"
  key_name               = "xosqi"
  vpc_security_group_ids = [aws_security_group.tf.id]
  subnet_id              = aws_subnet.public["public-a"].id
  iam_instance_profile   = "ECS_Fargate_from_EC2"
  user_data              = data.template_file.setup.rendered #file("./setup.sh")
  # depends_on = [ aws_ebs_volume.ebs ]
}

data "template_file" "setup" {
  template = file("./setup.sh")
  vars = {
    sg   = aws_security_group.agents.id
    sub1 = aws_subnet.public["public-a"].id
    sub2 = aws_subnet.public["public-b"].id
  }
}

# data "template_cloudinit_config" "config" {
#   gzip          = false
#   base64_encode = false #first part of local config file
#   part {
#     content_type = "text/x-shellscript"
#     content      = file("./setup.sh")
#   }
#   part {
#     content_type = "text/x-shellscript"
#     content      = <<-EOF
#     #!/bin/bash

#     EOF
#   }
# }

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = var.ebs_block
  instance_id = aws_instance.launch.id
}

