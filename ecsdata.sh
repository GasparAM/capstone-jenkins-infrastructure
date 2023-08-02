#!/bin/bash
yum install -y ecs-init
touch /etc/ecs/ecs.config
echo "ECS_CLUSTER=Jenkins-agents" > /etc/ecs/ecs.config
# systemctl daemon-reload &&
systemctl disable --now docker
systemctl enable --now ecs --no-block