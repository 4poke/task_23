#!usr/bin/bash
set -x

# Функция для установки AWS CLI на Windows
install_aws_windows() {
    powershell -Command "Invoke-WebRequest -Uri 'https://awscli.amazonaws.com/AWSCLIV2.msi' -OutFile 'AWSCLIV2.msi'; Start-Process -FilePath msiexec -ArgumentList '/i AWSCLIV2.msi /quiet' -Wait; Remove-Item 'AWSCLIV2.msi'"
}

# Функция для установки AWS CLI на macOS
install_aws_macos() {
    echo "Скачивание AWS CLI..."
    curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "$HOME/AWSCLIV2.pkg"
    echo "Установка AWS CLI..."
    sudo installer -pkg "$HOME/AWSCLIV2.pkg" -target /
    echo "Удаление установочного файла..."
    rm "$HOME/AWSCLIV2.pkg"
}

# Функция для установки AWS CLI на Linux
install_aws_linux() {
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo snap install aws-cli --classic
    elif command -v yum &> /dev/null; then
        sudo yum install -y awscli
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y awscli
    else
        echo "Неизвестный пакетный менеджер. Установите AWS CLI вручную."
        exit 1
    fi
}

# Определение ОС и установка AWS CLI
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
    install_aws_windows
elif [[ "$OSTYPE" == "darwin"* ]]; then
    install_aws_macos
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    install_aws_linux
else
    echo "Неизвестная операционная система. Установите AWS CLI вручную."
    exit 1
fi

# Настройка профиля AWS CLI
aws configure set aws_access_key_id YOUR_ACCESS_KEY_ID
aws configure set aws_secret_access_key YOUR_SECRET_ACCESS_KEY
aws configure set default.region YOUR_DEFAULT_REGION

echo "AWS CLI успешно установлена и настроена!"
