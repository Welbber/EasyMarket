:- module(carrinho, [printCarrinho/0, putProdutoNoCarrinho/4, removeProdutoDoCarrinho/1, clearCarrinho/0]).
:- use_module(library(csv)).


% Retorna o ultimo elemento de uma lista.
last(X,[X]).
last(X,[_|Z]) :- last(X,Z).

% Retorna o ultimo id de carrinhoDB.csv
getLastId(Id):-
   readCSV(File),
   last(row(X, _, _, _, _), File),
   (
      X == 'id' -> Id is 0;
      Id is X
   ).

% Fato dinâmico para gerar o id dos agentes
id(X) :- getLastId(LastId), X is LastId + 1.

% Lendo arquivo JSON puro
readCSV(File) :- csv_read_file('../db/carrinhoDB.csv', File).

% Regras para listar todos os produtos
printCarrinhoAux([]).
printCarrinhoAux([row(ID, Nome, Preco, Categoria, Quantidade)|T]) :-
   write("ID:"), writeln(ID),
   write("Produto: "), writeln(Nome),
   write("Preco: "), writeln(Preco),
   write("Categoria: "), writeln(Categoria),
   write("Quantidade: "), writeln(Quantidade), nl, printCarrinhoAux(T).

printCarrinho() :-
   readCSV([_|File]),
   printCarrinhoAux(File),
   print("Digite qualquer tecla para voltar..."),
   read(_).

% Salvar em arquivo CSV
putProdutoNoCarrinho(Nome, Preco, Categoria, Quantidade) :-
   id(ID),
   readCSV(File),
   append(File, [row(ID, Nome, Preco, Categoria, Quantidade)], Saida),
   csv_write_file("../db/carrinhoDB.csv", Saida).

% Removendo um agente
removeProdutoDoCarrinhoCSV([], _, []).
removeProdutoDoCarrinhoCSV([row(Id, _, _, _, _)|T], Id, T).
removeProdutoDoCarrinhoCSV([H|T], Id, [H|Out]) :- removeProdutoDoCarrinhoCSV(T, Id, Out).

removeProdutoDoCarrinho(Id) :-
   readCSV(File),
   removeProdutoDoCarrinhoCSV(File, Id, Saida),
   csv_write_file("../db/carrinhoDB.csv", Saida).

% Limpar carrinho
clearCarrinho() :-
   readCSV([Label|_]),
   csv_write_file("../db/carrinhoDB.csv", [Label]).