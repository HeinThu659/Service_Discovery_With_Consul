#!/bin/bash
set -e

# ==========================================
# 1. Create dedicated application user
# ==========================================
useradd --system --no-create-home ${app_user} || true


# ==========================================
# 2. Create application directory
# ==========================================
mkdir -p ${app_directory}


# ==========================================
# 3. Download application binary
# ==========================================
aws s3 cp \
  s3://${bucket_name}/counting-service_linux_amd64 \
  ${app_directory}/counting-service


# ==========================================
# 4. Set permissions
# ==========================================
chmod +x ${app_directory}/counting-service

chown -R ${app_user}:${app_user} ${app_directory}


# ==========================================
# 5. Install systemd service definition
# ==========================================
cat > /etc/systemd/system/counting.service <<'EOF'
${counting_service}
EOF


# ==========================================
# 6. Tell systemd about the new service
# ==========================================
systemctl daemon-reload


# ==========================================
# 7. Enable + start service
# ==========================================
systemctl enable --now counting