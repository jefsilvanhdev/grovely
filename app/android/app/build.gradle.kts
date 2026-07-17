import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Assinatura de release: cria android/key.properties (fora do git) apontando
// para o keystore do Grovely — ver android/key.properties.example. Sem o
// arquivo, o build de release cai para a chave de debug (só para rodar local;
// o Play Console rejeita AAB de debug).
val keystoreProperties = Properties().apply {
    val f = rootProject.file("key.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
val hasReleaseKeystore = keystoreProperties.containsKey("storeFile")

// AdMob App ID: vem de android/admob.properties (gitignored) — ver
// admob.properties.example. Default = App ID de TESTE oficial do Google, que
// serve pra dev mas NÃO pode ir pra produção (política do AdMob). O guard no
// buildType release aborta o build se ainda for o de teste.
val ADMOB_TEST_APP_ID = "ca-app-pub-3940256099942544~3347511713"
val admobProperties = Properties().apply {
    val f = rootProject.file("admob.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}
val admobAppId: String = (admobProperties["admobAppId"] as String?) ?: ADMOB_TEST_APP_ID

android {
    namespace = "com.grovely.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Necessário p/ flutter_local_notifications (APIs java.time em minSdk baixo).
        isCoreLibraryDesugaringEnabled = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.grovely.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // firebase_* e google_mobile_ads exigem minSdk 23.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["admobAppId"] = admobAppId
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                storeFile = rootProject.file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                // Sem key.properties: debug key só pra `flutter run --release`
                // local. GATE DE RELEASE: não subir AAB assim (QA C4).
                signingConfigs.getByName("debug")
            }
            // R8: encolhe + ofusca (audit). Regras em proguard-rules.pro mantêm
            // o que os plugins acessam por reflection.
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

// GATE de release: nunca publicar com o App ID de TESTE do AdMob (viola a
// política e não serve anúncio real). Checado no task graph — só dispara em
// assembleRelease/bundleRelease, deixando o debug rodar com o ID de teste.
gradle.taskGraph.whenReady {
    val releasing = allTasks.any { t ->
        t.name.contains("Release") &&
            (t.name.startsWith("assemble") || t.name.startsWith("bundle"))
    }
    if (releasing && admobAppId == ADMOB_TEST_APP_ID) {
        throw GradleException(
            "AdMob: build de RELEASE com App ID de TESTE. " +
            "Crie android/admob.properties com o App ID real " +
            "(ver android/admob.properties.example)."
        )
    }
}
