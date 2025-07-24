# Flutter Development Environment with Firebase
# This Dockerfile creates a complete development environment for the Firebase Student App

FROM ubuntu:22.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-17-jdk \
    wget \
    gnupg \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js (for Firebase CLI)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Firebase CLI
RUN npm install -g firebase-tools

# Install Flutter
ENV FLUTTER_VERSION=3.16.0
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN git clone https://github.com/flutter/flutter.git -b stable $FLUTTER_HOME \
    && flutter doctor \
    && flutter config --enable-web

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH="$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH"

# Install Android SDK (for Android development)
RUN mkdir -p $ANDROID_HOME \
    && cd $ANDROID_HOME \
    && wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip \
    && unzip commandlinetools-linux-8512546_latest.zip \
    && rm commandlinetools-linux-8512546_latest.zip \
    && mkdir -p cmdline-tools/latest \
    && mv cmdline-tools/* cmdline-tools/latest/ 2>/dev/null || true

# Accept Android licenses
ENV PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
RUN yes | sdkmanager --licenses || true
RUN sdkmanager "platforms;android-33" "build-tools;33.0.0" "platform-tools"

# Create app directory and copy project files
COPY . /app/

# Install Flutter dependencies
RUN flutter pub get

# Run Flutter doctor to verify installation
RUN flutter doctor

# Expose ports for Flutter web server and Firebase emulators
EXPOSE 3000 4000 5000 5001 8080 9099 9199

# Create startup script
RUN echo '#!/bin/bash\n\
echo "🔥 Firebase Student App Development Environment"\n\
echo "==============================================="\n\
echo ""\n\
echo "📋 Available commands:"\n\
echo "  flutter run -d web-server --web-port 3000    # Run Flutter web app"\n\
echo "  firebase emulators:start                     # Start Firebase emulators"\n\
echo "  flutter test                                  # Run tests"\n\
echo "  dart lib/utils/cli_tools.dart help          # CLI tools"\n\
echo "  dart lib/examples/firebase_examples.dart     # Run examples"\n\
echo ""\n\
echo "🌐 URLs when running:"\n\
echo "  Flutter Web App: http://localhost:3000"\n\
echo "  Firebase Emulator UI: http://localhost:4000"\n\
echo "  Firestore Emulator: http://localhost:8080"\n\
echo ""\n\
echo "🚀 Quick start:"\n\
echo "  1. firebase emulators:start &"\n\
echo "  2. flutter run -d web-server --web-port 3000"\n\
echo ""\n\
bash' > /app/start.sh && chmod +x /app/start.sh

# Set default command
CMD ["/app/start.sh"]

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD flutter doctor || exit 1

# Labels for better organization
LABEL maintainer="Firebase Student App" \
      version="1.0" \
      description="Complete Flutter + Firebase development environment" \
      flutter.version="3.16.0" \
      node.version="18" \
      java.version="17"
