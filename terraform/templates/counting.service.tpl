[Unit]
Description=${service_name}
After=network.target

[Service]
Type=simple
User=${app_user}
Group=${app_user}
WorkingDirectory=${app_directory}
Environment="PORT=${app_port}"
ExecStart=${app_directory}/counting-service
Restart=on-failure

[Install]
WantedBy=multi-user.target