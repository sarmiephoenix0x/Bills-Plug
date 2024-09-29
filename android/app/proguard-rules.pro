# Keep the error-prone annotations to prevent R8 from stripping them
-keep class com.google.errorprone.annotations.* { *; }
-keep class com.google.crypto.tink.* { *; }
