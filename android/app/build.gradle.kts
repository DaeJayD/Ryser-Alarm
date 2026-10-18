plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

// Owner-controlled credentials; production must never silently use a debug key.
val uploadValues = listOf("RYSER_UPLOAD_STORE_FILE", "RYSER_UPLOAD_STORE_PASSWORD",
    "RYSER_UPLOAD_KEY_ALIAS", "RYSER_UPLOAD_KEY_PASSWORD").map { System.getenv(it) }
val uploadReady = uploadValues.all { !it.isNullOrBlank() }
val testSigning = System.getenv("RYSER_TEST_SIGNING") == "1"
val releaseRequested = gradle.startParameter.taskNames.any { it.contains("release", ignoreCase = true) }
if (releaseRequested && !uploadReady && !testSigning) {
    throw GradleException("Production signing is not configured. Follow docs/PLAY_STORE_RELEASE_GUIDE.md. " +
        "For a sideload test candidate only, explicitly set RYSER_TEST_SIGNING=1.")
}

android {
    namespace = "com.ryser.ryser"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    defaultConfig {
        applicationId = "com.ryser.ryser"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }
    signingConfigs {
        if (uploadReady) {
            create("upload") {
                storeFile = file(uploadValues[0]!!)
                storePassword = uploadValues[1]
                keyAlias = uploadValues[2]
                keyPassword = uploadValues[3]
            }
        }
    }
    buildTypes {
        release {
            signingConfig = if (uploadReady) signingConfigs.getByName("upload")
                else if (testSigning) signingConfigs.getByName("debug") else null
        }
    }
}

kotlin {
    compilerOptions { jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17 }
}
flutter { source = "../.." }
dependencies {
    implementation("androidx.core:core:1.18.0")
    testImplementation("junit:junit:4.12")
    androidTestImplementation("androidx.test:runner:1.7.0")
    androidTestImplementation("junit:junit:4.13.2")
}
