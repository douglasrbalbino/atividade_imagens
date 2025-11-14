plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.atividade_images"
    compileSdk = 36 // CORRIGIDO para a versão compatível com os plugins.

    defaultConfig {
        applicationId = "com.example.atividade_images"
        minSdk = flutter.minSdkVersion
        targetSdk = 36 // ATUALIZADO para a versão de compilação.
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}

dependencies {
    // dependências do Firebase REMOVIDAS
}