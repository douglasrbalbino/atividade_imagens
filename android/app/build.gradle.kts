plugins {
    id("com.android.application")
    id("kotlin-android")
    // O Plugin do Flutter deve ser aplicado após os plugins Android e Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
    
    // Plugin do Google Services: DEVE ser aplicado no app/build.gradle.kts
    id("com.google.gms.google-services")
}

android {
// ... (código existente, tudo correto)
}

flutter {
    source = "../.."
}

// O bloco DEPENDENCIES está no local CORRETO: fora do bloco android {}
dependencies {
    // Importa o Firebase BoM (Bill of Materials) para gerenciar as versões
    val firebaseBom = platform("com.google.firebase:firebase-bom:34.5.0")
    implementation(firebaseBom)

    // Adiciona as bibliotecas específicas do Firebase que você precisa (Core e Storage)
    implementation("com.google.firebase:firebase-storage-ktx")
    implementation("com.google.firebase:firebase-analytics-ktx") // Analytics é recomendado
}