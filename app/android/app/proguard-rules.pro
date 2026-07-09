# Regras R8/ProGuard para o release do Grovely.
# Flutter + plugins acessam classes por reflection; mantê-las evita crash no
# release ofuscado. (audit SECURITY_AUDIT.md — minify ligado)

# Flutter engine / embedding
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# flutter_local_notifications (recebe reflection do Gson interno)
-keep class com.dexterous.** { *; }
-keep class com.google.gson.** { *; }
-keepattributes Signature
-keepattributes *Annotation*

# Desugar (java.time em minSdk baixo)
-dontwarn j$.**
-keep class j$.** { *; }

# Modelos serializados por reflection (mantém nomes de campos p/ (de)serialização)
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}
