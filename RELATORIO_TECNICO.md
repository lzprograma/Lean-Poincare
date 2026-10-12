# Relatório técnico — Projeto Poincaré

Data: 12/10/2026

## 1. Resumo

Fonte: https://github.com/frenzymath/PoincareConjecture, commit `62db01af9388dc1d9b56b66d6674f4c09b2318a2`.

Nenhum arquivo `.lean` foi alterado. O projeto foi obtido, inspecionado estaticamente e empacotado. **A compilação não foi executada.** Portanto, esta entrega NÃO está verificada pelo Lean por mim. O que é afirmado abaixo se limita ao que foi observado.

## 2. Versões fixadas (lean-toolchain, lakefile.toml)

- Lean: `leanprover/lean4:v4.33.1` (instalado e confirmado: 4.33.1, commit 819816b2e0a3bf405af45ae5c7af2491d8f5bee6)
- Lake: 5.0.0
- Mathlib: rev `0df444a360eaa60ab8c11dca51a86af692955474`
- Comparator: rev `3927ad383f208ae977c340a91c48ac9b497d2097`
- lean4export: rev `15f6055e299ad5b89345e533cc2192f4cc00f659`
- Demais dependências (plausible, LeanSearchClient, importGraph, proofwidgets, aesop, Qq, batteries, Cli) fixadas em `lake-manifest.json`.

## 3. Estrutura

- 23.560 arquivos `.lean`, ~3,06 milhões de linhas (`PoincareLib`, ~203 MB de fonte).
- Enunciados: `PoincareConjecture/Statement.lean` (somente Mathlib): `SmoothPoincare` e `TopologicalPoincare`.
- Teoremas finais: `PoincareMT.smoothPoincareSkeleton` e `PoincareMT.topologicalPoincareSkeleton` em `PoincareLib/Topology/Manifold/Poincare.lean`, reexportados em `PoincareConjecture/Proofs/Main.lean` e `Comparator/Solution.lean`.
- Os dois teoremas finais não recebem hipóteses adicionais; provam exatamente `SmoothPoincare.{u}` e `TopologicalPoincare.{u}`.
- Enunciado: M compacta, T2, segundo-enumerável, localmente euclidiana de dimensão 3 (suave com `IsManifold (𝓡 3) ∞` no caso suave), `SimplyConnectedSpace` ⇒ difeomorfa/homeomorfa a `Metric.sphere (0 : EuclideanSpace ℝ (Fin 4)) 1`. Corresponde às Corolário 0.2 de Morgan–Tian. Não há versão enfraquecida à vista. A elaboração do enunciado pelo Lean não foi testada por mim.

## 4. Verificações executadas (e resultados observados)

| Verificação | Resultado |
|---|---|
| Clone do repositório | OK |
| Instalação do Lean 4.33.1 (tarball oficial do GitHub Releases) | OK, `lean --version` confirmado |
| `grep` de `sorry` como token em `PoincareLib`, `PoincareConjecture`, `Comparator` | 0 ocorrências (exceto os 2 `sorry` propositais de `Comparator/Challenge.lean`, que são os enunciados a serem verificados) |
| `sorryAx`, `unsafe`, `implemented_by`/`extern`/`csimp`, `native_decide`/`ofReduceBool`, `#exit`, `skipKernelTC`/`debug.`, `maxHeartbeats 0` | 0 arquivos |
| Declarações `axiom`/`opaque` | 0 |
| `macro`/`elab`/`syntax`/`run_cmd`/`initialize` (código meta) | 0 de código real; as ocorrências de "initialize" e "import cycle" são prosa em docstrings |
| `import Lean...` | 1 arquivo: `import Lean.Elab.Tactic.Omega` (tático `omega`, legítimo) |
| Imports externos | somente `Mathlib` e os próprios módulos do projeto |

Limitação desta auditoria: é textual. Ela não substitui `#print axioms` nem o kernel. Um grep não detecta, por exemplo, um enunciado enfraquecido dentro de uma definição usada na cadeia da prova. Somente a compilação e o Comparator fecham essa questão.

## 5. Verificações NÃO executadas

- `lake exe cache get`, `lake build`, `#print axioms`, Comparator (kernel do Lean e Nanoda).

Motivo (limitação real de infraestrutura):

1. O sandbox bloqueia os hosts do cache de Mathlib (`lakecache.blob.core.windows.net`, `mathlib4.lean-cache.cloud`, `cache.mathlib.community`) e `release.lean-lang.org`/`reservoir.lean-lang.org`. O `elan` não consegue instalar o toolchain pelo caminho padrão; contornei baixando o tarball no GitHub.
2. Sem cache, seria preciso compilar o Mathlib (milhares de arquivos) mais ~23,5 mil arquivos do `PoincareLib` com 1 CPU, 3 GB de RAM e ~6,9 GB de disco livre. Não é viável. Mesmo com o cache, o `PoincareLib` exige máquina com muito mais recursos; o README do Comparator menciona 32 threads para o Nanoda e maior consumo de memória.

## 6. Componentes

- Aprovados (verificados por compilação): nenhum.
- Verificados apenas estaticamente: ausência de `sorry`/axiomas/mecanismos de bypass listados na seção 4; coerência dos enunciados.
- Não verificados: toda a prova (compilação, axiomas, Comparator).
- Erros encontrados: nenhum (não houve compilação que pudesse revelá-los).
- Correções aplicadas: nenhuma.

## 7. Observações importantes

- O próprio README e o `MODIFICATIONS.md` do repositório dizem que o PR de importação não rodou build nem Comparator, e remetem a um relatório de verificação do repositório de origem (`frenzymath/Poincare-Conjecture`), que cita uma execução bem-sucedida com um pequeno patch de ordem de execução no Comparator. Não reproduzi nem validei essa alegação.
- Comentários: o projeto contém docstrings e cabeçalhos de atribuição Apache-2.0. A licença exige preservar esses avisos; por isso não os removi. Remoção em massa de comentários sem um removedor ciente da sintaxe do Lean também arriscaria quebrar a compilação sem como validá-la aqui. Se quiser uma variante sem comentários, ela deve ser gerada e compilada numa máquina com recursos adequados, mantendo `LICENSES/` e `NOTICE`.
- Os nomes `...Skeleton` são herdados do repositório de origem. Não há evidência aqui de que signifiquem uma versão parcial, pois os tipos coincidem com os enunciados completos, mas essa conclusão depende da compilação.
- Esta formalização é de grande escala e de origem em grande parte assistida por IA. Nenhum resultado de outra IA deve ser tomado como prova; a verificação confiável é o kernel do Lean + Comparator.

## 8. Como verificar (máquina adequada)

Recomendado: Linux x86_64, 32+ GB de RAM, múltiplos núcleos, acesso à internet sem bloqueio do cache de Mathlib e muitas dezenas de GB de disco.

```
./verificar.sh
```

O script instala o `elan` se necessário, instala o toolchain `v4.33.1`, baixa o cache do Mathlib, constrói `PoincareLib` e `PoincareConjecture`, constrói `Challenge`, `Solution`, Comparator e lean4export, e imprime `#print axioms` dos dois teoremas finais. Os axiomas esperados são apenas `propext`, `Classical.choice`, `Quot.sound`.

Para rodar o Comparator (Landrun e Nanoda necessários), siga `Comparator/README.md`. Sucesso exige as três mensagens: `Nanoda kernel accepts the solution`, `Lean default kernel accepts the solution` e `Your solution is okay!`.

Integridade: `MANIFEST.sha256` lista o SHA-256 de todos os `.lean`; conferir com `sha256sum -c MANIFEST.sha256`.

## 9. Pendências

1. Executar a seção 8 em infraestrutura adequada e anexar a saída.
2. Se `#print axioms` mostrar algo além dos três axiomas padrão, ou se o Comparator falhar, isolar o módulo e corrigir especificamente.
3. Decidir sobre a variante sem comentários (seção 7).
