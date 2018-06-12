# 配置私有gitlab https

> 参考：http://docs.gitlab.com/omnibus/settings/nginx.html

## 在gitlab服务器创建证书对

sudo mkdir -p /etc/gitlab/ssl
sudo chmod 700 /etc/gitlab/ssl
cd /etc/gitlab/ssl  # 使用在线生成的公钥和私钥颁证书

openssl x509 -in gitlab.aniu.so.csr -out gitlab.aniu.so.crt -req -signkey gitlab.aniu.so.key -days 3650

sudo cp gitlab.aniu.so.key gitlab.aniu.so.crt /etc/gitlab/ssl/

openssl x509 -in server.csr -out server.crt -req -signkey server.key -days 3650

# 使用生成的证书对gitlab进行配置，同时重定向http到https

```
external_url "https://gitlab.aniu.so"
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.example.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.example.com.key"
```


# csr

-----BEGIN CERTIFICATE REQUEST-----
MIICsTCCAZkCAQAwbDEXMBUGA1UEAwwOZ2l0bGFiLmFuaXUuc28xDTALBgNVBAoM
BGFuaXUxDzANBgNVBAsMBnl1bndlaTERMA8GA1UECAwIU2hhbmdoYWkxETAPBgNV
BAcMCFNoYW5naGFpMQswCQYDVQQGEwJDTjCCASIwDQYJKoZIhvcNAQEBBQADggEP
ADCCAQoCggEBAOip1aYXmaB7dSgd7QNpcC9y+50jk0vo6D/QQzJXnab0O48+t9Qz
TqtQXQxi848PCV+Co3+4InT/Z0sybWSkEd7AF6TpsNjQ8CA/fFfq5Sioz8rPFGRW
xAxcfQtDXdk6sLG7MNfyYUSsyzQJ/2J4vHSopppu9KR0Fq8H/3OUHG4g7GfG7saE
1XN7xt/JDNkl07H/6+pwdMi3ch+GcNFr9yJgUvpVKpSPL0/xacSCig7fQP28PLAM
5KmGy1yxD0KvHHVQRyjjhAhawRIunGjoFWmgh6sbjMXj0AXcY6T/Vam0Mm4VsEBo
NqBeZFwtOvv3vLR29JNJwtGGxq3HMuof9VMCAwEAAaAAMA0GCSqGSIb3DQEBCwUA
A4IBAQApGHEec+c6soj5wAaLPYOq8i0nDe1ka4vEBZ76t94DWl70w4DIHRLXFLUn
UZMA3jv+awwVhrOEQl5DonqVq/09KMDYWqENVPO5Ayt+3ou0cp9oQQiFUk1ypR3u
TjFPcuqeHlhnPrPwfMi4QzV5BYOFP2/lttw2gzOfW6XgZmJXA47eb7o10tNSNzlF
Czf1onO+DHeraeYvMbaWrPWhGgHoh8rG3r/kN7QcfStHRE0H+iRLU/5frgA6HyVZ
pVreKvls1fgEisHgZlI0jFjpHueDMKdO4pKcmtTvf46qxbANtMbsqgFXVnrh3gpN
Q9PCwY1NE3ai5mkarBn2NOWDhfQc
-----END CERTIFICATE REQUEST-----


# 证书私钥：

-----BEGIN PRIVATE KEY-----
MIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDoqdWmF5mge3Uo
He0DaXAvcvudI5NL6Og/0EMyV52m9DuPPrfUM06rUF0MYvOPDwlfgqN/uCJ0/2dL
Mm1kpBHewBek6bDY0PAgP3xX6uUoqM/KzxRkVsQMXH0LQ13ZOrCxuzDX8mFErMs0
Cf9ieLx0qKaabvSkdBavB/9zlBxuIOxnxu7GhNVze8bfyQzZJdOx/+vqcHTIt3If
hnDRa/ciYFL6VSqUjy9P8WnEgooO30D9vDywDOSphstcsQ9Crxx1UEco44QIWsES
Lpxo6BVpoIerG4zF49AF3GOk/1WptDJuFbBAaDagXmRcLTr797y0dvSTScLRhsat
xzLqH/VTAgMBAAECggEAbP7TNgIsWEA9/FM4q7aDddcaBN2brZ4o32xDbpwZIROd
q1eoauK2Yg896AWbMFPNAk+DJNwwWDsmOtYe5VzvejjnWryXupr3Q0Q6jj1eqZOb
9NjaJr93DItvkQ04NAIIsNqO4TuNUczZTUG5wHnrX4N6uTJtrXUtA0Zt58llIDmr
kiSLyxAe//oyMUk4Dvy5S7h9hJS/FioKACfYCU4enwfixZbYkz2lxCKD/zD6gcRG
obBc7WKR27yQs9gb6Y+3pYLpq8LXhR7xb9quXR5EogP+/d4vciGJ1x6JOQ0vXo9c
r+FvHskKfMU5tEwIHJScrltgiYqULhieRmhh35clQQKBgQD4kNUUb26m0oRrv4+E
ktmwnMZnu3Q7mdLE5iSEusbBM3BUIOOaNDMIK01qT9BTQX6AYwatVToRyc1E/sYi
Su+HlqUxLPsR0vnuXS+BS2sJ2apIC+N0Uixvxjndc/CfVWZ97JBT5cUyAxRc7+5d
Qs7R8w0qQafvoXiJh2JsJ5dzMQKBgQDvnz6U61/O3zFWqTF3ZXWK0sVWg7dNa7gz
ADvQoSRRsKWR+SpWaIvW0IW2XY7Lu7pNL98lWEJyCALuTsTJ5mQq+xjS2xFcAzHo
WKy9OoAMizy7PtpUYm5qsv/TdP5uuQowQF12XhIfXW//Ti4emy+tWESPoHgRyRJr
6zhdXXLnwwKBgCR2qqt6xVK3ozFjQpyCJmkgNoLVHvH3WNIFqOnHtIx3DU1qHblr
Wukh4RNtbfQosXQIEtyumfwuDGzIqywwrf7H/KfAH3y35G4xQVzIQYWKZs524AEa
ZOZov+har7vP/V8PqwSDum/hv8T6dY8807Y833uJcidXGqWiNLAFBtShAoGANxIs
OeGWlV7qYfZkrgIdb5hdTjLbb+mv3djR5nMCe9vTUacoOc+xQ9+Mu4rpBJ3ShWbZ
LCYKr1Z0Bf0IcTaIEvC+lcdPSAxb7gBjQuItB7UAcjBR0U8F/XPCJAEhcKUKWGiS
kl+wXpEE6nI3W0VjQb2llDTXI49IspDO1XZisC0CgYBLstxc+hvgEUxeMPR5o4ji
sbff+JkndFhR3k777o5jKeUGdLdHh9yxAeyV8WLeJ0xY6N3BCcgPeQybofNXfWd5
x+59c6E40wbTZTkUe5bU1YnnW58nfWeCyQyH2tPJxOjKtlHXp6fAglNo9HwI8YLc
XARW0URUQOyywIqnWogfgQ==
-----END PRIVATE KEY-----
