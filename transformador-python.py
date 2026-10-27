# =============================================================================
# F3 — Transformador de estrutura tipo JSON
# Paradigma: Funcional / Orientado a Funções | Linguagem: Python
#
# UNICID — Paradigmas de Linguagens de Programação
# Prof. Cid Rodrigues De Andrade
#
# Grupo:
#    Gabriel Seren Franco            33696896
#    Gian Lucca Panzone              34014781
#    Giovanne Renato da Silva Vieira 33483019
#    Lucas Wu Hai Hua                33251380
#    Robson Luís Pereira de Almeida Mesquita 32871571
# =============================================================================

import json

class TransformadorJSON:
    """
    Percorre e transforma estruturas aninhadas semelhantes a JSON
    (dicionários dentro de dicionários, listas dentro de dicionários) 
    usando funções recursivas.
    """

    # ---------------------------------------------------------------------------
    # 1. RENOMEAR CHAVES
    # Percorre a árvore e troca nomes de chaves conforme um dicionário de regras.
    # Ex.: {"nome": "name", "idade": "age"}
    # ---------------------------------------------------------------------------
    @staticmethod
    def renomear_chaves(estrutura, regras):
        if isinstance(estrutura, dict):
            return {
                regras.get(k, k): TransformadorJSON.renomear_chaves(v, regras)
                for k, v in estrutura.items()
            }
        elif isinstance(estrutura, list):
            return [TransformadorJSON.renomear_chaves(item, regras) for item in estrutura]
        else:
            # Caso base: valor atômico (str, int, float, bool, NoneType)
            return estrutura

    # ---------------------------------------------------------------------------
    # 2. EXTRAIR VALORES
    # Coleta todos os valores associados a uma chave, em qualquer profundidade.
    # ---------------------------------------------------------------------------
    @staticmethod
    def extrair_valores(estrutura, chave_alvo):
        resultados = []
        if isinstance(estrutura, dict):
            for k, v in estrutura.items():
                if k == chave_alvo:
                    resultados.append(v)
                    resultados.extend(TransformadorJSON.extrair_valores(v, chave_alvo))
                else:
                    resultados.extend(TransformadorJSON.extrair_valores(v, chave_alvo))
        elif isinstance(estrutura, list):
            for item in estrutura:
                resultados.extend(TransformadorJSON.extrair_valores(item, chave_alvo))
        return resultados

    # ---------------------------------------------------------------------------
    # 3. ACHATAR A ÁRVORE (flatten)
    # Converte a estrutura aninhada em um dicionário "plano" com chaves compostas.
    # Ex.: {"usuario": {"nome": "Ana"}}  →  {"usuario.nome": "Ana"}
    # Listas usam índice: "itens.0", "itens.1", …
    # ---------------------------------------------------------------------------
    @staticmethod
    def achatar(estrutura, prefixo=""):
        resultado = {}
        
        def _achatar(obj, pref):
            if isinstance(obj, dict):
                for k, v in obj.items():
                    caminho = f"{pref}.{k}" if pref else str(k)
                    _achatar(v, caminho)
            elif isinstance(obj, list):
                for indice, item in enumerate(obj):
                    caminho = f"{pref}.{indice}" if pref else str(indice)
                    _achatar(item, caminho)
            else:
                resultado[pref] = obj

        _achatar(estrutura, prefixo)
        return resultado

    # ---------------------------------------------------------------------------
    # 4. TRANSFORMAR VALORES (bônus didático)
    # Aplica uma função a cada folha da árvore, preservando a estrutura.
    # ---------------------------------------------------------------------------
    @staticmethod
    def mapear_folhas(estrutura, fun):
        if isinstance(estrutura, dict):
            return {k: TransformadorJSON.mapear_folhas(v, fun) for k, v in estrutura.items()}
        elif isinstance(estrutura, list):
            return [TransformadorJSON.mapear_folhas(item, fun) for item in estrutura]
        else:
            return fun(estrutura)

    # ---------------------------------------------------------------------------
    # 5. CONTAR NÓS
    # ---------------------------------------------------------------------------
    @staticmethod
    def contar_nos(estrutura):
        if isinstance(estrutura, dict):
            return 1 + sum(TransformadorJSON.contar_nos(v) for v in estrutura.values())
        elif isinstance(estrutura, list):
            return 1 + sum(TransformadorJSON.contar_nos(item) for item in estrutura)
        else:
            return 1


# =============================================================================
# DEMONSTRAÇÃO — dados de exemplo e resultados
# =============================================================================

if __name__ == "__main__":
    print("=" * 60)
    print("  F3 — Transformador de estrutura tipo JSON (Python)")
    print("=" * 60)

    dados = {
        "usuario": {
            "nome": "Ana Silva",
            "idade": 28,
            "contato": {
                "email": "ana@email.com",
                "telefone": "11999998888"
            }
        },
        "pedidos": [
            {"id": 1, "produto": "Livro", "preco": 45.90},
            {"id": 2, "produto": "Caneta", "preco": 3.50}
        ],
        "ativo": True
    }

    print("\n--- ESTRUTURA ORIGINAL ---")
    print(json.dumps(dados, indent=2, ensure_ascii=False))

    # 1) Renomear chaves (pt → en)
    regras = {
        "nome": "name",
        "idade": "age",
        "contato": "contact",
        "email": "email",
        "telefone": "phone",
        "usuario": "user",
        "pedidos": "orders",
        "produto": "product",
        "preco": "price",
        "ativo": "active",
        "id": "id"
    }

    renomeado = TransformadorJSON.renomear_chaves(dados, regras)
    print("\n--- 1) RENOMEAR CHAVES ---")
    print(json.dumps(renomeado, indent=2, ensure_ascii=False))

    # 2) Extrair todos os valores da chave "preco"
    precos = TransformadorJSON.extrair_valores(dados, "preco")
    print('\n--- 2) EXTRAIR VALORES da chave "preco" ---')
    print(precos)

    nomes = TransformadorJSON.extrair_valores(dados, "nome")
    print('Valores da chave "nome":')
    print(nomes)

    # 3) Achatar a árvore
    plano = TransformadorJSON.achatar(dados)
    print("\n--- 3) ACHATAR A ÁRVORE ---")
    print(json.dumps(plano, indent=2, ensure_ascii=False))

    # 4) Mapear folhas (ex.: strings em maiúsculas)
    maiusculas = TransformadorJSON.mapear_folhas(
        dados, 
        lambda s: s.upper() if isinstance(s, str) else s
    )
    print("\n--- 4) MAPEAR FOLHAS (strings → MAIÚSCULAS) ---")
    print(json.dumps(maiusculas, indent=2, ensure_ascii=False))

    # 5) Contar nós
    total = TransformadorJSON.contar_nos(dados)
    print("\n--- 5) CONTAR NÓS ---")
    print(f"Total de nós na árvore: {total}")

    print("\n" + "=" * 60)
    print("  Fim da demonstração — recursão + comprehensions ✓")
    print("=" * 60)
