# Paquexpress - Evaluación 3

Video de YOUTUBE de cómo funciona la aplicación:
            |
            v
https://youtu.be/1IYdKWRPQRs

Proyecto de ejemplo para gestión de entregas de paquetes con evidencia de foto y ubicación GPS.

Incluye:
- Backend REST API con FastAPI + MySQL.
- Aplicación móvil/web Flutter para agentes repartidores.
- Script SQL de creación de base de datos.

## 1. Requisitos

- Python 3.10+
- MySQL 8+
- Node/Flutter SDK 3.x
- Git
- Postman (opcional para pruebas de API)

---

## 2. Backend (FastAPI)

Ruta del proyecto backend:

- `evaluacion3_api/`

### 2.1. Crear base de datos MySQL

En MySQL ejecuta el script "paquexpress_db.sql" para crear la base de datos y las tablas correspondientes.

### 2.2. Configurar conexión a la base de datos

Configura la conexión a la BD en `evaluacion3_api/app/database/connection.py` (usuario, contraseña, host, puerto).

### 2.3. Crear entorno virtual e instalar dependencias

cd evaluacion3_api

python -m venv venv

Windows
venv\Scripts\activate

Linux/Mac
source venv/bin/activate

pip install -r requirements.txt

Archivo `requirements.txt` (incluido en el proyecto):

fastapi
uvicorn[standard]
sqlalchemy
mysql-connector-python
passlib
python-jose[cryptography]
python-multipart
requests
pydantic[email]

### 2.4. Ejecutar la API

cd evaluacion3_api
venv\Scripts\activate # o source venv/bin/activate
uvicorn main:app --reload

La documentación Swagger queda en:

- `http://localhost:8000/docs`

---

## 3. Flutter App (Agente repartidor)

Ruta del proyecto Flutter:

- `evaluacion3_flutter/`

### 3.1. Obtener dependencias

cd evaluacion3_flutter
flutter pub get

Asegúrate de que `pubspec.yaml` incluya las dependencias principales (http, provider, geolocator, image_picker, flutter_map, etc.).

### 3.2. Configurar URL de la API

En `lib/constants.dart`:

const String API_BASE_URL = "http://localhost:8000"; // Web / Desktop
// o para emulador Android:
// const String API_BASE_URL = "http://10.0.2.2:8000";


### 3.3. Ejecutar la app

- Para Web:

flutter run -d chrome

- Para Android:

flutter run -d emulator-XXXX

(El código soporta tanto Web como móvil.)

---

## 4. Flujo de pruebas con Postman

Opcionalmente puedes probar la API con Postman:

1. Registrar un agente

POST http://localhost:8000/auth/register
Content-Type: application/json

{
"nombre": "Ivan Taid Ruiz Alcaraz",
"email": "ivan@gmail.com",
"password": "ivantaid123"
}

2. Obtener token de acceso

POST http://localhost:8000/auth/login
Content-Type: application/x-www-form-urlencoded

username=ivan@gmail.com
password=ivantaid123
grant_type=password


Respuesta:

{
"access_token": "eyJhbGc...",
"token_type": "bearer"
}


3. Crear un paquete

POST http://localhost:8000/paquetes/
Authorization: Bearer TU_TOKEN
Content-Type: application/json

{
"codigo": "PKG-001",
"descripcion": "Paquete de prueba",
"direccion_destino": "Av. Siempre Viva 123, Col. Centro, Querétaro",
"ciudad": "Querétaro",
"estado_region": "Querétaro",
"codigo_postal": "76000",
"nombre_destinatario": "Juan Pérez"
}


4. Asignar una entrega al agente

POST http://localhost:8000/entregas/
Authorization: Bearer TU_TOKEN
Content-Type: application/json

{
"paquete_id": 1,
"agente_id": 1,
"notas": "Entrega de prueba asignada desde Postman"
}


5. Consultar entregas asignadas

GET http://localhost:8000/entregas/asignadas
Authorization: Bearer TU_TOKEN


---

## 5. Uso de la aplicación Flutter

Flujo dentro de la app:

1. Iniciar sesión  
   - Pantalla de Login: ingresa email y contraseña registrados.  
   - Internamente llama a `/auth/login` usando `application/x-www-form-urlencoded` y guarda el `access_token` en `flutter_secure_storage`.

2. Ver entregas asignadas  
   - Desde `HomeScreen` pulsa “Ver entregas asignadas”.  
   - La app llama a `GET /entregas/asignadas` y muestra la lista de entregas pendientes para el agente.

3. Registrar entrega con evidencia  
   - Toca una entrega para abrir `EntregaDetailScreen`.  
   - Pasos:
     - Toma la foto de evidencia (cámara o selección según plataforma).
     - Opcional: escribe una descripción de la foto.
     - Pulsa “Obtener ubicación” para capturar latitud/longitud y ver el mini mapa (OpenStreetMap con `flutter_map`).
     - Pulsa “Paquete entregado”.

   - La app envía a la API:
     - Multipart con imagen (`file`).
     - Latitud y longitud.
     - Descripción opcional.
     - `entrega_id`.

   - El backend:
     - Guarda la imagen en `uploads/`.
     - Inserta un registro en `evidencias_entrega`.
     - Marca la entrega como `entregado` y llena `fecha_entregado`.

4. Verificación  
   - Puedes revisar en MySQL:
     - Tabla `entregas`: `estado = entregado`, `fecha_entregado` con timestamp.  
     - Tabla `evidencias_entrega`: registro con ruta de foto, descripción, lat/long.  
   - En el filesystem del backend: archivo dentro de `evaluacion3_api/uploads/`.

---

## 6. Estructura del repositorio

.
├── evaluacion3_api/ # Backend FastAPI
│ ├── app/
│ ├── main.py
│ ├── requirements.txt
│ └── uploads/ # Evidencias (no se versiona)
├── evaluacion3_flutter/ # App Flutter
│ ├── lib/
│ ├── pubspec.yaml
│ └── ...
├── database.sql # Script de creación de BD (opcional)
├── README.md
└── .gitignore
