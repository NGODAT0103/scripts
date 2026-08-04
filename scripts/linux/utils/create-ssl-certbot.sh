#!/bin/bash
certbot certonly   --dns-cloudflare   --dns-cloudflare-credentials /etc/letsencrypt/cloudflare.ini --dns-cloudflare-propagation-seconds 60
