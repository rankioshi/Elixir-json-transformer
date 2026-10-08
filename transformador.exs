# =============================================================================
# F3 — Transformador de estrutura tipo JSON
# Paradigma: Funcional | Linguagem: Elixir | Ambiente: glot.io
#
# UNICID — Paradigmas de Linguagens de Programação
# Prof. Cid Rodrigues De Andrade
#
# Grupo:
#   Gabriel Seren Franco          33696896
#   Gian Lucca Panzone            34014781
#   Giovanne Renato da Silva Vieira 33483019
#   Lucas Wu Hai Hua              33251380
#   Robson Luís Pereira de Almeida Mesquita 32871571
# =============================================================================

defmodule TransformadorJSON do
  @moduledoc """
  Percorre e transforma estruturas aninhadas semelhantes a JSON
  (mapas dentro de mapas, listas dentro de mapas) usando funções
  recursivas e pattern matching — sem ifs explícitos checando o tipo.
  """

  # ---------------------------------------------------------------------------
  # 1. RENOMEAR CHAVES
  # Percorre a árvore e troca nomes de chaves conforme um mapa de regras.
  # Ex.: %{"nome" => "name", "idade" => "age"}
  # ---------------------------------------------------------------------------

  def renomear_chaves(mapa, regras) when is_map(mapa) do
    mapa
    |> Enum.map(fn {chave, valor} ->
      nova_chave = Map.get(regras, chave, chave)
      {nova_chave, renomear_chaves(valor, regras)}
    end)
    |> Map.new()
  end

  def renomear_chaves(lista, regras) when is_list(lista) do
    Enum.map(lista, fn item -> renomear_chaves(item, regras) end)
  end

  # Caso base: valor atômico (string, número, booleano, nil, átomo…)
  def renomear_chaves(valor, _regras), do: valor

  # ---------------------------------------------------------------------------
  # 2. EXTRAIR VALORES
  # Coleta todos os valores associados a uma chave, em qualquer profundidade.
  # ---------------------------------------------------------------------------

  def extrair_valores(mapa, chave_alvo) when is_map(mapa) do
    Enum.flat_map(mapa, fn
      {^chave_alvo, valor} ->
        [valor | extrair_valores(valor, chave_alvo)]

      {_outra, valor} ->
        extrair_valores(valor, chave_alvo)
    end)
  end

  def extrair_valores(lista, chave_alvo) when is_list(lista) do
    Enum.flat_map(lista, fn item -> extrair_valores(item, chave_alvo) end)
  end

  def extrair_valores(_valor, _chave_alvo), do: []

  # ---------------------------------------------------------------------------
  # 3. ACHATAR A ÁRVORE (flatten)
  # Converte a estrutura aninhada em um mapa "plano" com chaves compostas.
  # Ex.: %{"usuario" => %{"nome" => "Ana"}}  →  %{"usuario.nome" => "Ana"}
  # Listas usam índice: "itens.0", "itens.1", …
  # ---------------------------------------------------------------------------

  def achatar(estrutura), do: achatar(estrutura, "")

  defp achatar(mapa, prefixo) when is_map(mapa) do
    mapa
    |> Enum.flat_map(fn {chave, valor} ->
      caminho = juntar_caminho(prefixo, to_string(chave))
      achatar(valor, caminho)
    end)
    |> Map.new()
  end

  defp achatar(lista, prefixo) when is_list(lista) do
    lista
    |> Enum.with_index()
    |> Enum.flat_map(fn {item, indice} ->
      caminho = juntar_caminho(prefixo, Integer.to_string(indice))
      achatar(item, caminho)
    end)
    |> Map.new()
  end

  # Folha: associa o caminho completo ao valor atômico
  defp achatar(valor, prefixo), do: [{prefixo, valor}]

  defp juntar_caminho("", chave), do: chave
  defp juntar_caminho(prefixo, chave), do: prefixo <> "." <> chave

  # ---------------------------------------------------------------------------
  # 4. TRANSFORMAR VALORES (bônus didático)
  # Aplica uma função a cada folha da árvore, preservando a estrutura.
  # ---------------------------------------------------------------------------

  def mapear_folhas(mapa, fun) when is_map(mapa) do
    mapa
    |> Enum.map(fn {chave, valor} -> {chave, mapear_folhas(valor, fun)} end)
    |> Map.new()
  end

  def mapear_folhas(lista, fun) when is_list(lista) do
    Enum.map(lista, fn item -> mapear_folhas(item, fun) end)
  end

  def mapear_folhas(valor, fun), do: fun.(valor)

  # ---------------------------------------------------------------------------
  # 5. CONTAR NÓS — demonstra o pattern matching por cláusula
  # ---------------------------------------------------------------------------

  def contar_nos(mapa) when is_map(mapa) do
    1 + Enum.reduce(mapa, 0, fn {_k, v}, acc -> acc + contar_nos(v) end)
  end

  def contar_nos(lista) when is_list(lista) do
    1 + Enum.reduce(lista, 0, fn item, acc -> acc + contar_nos(item) end)
  end

  def contar_nos(_folha), do: 1
end

# =============================================================================
# DEMONSTRAÇÃO — dados de exemplo e resultados
# =============================================================================

IO.puts("=" |> String.duplicate(60))
IO.puts("  F3 — Transformador de estrutura tipo JSON (Elixir)")
IO.puts("=" |> String.duplicate(60))

dados = %{
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

IO.puts("\n--- ESTRUTURA ORIGINAL ---")
IO.inspect(dados, pretty: true, limit: :infinity)

# 1) Renomear chaves (pt → en)
regras = %{
  "nome" => "name",
  "idade" => "age",
  "contato" => "contact",
  "email" => "email",
  "telefone" => "phone",
  "usuario" => "user",
  "pedidos" => "orders",
  "produto" => "product",
  "preco" => "price",
  "ativo" => "active",
  "id" => "id"
}

renomeado = TransformadorJSON.renomear_chaves(dados, regras)
IO.puts("\n--- 1) RENOMEAR CHAVES ---")
IO.inspect(renomeado, pretty: true, limit: :infinity)

# 2) Extrair todos os valores da chave "preco"
precos = TransformadorJSON.extrair_valores(dados, "preco")
IO.puts("\n--- 2) EXTRAIR VALORES da chave \"preco\" ---")
IO.inspect(precos)

nomes = TransformadorJSON.extrair_valores(dados, "nome")
IO.puts("Valores da chave \"nome\":")
IO.inspect(nomes)

# 3) Achatar a árvore
plano = TransformadorJSON.achatar(dados)
IO.puts("\n--- 3) ACHATAR A ÁRVORE ---")
IO.inspect(plano, pretty: true, limit: :infinity)

# 4) Mapear folhas (ex.: strings em maiúsculas)
maiusculas =
  TransformadorJSON.mapear_folhas(dados, fn
    s when is_binary(s) -> String.upcase(s)
    outro -> outro
  end)

IO.puts("\n--- 4) MAPEAR FOLHAS (strings → MAIÚSCULAS) ---")
IO.inspect(maiusculas, pretty: true, limit: :infinity)

# 5) Contar nós
total = TransformadorJSON.contar_nos(dados)
IO.puts("\n--- 5) CONTAR NÓS ---")
IO.puts("Total de nós na árvore: #{total}")

IO.puts("\n" <> ("=" |> String.duplicate(60)))
IO.puts("  Fim da demonstração — pattern matching + recursão ✓")
IO.puts("=" |> String.duplicate(60))
