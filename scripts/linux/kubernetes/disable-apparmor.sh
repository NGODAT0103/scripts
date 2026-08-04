#!/bin/bash
systemctl stop apparmor
systemctl disable apparmor
systemctl restart containerd.service
