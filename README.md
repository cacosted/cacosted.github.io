# Proyectos de Cacosted

Catálogo de mis proyectos del canal y de Pokémon: https://cacosted.github.io/

## Agregar un proyecto

1. Toma la miniatura:

   ```bash
   tools/capturar.sh mi-proyecto https://cacosted.github.io/mi-proyecto/
   ```

2. Agrega una entrada en `proyectos.json`:

   ```json
   {
     "nombre": "Mi proyecto",
     "url": "https://cacosted.github.io/mi-proyecto/",
     "categoria": "canal",
     "descripcion": "Qué hace, en una o dos frases.",
     "miniatura": "thumbs/mi-proyecto.jpg",
     "repo": "cacosted/mi-proyecto"
   }
   ```

   `categoria` es `canal` (herramientas para hacer los videos), `pokemon` (helpers para jugar)
   o `diversion` (proyectos personales, fuera del canal). Cada una sale en su propia sección.

3. `git add -A && git commit -m "Agregar mi proyecto" && git push`. GitHub Pages lo publica en un minuto.

Para ver la página en local: `python3 -m http.server 8000` y abre http://localhost:8000.
