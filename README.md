# Zentra

Zentra es un gestor de finanzas personales offline-first construido con Flutter. Se enfoca en acceso rapido a datos locales, flujos multi-moneda (VES, USD, USDT) y una interfaz limpia y moderna. La sincronizacion en la nube y las funciones de IA son opcionales.

## Destacados
- Offline-first por defecto (sin login requerido).
- Motor multi-moneda con conversion centralizada.
- Tasas de cambio en tiempo real (BCV y Binance).
- Transacciones recurrentes y tareas en segundo plano.
- Sincronizacion opcional con Firebase al autenticar.
- Riverpod para estado y GoRouter para navegacion.
- Persistencia con Drift (SQLite) y patron repositorio.

## Stack Tecnologico
- Flutter (stable)
- Dart SDK ^3.11.0
- Drift (SQLite)
- Riverpod
- GoRouter
- Firebase (opcional)

## Inicio Rapido
1. Instalar dependencias:
   flutter pub get
2. Generar archivos de Drift:
   flutter pub run build_runner build --delete-conflicting-outputs
3. Ejecutar la app:
   flutter run

## Configuracion
### Endpoint de IA
Actualiza el endpoint de IA en [lib/core/config/app_config.dart](lib/core/config/app_config.dart) y sigue [docs/genkit_setup.md](docs/genkit_setup.md).

### Firebase (Opcional)
- Agrega google-services.json (Android) y GoogleService-Info.plist (iOS).
- Configura Firebase para Web si aplica.
- Detalles: [docs/firebase_setup.md](docs/firebase_setup.md)
- Reglas: [firestore.rules](firestore.rules), [storage.rules](storage.rules)

## Estructura del Proyecto
- lib/app: App shell, router, providers, temas.
- lib/core: Servicios, configuracion, acceso a datos, utilidades compartidas.
- lib/features: Modulos por feature (dashboard, transacciones, tasas, etc.).
- lib/l10n: Archivos de localizacion.

## Compilaciones
### Web
- flutter build web
- Hospeda build/web en cualquier hosting estatico.

### Android APK
- flutter build apk --release
- Salida: build/app/outputs/flutter-apk/app-release.apk

## Localizacion
- [lib/l10n/app_es.arb](lib/l10n/app_es.arb)
- [lib/l10n/app_en.arb](lib/l10n/app_en.arb)

## Contribuir
Issues y pull requests son bienvenidos. Por favor mantén los PRs enfocados e incluye una breve descripcion del cambio.

## Licencia
Este repositorio aun no incluye una licencia. Todos los derechos reservados hasta que se agregue una.
