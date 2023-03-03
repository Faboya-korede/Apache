resource "aws_route53_zone" "zone" {
  name         = "korede.me"
}


resource "aws_route53_record" "www" {
   zone_id = aws_route53_zone.zone.zone_id
   name    = "terrafrom-test.korede.me"
   type    = "A"


  alias {
   name                    = aws_alb.alb.dns_name
   zone_id                 = aws_alb.alb.zone_id
   evaluate_target_health  = true

}
}
