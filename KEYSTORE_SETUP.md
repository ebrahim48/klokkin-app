# Keystore Setup for Klokkin App

This document explains how to configure and use the keystore for signing release builds of the Klokkin app.

## Overview

The Android keystore system protects your app's signature keys from unauthorized use by encrypting them and requiring authentication (e.g., password or certificate) to access them.

## Keystore Configuration

### Files

- `klokkin.keystore`: The actual keystore file that stores the private keys
- `android/key.properties`: Contains keystore properties and passwords (not committed to version control)

### Configuration Priority

The build system looks for keystore information in this order:
1. `android/key.properties` file (if it exists)
2. Environment variables (KEYSTORE_PASSWORD, KEY_ALIAS, KEY_PASSWORD)
3. Default fallback values (for development only)

## Setting Up Your Local Environment

1. **For development with default settings**: No additional setup required - the default values in `build.gradle.kts` will be used.

2. **For production builds**: Create an `android/key.properties` file with your actual keystore information:

```properties
storePassword=yourActualStorePassword
keyPassword=yourActualKeyPassword
keyAlias=yourActualKeyAlias
storeFile=../klokkin.keystore
```

3. **Using environment variables** (recommended for CI/CD):
   - `KEYSTORE_PASSWORD`: Password for the keystore
   - `KEY_ALIAS`: Alias of the key to use
   - `KEY_PASSWORD`: Password for the specific key

## Building a Signed Release

To build a signed release APK:

```bash
flutter build apk --release
```

To build a signed releaseAppBundle:

```bash
flutter build appbundle --release
```

## Security Best Practices

- Never commit the `.keystore` file or `key.properties` to version control
- Use strong passwords for your keystore and keys
- Store environment variables securely in your CI/CD system
- Regularly rotate your keystore passwords
- Keep backups of your keystore file in a secure location
- The `.gitignore` files are already configured to prevent accidental commits

## Creating a New Keystore (if needed)

If you need to create a new keystore, use the following command:

```bash
keytool -genkey -v -keystore klokkin.keystore -alias klokkin_key -keyalg RSA -keysize 2048 -validity 10000
```

Remember to update the `build.gradle.kts` file with the correct alias and store file path if different.