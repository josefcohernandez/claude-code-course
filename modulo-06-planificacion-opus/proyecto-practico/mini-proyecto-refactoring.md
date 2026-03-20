# Mini-Proyecto: Refactoring con Plan Mode y Opus

## Objetivo

Usar Plan Mode con Opus para disenar un refactoring de codigo legacy,
implementar con Sonnet, y medir el impacto completo.

---

## El Codigo Legacy

El siguiente codigo es un "servicio" monolitico tipico que necesita refactoring.
Copia este contenido en un archivo `legacy_service.py`:

```python
import json
import sqlite3
import hashlib
import smtplib
from email.mime.text import MIMEText
from datetime import datetime

DB_PATH = "app.db"
SMTP_HOST = "smtp.company.com"
ADMIN_EMAIL = "admin@company.com"

def handle_order(data):
    """Handles everything related to orders - too many responsibilities"""
    # Parse input
    if not data:
        return {"error": "no data"}
    if type(data) == str:
        data = json.loads(data)

    user_id = data.get("user_id")
    items = data.get("items", [])
    coupon = data.get("coupon_code")

    if not user_id or not items:
        return {"error": "missing fields"}

    # Connect to DB
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Check user exists
    cursor.execute("SELECT * FROM users WHERE id = " + str(user_id))
    user = cursor.fetchone()
    if not user:
        conn.close()
        return {"error": "user not found"}

    # Calculate total
    total = 0
    order_items = []
    for item in items:
        product_id = item.get("product_id")
        quantity = item.get("quantity", 1)

        cursor.execute("SELECT * FROM products WHERE id = " + str(product_id))
        product = cursor.fetchone()
        if not product:
            conn.close()
            return {"error": f"product {product_id} not found"}

        # Check stock
        if product[3] < quantity:  # product[3] is stock
            conn.close()
            return {"error": f"not enough stock for product {product_id}"}

        price = product[2]  # product[2] is price
        total += price * quantity
        order_items.append({
            "product_id": product_id,
            "quantity": quantity,
            "price": price
        })

    # Apply coupon
    discount = 0
    if coupon:
        cursor.execute("SELECT * FROM coupons WHERE code = '" + coupon + "'")
        coupon_data = cursor.fetchone()
        if coupon_data and coupon_data[2] > datetime.now().timestamp():
            discount = coupon_data[1]  # coupon[1] is discount percentage
            total = total * (1 - discount / 100)

    # Create order
    order_id = hashlib.md5(str(datetime.now()).encode()).hexdigest()[:8]
    cursor.execute(
        "INSERT INTO orders (id, user_id, total, status, created_at) VALUES (?, ?, ?, ?, ?)",
        (order_id, user_id, total, "pending", datetime.now().isoformat())
    )

    # Insert order items
    for oi in order_items:
        cursor.execute(
            "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)",
            (order_id, oi["product_id"], oi["quantity"], oi["price"])
        )

    # Update stock
    for oi in order_items:
        cursor.execute(
            "UPDATE products SET stock = stock - ? WHERE id = ?",
            (oi["quantity"], oi["product_id"])
        )

    conn.commit()

    # Send confirmation email
    try:
        msg = MIMEText(f"Order {order_id} confirmed. Total: ${total:.2f}")
        msg["Subject"] = "Order Confirmation"
        msg["From"] = ADMIN_EMAIL
        msg["To"] = user[2]  # user[2] is email
        server = smtplib.SMTP(SMTP_HOST)
        server.send_message(msg)
        server.quit()
    except:
        pass  # silently ignore email errors

    # Send notification to admin for large orders
    if total > 1000:
        try:
            admin_msg = MIMEText(f"Large order alert: {order_id} = ${total:.2f}")
            admin_msg["Subject"] = "Large Order Alert"
            admin_msg["From"] = ADMIN_EMAIL
            admin_msg["To"] = ADMIN_EMAIL
            server = smtplib.SMTP(SMTP_HOST)
            server.send_message(admin_msg)
            server.quit()
        except:
            pass

    conn.close()

    return {
        "order_id": order_id,
        "total": total,
        "discount": discount,
        "items": len(order_items),
        "status": "pending"
    }


def handle_order_status(order_id, new_status):
    """Updates order status with side effects everywhere"""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM orders WHERE id = '" + order_id + "'")
    order = cursor.fetchone()
    if not order:
        conn.close()
        return {"error": "order not found"}

    old_status = order[3]  # order[3] is status

    cursor.execute(
        "UPDATE orders SET status = ? WHERE id = ?",
        (new_status, order_id)
    )

    # If cancelled, restore stock
    if new_status == "cancelled":
        cursor.execute("SELECT * FROM order_items WHERE order_id = ?", (order_id,))
        items = cursor.fetchall()
        for item in items:
            cursor.execute(
                "UPDATE products SET stock = stock + ? WHERE id = ?",
                (item[2], item[1])  # item[2] is quantity, item[1] is product_id
            )

    conn.commit()

    # Send email for status changes
    cursor.execute("SELECT * FROM users WHERE id = ?", (order[1],))  # order[1] is user_id
    user = cursor.fetchone()
    if user:
        try:
            msg = MIMEText(f"Order {order_id} status: {old_status} -> {new_status}")
            msg["Subject"] = f"Order {order_id} Updated"
            msg["From"] = ADMIN_EMAIL
            msg["To"] = user[2]
            server = smtplib.SMTP(SMTP_HOST)
            server.send_message(msg)
            server.quit()
        except:
            pass

    conn.close()
    return {"order_id": order_id, "old_status": old_status, "new_status": new_status}
```

---

## Problemas del Codigo Legacy

Antes de usar Claude, identifica manualmente los problemas:

1. **SQL Injection**: `str(user_id)` y `'" + coupon + "'`
2. **Responsabilidad multiple**: Una funcion hace DB, validacion, email, calculos
3. **Magic numbers**: `product[3]`, `user[2]`, `order[1]`
4. **Sin manejo de errores**: `except: pass`
5. **Sin transacciones**: Datos inconsistentes si falla a mitad
6. **Acoplamiento**: DB, email y logica de negocio mezclados
7. **Sin tests**: Imposible testear sin refactorizar

---

## Paso 1: Plan con Opus (15 min)

```bash
cd ~/refactoring-exercise
# Copiar el codigo legacy a legacy_service.py
claude --model opus
> Shift+Tab (Plan Mode)
> "Refactoriza legacy_service.py aplicando principios SOLID.
>  Proponer:
>  1. Estructura de archivos (separar responsabilidades)
>  2. Modelos de datos (clases/dataclasses en vez de tuplas)
>  3. Repositorio para BD (sin SQL injection)
>  4. Servicio de email desacoplado
>  5. Servicio de ordenes con logica de negocio
>  6. Validacion de input
>  7. Manejo de errores apropiado
>  8. Tests para cada componente
>
>  Restricciones: mantener la misma funcionalidad,
>  no cambiar el schema de BD"
```

---

## Paso 2: Implementar con Sonnet (25 min)

```
> Shift+Tab (Normal)
> /model sonnet
> "Implementa paso 1: Modelos de datos"
> "Implementa paso 2: Repositorio de BD"
> "Implementa paso 3: Servicio de email"
> "Implementa paso 4: Servicio de ordenes"
> "Implementa paso 5: Validacion"
> "Implementa paso 6: Tests"
> "Ejecuta tests"
```

---

## Paso 3: Verificar (5 min)

```
> "Compara la funcionalidad del codigo refactorizado con el original.
>  Verifica que no se perdio ninguna funcionalidad."
> "Ejecuta todos los tests"
> /cost
```

---

## Metricas

| Metrica | Antes | Despues |
|---------|-------|---------|
| Archivos | 1 | ? |
| Funciones/clases | 2 | ? |
| SQL injections | 2+ | 0 |
| except: pass | 2 | 0 |
| Magic numbers | muchos | 0 |
| Tests | 0 | ? |
| Tokens totales | - | ? |
| Coste total | - | $? |

---

## Criterios de Completitud

- [ ] Codigo legacy copiado y problemas identificados
- [ ] Plan de refactoring disenado con Opus
- [ ] Refactoring implementado con Sonnet
- [ ] SQL injection eliminada
- [ ] Responsabilidades separadas (minimo 3 archivos)
- [ ] Tests escritos y pasando
- [ ] Metricas documentadas
