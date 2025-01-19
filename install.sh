git clone https://github.com/flutter/flutter
current_dir=$(pwd)
echo "export PATH=$current_dir/flutter/bin:$PATH" >> ~/.bashrc
. ~/.bashrc
flutter
sudo apt update && sudo apt install -y ninja-build libgtk-3-dev
echo "export ANDROID=$current_dir" >> ~/.bashrc
echo "export PATH=\$ANDROID/cmdline-tools:\$PATH" >> ~/.bashrc
echo "export PATH=\$ANDROID/cmdline-tools/latest/bin:\$PATH" >> ~/.bashrc
echo "export ANDROID_SDK=$current_dir" >> ~/.bashrc
echo "export PATH=\$ANDROID_SDK:\$PATH" >> ~/.bashrc
. ~/.bashrc
flutter config --android-sdk /workspaces/FE/
flutter doctor --android-licenses
