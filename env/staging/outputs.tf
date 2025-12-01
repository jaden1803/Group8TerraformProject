output "alb_dns_name" {
  description = "DNS name of the dev ALB"
  value       = module.alb.alb_dns_name
}
