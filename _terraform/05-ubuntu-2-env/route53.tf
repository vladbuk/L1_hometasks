data "aws_route53_zone" "selected" {
  name         = "vladbuk.site."
  private_zone = false
}

resource "aws_route53_record" "test" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "test.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = 3600
  records = [aws_instance.t2micro_ubuntu_test.public_ip]
}

resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "prod.${data.aws_route53_zone.selected.name}"
  type    = "A"
  ttl     = 3600
  records = [aws_instance.t2micro_ubuntu_prod.public_ip]
}

