# Avaliação A2 - Paradigmas de Linguagens de Programação

> Este arquivo é o esqueleto do **README.md** do repositório GitHub do seu grupo.
> A Entrega deve ser feita exclusivamente pelo envio do link desse repositório.
> Quaisquer instruções anteriores em desacordo com esta devem ser ignoradas
> Preencha cada seção abaixo. Não altere a ordem e nem apague os títulos — apenas substitua os placeholders pelo conteúdo do seu projeto.

**Grupo 05**

## 👥 Integrantes (3 a 5 alunos)
- Gabriel Seren Franco (33696896)
- Gian Lucca Panzone (34014781)
- Giovanne Renato da Silva Vieira (33483019)
- Lucas Wu Hai Hua (33251380)
- Robson Luís Pereira de Almeida Mesquita (32871571)

## Definição do Tema
- **Paradigma:** Funcional
- **Linguagem:** Elixir
- **Código do Tema:** F3
- **Descrição do Desafio:** Transformador de estrutura tipo JSON. Dada uma estrutura de dados aninhada (mapas dentro de mapas, listas dentro de mapas), o desafio é escrever funções recursivas que utilizem *pattern matching* sobre a estrutura para: renomear chaves em qualquer profundidade, extrair valores associados a uma chave e achatar (flatten) a árvore em um mapa plano, sem usar `ifs` explícitos checando o tipo de cada nó.

## Execução do Código

> ⚠️ **Aviso:** O código deve rodar exclusivamente em ambiente online, sem necessidade de instalação local.

- **Ambiente Online Utilizado:** glot.io
- **Permalink:** https://glot.io/snippets/hmzmjcg0z9

### Instruções de Teste (Entrada e Saída)
1. Acesse o link permanente fornecido acima (recomendado abrir em aba anônima para testar).
2. O código fonte já estará carregado no editor.
3. Clique no botão **"Run"** na interface do glot.io.
4. O console exibirá a estrutura original seguida pelas transformações (renomear, extrair e achatar) geradas na saída.

**Entrada de Exemplo:**
```elixir
%{
  "usuario" => %{
    "nome" => "Ana Silva",
    "idade" => 28,
    "contato" => %{
      "email" => "ana@email.com",
      "telefone" => "11999998888"
    }
  },
  "pedidos" => [
    %{"id" => 1, "produto" => "Livro", "preco" => 45.90},
    %{"id" => 2, "produto" => "Caneta", "preco" => 3.50}
  ],
  "ativo" => true
}
```

**Saída Esperada:**
```text
(Resumo das saídas no console)
- Chaves renomeadas em inglês (ex: "nome" para "name", "usuario" para "user").
- Extração de valores: [45.9, 3.5] ao buscar a chave "preco".
- Mapa achatado (flatten) contendo caminhos literais como "usuario.contato.email" e índices para listas como "pedidos.0.preco".
```

## Relatório Técnico

### Descrição da Solução
A solução adotada abraça completamente o paradigma funcional, utilizando a recursão como motor para navegar na árvore de dados (o JSON) e *pattern matching* em conjunto com *guards* (`when is_map`, `when is_list`) para tomar decisões de fluxo, sem o uso de `if/else`. 
O código declara três cláusulas distintas para cada operação: uma tratando caso o nó seja um mapa, outra caso seja uma lista e uma terceira para nós-folha (valores finais). 
*   **Renomear chaves:** A função percorre os pares; se a chave constar nas regras de tradução, ela é substituída e a função é chamada recursivamente nos valores-filho.
*   **Extrair valores:** Usa o operador pin (`^chave_alvo`) para exigir igualdade no matching, agregando os valores encontrados numa lista enquanto varre todos os níveis.
*   **Achatar (flatten):** Converte as chaves aninhadas concatenando strings com ponto (`.`) e usa os índices numéricos quando o nó é uma lista. A imutabilidade é garantida em todo o processo, produzindo uma nova estrutura de saída baseada na original sem modificar estado global.

### Análise Comparativa

### 1. Sintaxe
A linguagem Elixir é substancialmente mais declarativa. Enquanto em linguagens imperativas como Java ou C seríamos obrigados a escrever lógicas aninhadas como `if (no instanceof Map) { ... } else if (no instanceof List) { ... }`, em Elixir a sintaxe permite criar assinaturas de função distintas (cláusulas) que determinam a execução com base na forma do dado (`def f(no) when is_map(no) do ...`). O *runtime* é quem escolhe a cláusula certa. O código descreve o *que* fazer em cada situação, e não *como* checar a cada passo.

### 2. Semântica
Existem grandes diferenças em relação à avaliação e manipulação dos dados. No paradigma funcional, os dados são imutáveis: não se altera uma chave de um objeto existente (como uma atribuição imperativa faria em Python), mas sim, retorna-se um novo mapa modificado a cada iteração da recursão. Além disso, o Elixir utiliza unificação/*pattern matching* de forma nativa para desestruturar coleções logo na assinatura das funções ou nos blocos de `Enum.map`, substituindo o uso extensivo de `gets` e `sets` tradicionais de orientação a objetos.

### 3. Gerenciamento de Memória
Como Elixir roda na Erlang VM (BEAM), o gerenciamento de memória conta com um *Garbage Collector* automático, porém muito eficiente, operando por processo. Ao comparar com C — onde a locação manual com `malloc`/`free` para árvores aninhadas geraria risco alto de vazamentos de memória (memory leaks) — o Elixir lida graciosamente com isso. Como as variáveis são imutáveis e os dados apenas sofrem transformações sendo referenciados novamente, a máquina virtual consegue desalocar pequenos pedaços de memória de curto ciclo de vida de maneira segura e independente.

### 4. Trade-offs
**Vantagens:** O paradigma funcional aplicado a este desafio traz um código extremamente seguro e livre de efeitos colaterais. É muito mais limpo ler e manter a lógica focada em "como agir dado este formato de nó", pois a separação por *pattern matching* elimina o emaranhado lógico de `ifs`.
**Desvantagens:** A criação contínua de novas estruturas durante a recursão profunda (devido à imutabilidade) pode ter um ligeiro *overhead* de consumo de memória se comparado a alterações "in-place" (mutação) em linguagens como C. Além disso, a curva de aprendizado inicial e a obrigatoriedade de pensar em recursão ao invés de laços iterativos simples (`for`/`while`) podem atrasar desenvolvedores com forte background exclusivamente imperativo.

### Resumo da Análise Comparativa
*   **Sintaxe:** Extremamente declarativa. O uso de *pattern matching* e *guards* nas assinaturas de função substitui cadeias de `if/else`, reduzindo verbosidade.
*   **Semântica:** Tipos imutáveis e funções puras. A desconstrução de mapas é feita nativamente por unificação de padrões no recebimento dos parâmetros.
*   **Gerenciamento de Memória:** Coleta de lixo automática operada pela VM (BEAM). Mais segura e simplificada pelo fato de os dados serem imutáveis, em forte contraste com a complexa alocação manual do C.
*   **Trade-offs:** Garante código previsível, declarativo e livre de efeitos colaterais. A desvantagem fica por conta da curva de aprendizado da recursão e um pequeno overhead pelo descarte da mutabilidade em memória.

## Log de Uso de Inteligência Artificial (IA)
*O uso de IA (ChatGPT, Claude, Gemini, etc.) é permitido e incentivado para aprendizado, mas deve ser documentado. Preencha o log abaixo:*

*   **O que foi pedido à IA:** [Substitua pelo seu prompt real. Ex: "Como usar o operador pin (^) em recursão de mapas no Elixir para filtrar chaves específicas?"]
*   **Qual IA foi utilizada:** [Ex: ChatGPT (GPT-4o) / Gemini 1.5 Pro]
*   **O que foi aproveitado:** [Ex: A explicação de que o operador `^` força a correspondência exata do valor da variável, o que foi usado na nossa função `extrair_valores`.]
*   **O que foi reescrito/entendido pelo grupo:** [Ex: O grupo adaptou o uso do `Enum.flat_map` sugerido pela IA para garantir que extrações aninhadas em listas mantivessem a estrutura em apenas 1 nível, entendendo finalmente o comportamento do "flatten".]