#!/bin/bash
HTML_FILE="/home/headstar/nginx/cpu/cpu_load.html"
HTML_DIR="/home/headstar/nginx/cpu"

if [ ! -d $HTML_DIR ]; then
echo "directory doesn't exist"
mkdir -p $HTML_DIR
fi

while (true)
do

CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
DATE=$(date)

cat <<EOF > "$HTML_FILE"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="1">
    <title>CPU Load</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        p {
            font-size: 24px;
        }
        .cpu-load {
            color: red;
        }
    </style>
</head>
<body>
    <p>Current CPU Load: <strong>${DATE}</strong> <strong class="cpu-load">${CPU_LOAD}</strong></p>
</body>
</html>
EOF

done
