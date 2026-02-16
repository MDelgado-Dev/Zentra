# Configuracion de Genkit (Gemini)

El servidor Genkit ahora vive en Firebase Functions para no depender de localhost.
El endpoint publico es:
- `https://us-central1-zentra-hub.cloudfunctions.net/chat`

Payload de ejemplo:
{
  "message": "Cuanto gaste en comida?",
  "locale": "es"
}

Respuesta esperada:
{
  "reply": "Tus gastos en comida este mes son 120.50 USD."
}

Pasos rapidos (Functions):
1. Instala dependencias:
   - `npm --prefix functions install`
2. Registra el secreto en Firebase:
   - `firebase functions:secrets:set GEMINI_API_KEY`
3. Despliega Functions:
   - `firebase deploy --only functions`
4. Verifica el endpoint con Postman o curl.
5. En Flutter, el endpoint ya esta configurado en:
   - [lib/core/config/app_config.dart](../lib/core/config/app_config.dart)

Nota:
- Si usas emulador local, puedes cambiar el endpoint temporalmente.
- Protege el endpoint con Firebase Auth o App Check si lo necesitas.
