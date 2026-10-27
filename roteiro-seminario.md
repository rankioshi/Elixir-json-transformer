# Roteiro do seminário (~12–14 minutos)

Use junto com `apresentacao.html`. Um integrante pode narrar; outros podem mostrar o glot.io na demo.

---

### Slide 1 — Capa (30 s)
Apresentem o tema: transformador de estrutura tipo JSON, **paradigma funcional**, linguagem **Elixir**, demo no **glot.io**, disciplina do professor **Cid**.

### Slide 2 — Integrantes (30 s)
Leiam os nomes rapidamente ou mostrem o slide e sigam.

### Slide 3 — O problema (1,5–2 min)
1. Estrutura aninhada tipo JSON (mapas + listas).
2. Funções **recursivas** que **renomeiam**, **extraem** e **achatam**.
3. Abordagem: **pattern matching** sobre a estrutura — não `if` de tipo.

Falem que o “JSON” aqui é o modelo mental (objetos/arrays aninhados), não o arquivo `.json` em si.

### Slide 4 — Paradigma funcional na prática (1,5 min)
Expliquem o que o funcional muda na solução:
- Recursão percorre a árvore (sem loop mutável).
- Imutabilidade: transformação devolve estrutura nova.
- Funções puras: dá para testar e compor.
- Despacho pela **forma dos dados** (mapa / lista / folha).

### Slide 5 — Nuances do Elixir (1,5 min)
Mostrem recursos usados:
- Várias cláusulas `def` + ordem importa.
- Guards `when is_map` / `when is_list`.
- Mapas/listas modelando JSON.
- Pin `^` e `Enum.map` / `flat_map`.
- Fechem no snippet das três cláusulas.

### Slide 6 — Pattern matching × ifs (2 min) — **ponto forte**
Contraste imperativo vs cláusulas. Depois mostrem o matching **no corpo** (`{^chave_alvo, valor}`). Enfatizem: guards na cabeça ≠ `if` no algoritmo; caso base explícito.

### Slide 7 — Estrutura de exemplo (45 s)
Mostrem o dado: usuário com contato aninhado + lista de pedidos. É o “JSON” que vão transformar.

### Slide 8 — Renomear (1 min)
Explicitem: desce na árvore, consulta regras, troca a chave, chama de novo no valor. Caso base = valor atômico devolve igual.

### Slide 9 — Extrair (1 min)
Pin `^chave_alvo`: só quando a chave bate, guarda o valor. Continua descendo (pode haver a mesma chave mais fundo). Resultado esperado: preços `[45.9, 3.5]`.

### Slide 10 — Achatar · ideia (1,5 min) — **ponto forte**
Mostrem o antes/depois. Expliquem os três passos: mapa (ponto), lista (índice), folha (para). Digam para que serve (inspecionar, serializar caminhos).

### Slide 11 — Achatar · código (1,5 min)
Caminhem pelo código: API pública com prefixo `""`, `flat_map`, `with_index`, `juntar_caminho`. Removem que é o mesmo padrão de três cláusulas das outras funções.

### Slide 12 — Recursão (45 s)
Recebe nó → matching → filhos ou caso base → monta resultado. A **forma dos dados** guia o algoritmo.

### Slide 13 — Demo glot.io (2 min) — **parte prática**
Abram https://glot.io/new/elixir, colem `transformador.exs`, Run. Mostrem as saídas numeradas 1–5. Se der tempo, alterem uma regra de rename e rodem de novo.

### Slide 14 — Comparação de paradigmas (45 s)
Imperativo/OO: loops, typeof, estado. Funcional: cláusulas, imutabilidade, transformação pura.

### Slide 15 — Conclusões (45 s)
Recapitulam os 4–5 bullets do slide.

### Slide 16 — Perguntas (30 s)
Agradecem e abrem para perguntas.

---

## Possíveis perguntas do professor (respostas curtas)

**Por que não usar `if`?**  
Porque o matching por cláusula é o idioma idiomático em Elixir e deixa cada caso (mapa / lista / folha) isolado — sem ramificar com `if` de tipo.

**O que é o caso base?**  
Quando o nó não é mapa nem lista (string, número, boolean…): a recursão para e devolve o valor (ou `[]` / caminho folha, conforme a função).

**Mapa em Elixir é igual a JSON?**  
Não é o mesmo formato de arquivo, mas a **estrutura** (objetos aninhados + arrays) é análoga; por isso o tema fala “tipo JSON”.

**O que é o pin `^`?**  
No pattern matching, `^variavel` significa “use o valor já existente”, não “crie uma variável nova”.

**Por que índice na lista no flatten?**  
Listas não têm chave nomeada; o índice preserva a posição de cada elemento no caminho (`pedidos.0.preco`).
