import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.atomictractorltd.klookin"
    // Pinned rather than inherited from the Flutter tool: Play requires the
    // target API level to stay within one year of the latest Android release
    // (API 36 / Android 16) to keep accepting app updates.
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.atomictractorltd.klookin"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        // Create a debug signing config that can be used as fallback.
        // Prefer a project-local debug.keystore, but fall back to the
        // standard Android debug keystore (~/.android/debug.keystore) so
        // builds work on machines without a checked-in keystore.
        getByName("debug") {
            val localDebugKeystore = file("${project.rootDir}/debug.keystore")
            val defaultDebugKeystore =
                File(System.getProperty("user.home"), ".android/debug.keystore")
            storeFile = if (localDebugKeystore.exists()) {
                localDebugKeystore
            } else {
                defaultDebugKeystore
            }
            storePassword = "android"
            keyAlias = "androiddebugkey"
            keyPassword = "android"
        }
        
        // Check if key.properties exists and has valid keystore file
        val keystorePropertiesFile = rootProject.file("key.properties")
        if (keystorePropertiesFile.exists()) {
            val keystoreProperties = Properties()
            keystoreProperties.load(FileInputStream(keystorePropertiesFile))
            val storeFileFromProperties = keystoreProperties.getProperty("storeFile")
            
            // Only create release signing config if keystore file exists
            if (file(storeFileFromProperties).exists()) {
                create("release") {
                    storeFile = file(storeFileFromProperties)
                    storePassword = keystoreProperties.getProperty("storePassword")
                    keyAlias = keystoreProperties.getProperty("keyAlias")
                    keyPassword = keystoreProperties.getProperty("keyPassword")
                }
            }
        }
    }

    buildTypes {
        release {
            // Use release signing if available, otherwise use debug signing
            if (signingConfigs.findByName("release") != null) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}
