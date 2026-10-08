# Roteiro do seminário (~10 minutos)

Use junto com `apresentacao.html`. Um integrante pode narrar; outros podem mostrar o glot.io na demo.

---

### Slide 1 — Capa (30 s)
Apresentem o tema **F3**, digam que o trabalho é no **paradigma funcional**, linguagem **Elixir**, roda no **glot.io**, disciplina do professor **Cid**.

### Slide 2 — Integrantes (30 s)
Leiam os nomes rapidamente ou mostrem o slide e sigam.

### Slide 3 — O que o tema pede (1 min)
Expliquem: estrutura aninhada tipo JSON → funções recursivas que **renomeiam**, **extraem** e **achatam**, usando **pattern matching** e não `if` de tipo.

### Slide 4 — Paradigma funcional (1 min)
Imutabilidade, funções, recursão. A árvore JSON “pede” recursão: cada nó tem a mesma forma de problema nos filhos.

### Slide 5 — Por que Elixir (1 min)
Mapas e listas = JSON. Guards `when is_map` / `when is_list`. Três cláusulas = mapa, lista, folha.

### Slide 6 — Pattern matching × if (1–1,5 min)
Contraste: no imperativo você pergunta “é mapa?”; no Elixir você **declara casos**. O runtime escolhe a cláusula. Esse é o ponto central do tema.

### Slide 7 — Estrutura de exemplo (45 s)
Mostrem o dado: usuário com contato aninhado + lista de pedidos. É o “JSON” que vão transformar.

### Slide 8 — Renomear (1 min)
Explicitem: desce na árvore, consulta regras, troca a chave, chama de novo no valor. Caso base = valor atômico devolve igual.

### Slide 9 — Extrair (1 min)
Pin `^chave_alvo`: só quando a chave bate, guarda o valor. Continua descendo (pode haver a mesma chave mais fundo). Resultado esperado: preços `[45.9, 3.5]`.

### Slide 10 — Achatar (1 min)
Caminhos com ponto; listas com índice. Útil para “desaninhar” e inspecionar tudo de uma vez.

### Slide 11 — Recursão (45 s)
Recebe nó → matching → filhos ou caso base → monta resultado. A **forma dos dados** guia o algoritmo.

### Slide 12 — Demo glot.io (2 min) — **parte prática**
Abram https://glot.io/new/elixir, colem `transformador.exs`, Run. Mostrem as saídas numeradas 1–5. Se der tempo, alterem uma regra de rename e rodem de novo.

### Slide 13 — Comparação de paradigmas (45 s)
Imperativo/OO: loops, typeof, estado. Funcional: cláusulas, imutabilidade, transformação pura.

### Slide 14 — Conclusões (45 s)
Recapitulam os 4–5 bullets do slide.

### Slide 15 — Perguntas (30 s)
Agradecem e abrem para perguntas.

---

## Possíveis perguntas do professor (respostas curtas)

**Por que não usar `if`?**  
Porque o tema exige pattern matching; em Elixir o matching por cláusula é o idioma idiomático e deixa cada caso isolado.

**O que é o caso base?**  
Quando o nó não é mapa nem lista (string, número, boolean…): a recursão para e devolve o valor (ou `[]` / caminho folha, conforme a função).

**Mapa em Elixir é igual a JSON?**  
Não é o mesmo formato de arquivo, mas a **estrutura** (objetos aninhados + arrays) é análoga; por isso o tema fala “tipo JSON”.

**O que é o pin `^`?**  
No pattern matching, `^variavel` significa “use o valor já existente”, não “crie uma variável nova”.
