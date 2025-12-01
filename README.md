# Aplicación Móvil Flutter con Backend Node.js- Proyecto Final Desarrollo Movil

Implementación de una aplicación móvil desarrollada con **Flutter**, integrada con un backend en **Node.js + Express** y base de datos **SQLite**. El sistema permite gestión de usuarios, autenticación y carga de imágenes de perfil desde la cámara o galería del dispositivo.

---

## Funcionalidades

### Aplicación Móvil (Flutter)
- Sistema de registro e inicio de sesión
- Gestión de perfil de usuario
- Captura de fotografías con la cámara del dispositivo
- Selección de imágenes desde la galería
- Conversión y envío de imágenes en formato Base64
- Visualización de imagen de perfil almacenada

### API Backend (Node.js)
- Arquitectura modular con separación de responsabilidades
- Base de datos SQLite con creación automática
- Encriptación de contraseñas para seguridad
- Validación de credenciales en login
- Gestión de imágenes de perfil
- Manejo robusto de errores

---

## Estructura del Proyecto

### Backend
```
proyecto-final-backend/
 ├── src/
 │   ├── config/
 │   │   └── db.js
 │   ├── controllers/
 │   │   ├── auth.controller.js
 │   │   └── user.controller.js
 │   ├── routes/
 │   │   ├── auth.routes.js
 │   │   └── user.routes.js
 │   └── server.js
 ├── database.sqlite
 ├── package.json
 └── .env
```

### Frontend
```
proyecto_final_flutter/
 └── lib/
     ├── main.dart
     └── screens/
         ├── login_screen.dart
         ├── register_screen.dart
         └── profile_screen.dart
```

---

## Esquema de Base de Datos

**Tabla: users**

| Campo          | Tipo     | Descripción                    |
|----------------|----------|--------------------------------|
| id             | INTEGER  | Clave primaria                 |
| name           | TEXT     | Nombre completo                |
| age            | INTEGER  | Edad                           |
| email          | TEXT     | Correo electrónico (único)     |
| password_hash  | TEXT     | Contraseña encriptada          |
| profile_image  | TEXT     | Imagen codificada en Base64    |
| created_at     | DATETIME | Timestamp de creación          |

---

## Instalación

### Configurar Backend
```bash
cd proyecto-final-backend
npm install
npm run dev
```

El servidor estará disponible en `http://localhost:3000`

**Nota:** Para pruebas en dispositivo físico, utilizar la dirección IP local de tu computadora: `http://[TU-IP]:3000`

### Configurar Aplicación Flutter
```bash
cd proyecto_final_flutter
flutter pub get
flutter run
```

Actualizar la URL base en los servicios de la aplicación:

```dart
final url = Uri.parse("http://[TU-IP]:3000/api/auth/login");
```

---

## API Endpoints

### Autenticación
- `POST /api/auth/register` - Crear nueva cuenta
- `POST /api/auth/login` - Autenticar usuario

### Gestión de Usuario
- `GET /api/users/:id` - Obtener información del usuario
- `PUT /api/users/:id/profile-image` - Actualizar foto de perfil

---

## Ejemplos de Requests

### Crear Cuenta
```json
{
  "name": "Usuario Ejemplo",
  "age": 28,
  "email": "usuario@ejemplo.com",
  "password": "contraseña123"
}
```

### Iniciar Sesión
```json
{
  "email": "usuario@ejemplo.com",
  "password": "contraseña123"
}
```

### Actualizar Imagen de Perfil
```json
{
  "profile_image": "data:image/png;base64,iVBORw0KGgoAAAANS..."
}
```

---

## Solución de Problemas

**Conexión desde dispositivo físico**
- Verificar que el dispositivo esté en la misma red Wi-Fi
- Utilizar la IP local en lugar de localhost
- Verificar que el firewall no bloquee el puerto 3000

**Error de límite de payload**
- El backend está configurado con límite de 10MB para imágenes
```javascript
app.use(express.json({ limit: "10mb" }));
```

**Problemas de compilación en Android**
- Evitar rutas con caracteres especiales o acentos
- Mover el proyecto a una ubicación con ruta simple

---

## Información del Proyecto

**Desarrollado por:** Juan Garzaro  
**Carné:** 202200158  
**Institución:** Universidad Da Vinci de Guatemala  
**Curso:** Desarrollo Móvil

---

## Licencia

Proyecto desarrollado con propósitos académicos. Puede ser utilizado como referencia educativa con la debida atribución.