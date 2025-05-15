# Keep Flutter classes
-keep class io.flutter.** { *; }
-dontwarn io.flutter.embedding.**

# Keep Pusher classes
-keep class com.pusher.** { *; }
-dontwarn com.pusher.**

# Keep Kotlin metadata (recommended for Kotlin projects)
-keep class kotlin.Metadata { *; }