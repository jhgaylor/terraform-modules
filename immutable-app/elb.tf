resource "aws_elb" "app-elb" {
  name = "foobar-terraform-elb"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]

  access_logs {
    bucket = "trumpdicks-logs-bucket"
    bucket_prefix = "api-elb"
    interval = 60
  }

  listener {
    instance_port = 3000
    instance_protocol = "http"
    lb_port = 443
    lb_protocol = "https"
  }

  listener {
    instance_port = 3000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:3000/target"
    interval = 30
  }

  instances = ["${aws_instance.app.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.app_name}-terraform-elb"
  }
}