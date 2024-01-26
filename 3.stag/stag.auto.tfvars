environment = "stag"

#Amazon certificate arn from ACM 
certificate_alb = "arn:aws:acm:ap-south-1:12345678910:certificate/179cb717-6a21-4e1b-a173-44bfebfa5c69"

instances = {
  1 = {
    instance_class      = "db.r5.large"
    publicly_accessible = false
    identifier          = "app-dev"
  }
}

#WAF
waf_regional_ipset = "arn:aws:wafv2:ap-south-1:12345678910:regional/ipset/waf-ipset-regional/1de9344b-7818-4c26-96bf-df9846547b19"