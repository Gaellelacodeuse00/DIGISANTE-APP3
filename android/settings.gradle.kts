pluginManagement {
    val flutterSdkPath =run {
        val properties = java.util.Properties()
        val propertiesFile = file("../local.properties") // Correction du chemin
        if (propertiesFile.exists()) {
            propertiesFile.inputStream().use { properties.load(it) }
        }
        var sdkPath = properties.getProperty("flutter.sdk")
        if (sdkPath == null) {
            sdkPath = System.getenv("FLUTTER_ROOT")
        }
        if (sdkPath == null) {
            throw Exception("flutter.sdk n'est pas défini dans local.properties ET la variable d'environnement FLUTTER_ROOT est manquante.")
        }
        // CORRECTION : S'assurer que le résultat est bien retourné par le bloc 'run'
        sdkPath.removeSuffix("/bin").removeSuffix("\\bin")
    }

    // Vérification pour s'assurer que le chemin n'est pas null avant de l'utiliser
    if (flutterSdkPath == null) {
        throw Exception("Le chemin vers le SDK Flutter n'a pas pu être déterminé.")
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false // Mettez à jour si nécessaire
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version("4.3.15") apply false
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false // Mettez à jour si nécessaire
}

include(":app")
