# Configuracion de Firebase

1. Crea un proyecto en Firebase.
2. Habilita Authentication (email, Google, o los proveedores que necesites).
3. Crea una base de datos Firestore en modo produccion.
4. Habilita Storage.
5. Agrega la app Android:
   - Nombre de paquete desde android/app/build.gradle.kts
   - Descarga google-services.json y colocalo en android/app/
6. Agrega la app iOS:
   - Bundle ID desde ios/Runner.xcodeproj
   - Descarga GoogleService-Info.plist y colocalo en ios/Runner/
7. Para Web:
   - Agrega la app web y guarda la configuracion en un lugar seguro
   - Usa Firebase CLI si planeas desplegar Hosting
8. Aplica las reglas de seguridad:
   - Firestore: [firestore.rules](../firestore.rules)
   - Storage: [storage.rules](../storage.rules)

Nota: La sincronizacion solo se ejecuta cuando el usuario esta autenticado.
