resource "aws_acm_certificate" "srikanth553" {
  domain_name       = "*.srikanth553.store"
  validation_method = "DNS"

tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "srikanth553" {
  for_each = {
    for dvo in aws_acm_certificate.srikanth553.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
}

resource "aws_acm_certificate_validation" "srikanth553" {
  certificate_arn         = aws_acm_certificate.srikanth553.arn
  validation_record_fqdns = [for record in aws_route53_record.srikanth553 : record.fqdn]
}