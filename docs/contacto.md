El formulario usa MailForm y envía a vianpropiedades@gmail.com. El correo del visitante se usa como Reply-To; el remitente es la cuenta SMTP autenticada.

Configurar en el entorno del servidor (no guardar contraseñas en Git):

```
SMTP_USERNAME=vianpropiedades@gmail.com
SMTP_PASSWORD=contraseña_de_aplicación
SMTP_DOMAIN=dominio-del-sitio.cl
```

Por defecto utiliza smtp.gmail.com, puerto 587 y STARTTLS. SMTP_ADDRESS y SMTP_PORT permiten utilizar otro proveedor. Reiniciar Rails después de configurar las variables.

Para Gmail, usar una contraseña de aplicación de la cuenta, no la contraseña habitual. El envío real requiere estas credenciales. En test se utiliza el adaptador de correo de pruebas y no se envían mensajes reales.
