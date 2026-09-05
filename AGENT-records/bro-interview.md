# Entrevista técnica (set del hermano de Diego)

Referencia continua de estudio (sin fecha: es compendio, no una sesión). Set de preguntas
que Diego recibió de su hermano (Vanzuh) como preparación para una prueba técnica / entrevista.

---

## Preguntas antes de la prueba técnica

- ¿Cuántos años de experiencia laboral tienes como programador?
- ¿Cuántos años de experiencia tienes en JavaScript y en TypeScript?
- ¿Qué nivel consideras que tienes con JavaScript y TypeScript?

## Preguntas técnicas (JS/TS)

1. ¿Cuál es la diferencia entre JavaScript y TypeScript?
2. ¿Puede el navegador interpretar TypeScript?
3. ¿Para qué se utiliza el `tsconfig.json`?
4. ¿Qué son las promesas y para qué se usan? ¿Cuáles son los estados de las promesas?
5. ¿Cuál es la diferencia entre los métodos `find` y `filter`?
6. ¿Qué es un genérico? ¿Cómo se utiliza?
7. ¿Cuál es la diferencia entre `null` y `undefined`?
8. ¿Cuál es la diferencia entre `void` y `never`?
9. ¿Para qué sirve el rest params (`...args`)?
10. `function` vs arrow function: diferencias (incluye `this`, `arguments`, hoisting).

Extras (del mismo chat):

- ¿El navegador puede interpretar SCSS?
- IIFE: ¿qué es y para qué se usa?
- `Promise.all` vs `Promise.allSettled`.
- `map` vs `forEach`.
- Operadores estrictos: `1 === 1` → `true`; `1 === 0` → `false`.

## Ejercicio con scope (`let` vs `var`)

```js
function example() {
  let x = 71;
  var y = 71;
  if (true) {
    let x = 31;
    var y = 31;
    console.log(x); // 31
    console.log(y); // 31
  }
  console.log(x); // 71 (let tiene scope de bloque)
  console.log(y); // 31 (var tiene scope de función y se redeclara)
}
```

## Prueba técnica de la casa

- Crear una **todo app** integrando una API que la empresa ofrece.

## Referencias de estudio (relacionadas)

- Video: "El fin de la burbuja: ¿Por qué la IA no reemplaza programadores?" — MoureDev
  (<https://youtu.be/CauENcmaL80?si=m0wU526rCFIC-jDg>).

---

## Notas del Profesor (para ir dominando cada pregunta)

- **JS vs TS:** TS es un superset; agrega tipos en tiempo de compilación, no runtime.
- **Navegador y TS:** no interpreta TS; necesita transpilación (tsc, esbuild, vite).
- **`tsconfig.json`:** configura el compilador (target, strict, module, paths, etc.).
- **Promesas:** estados `pending`, `fulfilled`, `rejected`.
- **`find` vs `filter`:** `find` devuelve el primer elemento que cumple (o `undefined`);
  `filter` devuelve un array con todos los que cumplen.
- **Genéricos:** parametrizan tipos (ej. `Promise<T>`, `Array<T>`, `Response<T>`).
- **`null` vs `undefined`:** `null` es un valor asignable explícito ("vacío");
  `undefined` significa "no asignado todavía".
- **`void` vs `never`:** `void` = no devuelve valor útil; `never` = nunca termina/lanza.
- **Rest params:** agrupa argumentos sobrantes en un array.
- **`function` vs arrow:** la arrow no tiene `this` propio (hereda del contexto léxico)
  ni objeto `arguments`; las `function` sí.
