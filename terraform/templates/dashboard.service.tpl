[Unit]
Description=${service_name}
After=network.target

[Service]
Type=simple
User=${app_user}
Group=${app_user}
WorkingDirectory=${app_directory}

Environment="PORT=${app_port}"
Environment="COUNTING_SERVICE_URL=http://${counting_endpoint}:${counting_port}"

ExecStart=${app_directory}/dashboard-service
Restart=on-failure

[Install]
WantedBy=multi-user.target