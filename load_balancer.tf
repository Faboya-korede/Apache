resource "aws_lb_target_group" "Altschool-tg" {
  name          = "Altchool-target-group"
  port          = 80
  protocol      = "HTTP"
  vpc_id        = aws_vpc.main.id

  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    matcher             = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "web-attachment" {
  target_group_arn = aws_lb_target_group.Altschool-tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}


resource "aws_lb_target_group_attachment" "web-2-attachment" {
  target_group_arn = aws_lb_target_group.Altschool-tg.arn
  target_id        = aws_instance.web-2.id
  port             = 80
}


resource "aws_lb_target_group_attachment" "web-3-attchment" {
  target_group_arn = aws_lb_target_group.Altschool-tg.arn
  target_id        = aws_instance.web-3.id
  port             = 80
}

resource "aws_alb" "alb" {
  name = "Altschool-lb"
  internal = false
  security_groups = [aws_security_group.web_sg.id]
  subnets = [aws_subnet.public-1-subnet.id, aws_subnet.public-3-subnet.id]
}

resource "aws_alb_listener" "alb_listener"{
 load_balancer_arn = aws_alb.alb.arn
 port               = "80"
 protocol           = "HTTP"
 default_action {
  target_group_arn = aws_lb_target_group.Altschool-tg.arn
  type             = "forward"
 }
}
