resource "aws_route53_zone" "private" {
  name = "spring-petclinic.com"

  vpc {
    vpc_id = aws_vpc.tf.id
  }
}

resource "aws_route53_record" "jenkins" {
  zone_id = aws_route53_zone.private.zone_id
  name    = "jenkins"
  type    = "A"
  ttl     = 300
  records = [aws_instance.launch.private_ip]
}