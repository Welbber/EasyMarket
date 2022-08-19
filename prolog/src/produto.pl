:- module(produto, [printProdutos/0, putProduto/3, removeProduto/1, getProduto/2]).
:- use_module(library(csv)).

% Retorna o ultimo elemento de uma lista.
last(X,[X]).
last(X,[_|Z]) :- last(X,Z).

% Retorna o ultimo id de produtoDB.csv
getLastId(Id):-
   readCSV(File),
   last(row(X, _, _, _), File),
   (
      X == 'id' -> Id is 0;
      Id is X
   ).

% Fato dinâmico para gerar o id dos agentes
id(X) :- getLastId(LastId), X is LastId + 1.

% Lendo arquivo JSON puro
readCSV(File) :- csv_read_file('../db/produtoDB.csv', File).

% Regras para listar todos os produtos
printProdutosAux([]).
printProdutosAux([row(ID, Nome, Preco, Categoria)|T]) :-
   write("ID:"), writeln(ID),
   write("Nome: "), writeln(Nome),
   write("Preco: "), writeln(Preco),
   write("Categoria: "), writeln(Categoria), nl, printProdutosAux(T).

printProdutos() :-
   readCSV([_|File]),
   printProdutosAux(File),
   print("Digite qualquer tecla para voltar..."),
   read(_).

% Recuperar um produto da lista
getProdutoAux(Id, Produto, [row(CId, CNome, CPreco, CCategoria)|T]) :-
   (
      CId =:= Id -> Produto = row(CId, CNome, CPreco, CCategoria);
      getProdutoAux(Id, Produto, T)
   ).


getProduto(Id, Produto) :-
   readCSV([_|File]),
   getProdutoAux(Id, Produto, File).


% Salvar em arquivo CSV
putProduto(Nome, Preco, Categoria) :-
   id(ID),
   readCSV(File),
   append(File, [row(ID, Nome, Preco, Categoria)], Saida),
   csv_write_file("../db/produtoDB.csv", Saida).

% Removendo um agente
removeProdutoCSV([], _, []).
removeProdutoCSV([row(Id, _, _, _)|T], Id, T).
removeProdutoCSV([H|T], Id, [H|Out]) :- removeProdutoCSV(T, Id, Out).

removeProduto(Id) :-
   readCSV(File),
   removeProdutoCSV(File, Id, Saida),
   csv_write_file("../db/produtoDB.csv", Saida).
