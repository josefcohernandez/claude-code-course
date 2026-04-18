# Ejercicio 02: Crear un Servidor MCP

## Objetivo

Crear un servidor MCP simple con Node.js que exponga herramientas personalizadas.

---

## Preparación

```bash
mkdir -p ~/mi-mcp-server && cd ~/mi-mcp-server
npm init -y
npm install @modelcontextprotocol/sdk
```

Edita `package.json` para añadir `"type": "module"`.

---

## Paso 1: Servidor Basíco (15 min)

Crea `server.js`:

```javascript
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";

const server = new Server(
  { name: "mi-servidor", version: "1.0.0" },
  { capabilities: { tools: {} } }
);

// Definir herramientas
server.setRequestHandler("tools/list", async () => ({
  tools: [
    {
      name: "saludar",
      description: "Genera un saludo personalizado",
      inputSchema: {
        type: "object",
        properties: {
          nombre: { type: "string", description: "Nombre de la persona" },
          idioma: {
            type: "string",
            enum: ["es", "en", "fr"],
            description: "Idioma del saludo"
          }
        },
        required: ["nombre"]
      }
    },
    {
      name: "convertir_temperatura",
      description: "Convierte entre Celsius y Fahrenheit",
      inputSchema: {
        type: "object",
        properties: {
          valor: { type: "number", description: "Temperatura a convertir" },
          de: {
            type: "string",
            enum: ["celsius", "fahrenheit"],
            description: "Unidad de origen"
          }
        },
        required: ["valor", "de"]
      }
    },
    {
      name: "generar_password",
      description: "Genera un password aleatorio seguro",
      inputSchema: {
        type: "object",
        properties: {
          longitud: {
            type: "number",
            description: "Longitud del password (8-64)",
            minimum: 8,
            maximum: 64
          },
          incluir_simbolos: {
            type: "boolean",
            description: "Incluir simbolos especiales"
          }
        },
        required: ["longitud"]
      }
    }
  ]
}));

// Implementar herramientas
server.setRequestHandler("tools/call", async (request) => {
  const { name, arguments: args } = request.params;

  switch (name) {
    case "saludar": {
      const saludos = {
        es: `Hola, ${args.nombre}! Bienvenido!`,
        en: `Hello, ${args.nombre}! Welcome!`,
        fr: `Bonjour, ${args.nombre}! Bienvenue!`
      };
      const idioma = args.idioma || "es";
      return {
        content: [{ type: "text", text: saludos[idioma] || saludos.es }]
      };
    }

    case "convertir_temperatura": {
      let resultado;
      if (args.de === "celsius") {
        resultado = (args.valor * 9/5) + 32;
        return {
          content: [{
            type: "text",
            text: `${args.valor}°C = ${resultado.toFixed(1)}°F`
          }]
        };
      } else {
        resultado = (args.valor - 32) * 5/9;
        return {
          content: [{
            type: "text",
            text: `${args.valor}°F = ${resultado.toFixed(1)}°C`
          }]
        };
      }
    }

    case "generar_password": {
      const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
      const simbolos = "!@#$%^&*()_+-=[]{}|;:,.<>?";
      const pool = args.incluir_simbolos ? chars + simbolos : chars;
      let password = "";
      for (let i = 0; i < args.longitud; i++) {
        password += pool.charAt(Math.floor(Math.random() * pool.length));
      }
      return {
        content: [{ type: "text", text: `Password generado: ${password}` }]
      };
    }

    default:
      return {
        content: [{ type: "text", text: `Herramienta desconocida: ${name}` }],
        isError: true
      };
  }
});

// Conectar
const transport = new StdioServerTransport();
await server.connect(transport);
```

---

## Paso 2: Configurar en Claude Code (5 min)

Edita `.claude/settings.json` en tu proyecto:

```json
{
  "mcpServers": {
    "mi-servidor": {
      "command": "node",
      "args": ["/ruta/completa/a/mi-mcp-server/server.js"]
    }
  }
}
```

---

## Paso 3: Probar (10 min)

```bash
claude
> /mcp                    # Verificar que aparece "mi-servidor"
> "Saluda a Maria en frances"
> "Convierte 100 grados celsius a fahrenheit"
> "Genera un password de 16 caracteres con simbolos"
> /cost
```

---

## Paso 4: Añadir una Herramienta (10 min)

Añade una herramienta más a tu servidor. Sugerencias:

- `calcular_iva`: Calcula IVA de un importe
- `validar_email`: Verifica formato de email
- `contar_palabras`: Cuenta palabras en un texto

Reinicia Claude Code para que detecte la nueva herramienta.

---

## Criterios de Completitud

- [ ] Servidor MCP creado con 3 herramientas
- [ ] Configurado en Claude Code
- [ ] /mcp muestra el servidor
- [ ] 3 herramientas probadas exitosamente
- [ ] 1 herramienta adicional añadida
