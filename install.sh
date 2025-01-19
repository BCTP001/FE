git clone https://github.com/flutter/flutter
echo "export PATH=/workspaces/FE/flutter/bin:$PATH" >> ~/.bashrc
flutter
sudo apt update && sudo apt install -y ninja-build libgtk-3-dev
echo "export ANDROID=/workspaces/FE" >> ~/.bashrc
echo "export PATH=\$ANDROID/cmdline-tools:\$PATH" >> ~/.bashrc
echo "export PATH=\$ANDROID/cmdline-tools/latest/bin:\$PATH" >> ~/.bashrc
echo "export ANDROID_SDK=/workspaces/FE/" >> ~/.bashrc
echo "export PATH=\$ANDROID_SDK:\$PATH" >> ~/.bashrc
flutter config --android-sdk /workspaces/FE/
flutter doctor --android-licenses
