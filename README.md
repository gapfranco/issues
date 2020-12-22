# Issues

## Sumário

Projeto de executável em Elixir que busca e exibe em JSON as ultimas issues de um
projeto no Github. Implementação com algumas modificação do projeto de exemplo
do livro _Programming Elixir_ do _David Thomas_

A implementação do livro mostra uma tabela na tela. Foi alterado aqui para emitir
a saida em json com os mesmos campos.

## Implementação

- Instalar as dependências com `mix deps.get`
- Rodar `mix escript.build` para gerar o executável

Para fazer uma consulta:

`./issues usuario projeto [count]`

Onde _count_ é o numero máximo de issues que deseja mostrar (default 5)
