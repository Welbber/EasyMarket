:- module(compra, [putCompra/0, printCompras/0]).
:- use_module(library(csv)).

% Retorna o ultimo elemento de uma lista.
last(X,[X]).
last(X,[_|Z]) :- last(X,Z).

% Retorna o ultimo id de compraDB.csv
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
readCSV(File) :- csv_read_file('../db/compraDB.csv', File).
readCSVCarrinho(File) :- csv_read_file('../db/carrinhoDB.csv', File).

% Regras para listar todos os produtos
printCompraAux([], _).
printCompraAux([row(CurrentID, Nome, Preco, Categoria, Quantidade)|T], ID) :-
   CurrentID =:= ID -> (
      write("Nome Produto: "), writeln(Nome),
      write("Preço: "), writeln(Preco),
      write("Categoria: "), writeln(Categoria),
      write("Quantidade: "), writeln(Quantidade), nl,
      printCompraAux(T, ID)
   );
   printCompraAux(T, ID).

printCompras() :-
   write("Digite o ID da compra: "),
   read(Id),
   write('\e[2J'),
   readCSV([_|File]),
   printCompraAux(File, Id),
   print("Digite qualquer tecla para voltar..."),
   read(_).

% Não está funcionando ainda
% Realizar compra
putCompraAux([], _, Saida, Saida).
putCompraAux([row(_, Nome, Preco, Categoria, Quantidade)|Compra], Id, File, Saida) :-
   append(File, [row(Id, Nome, Preco, Categoria, Quantidade)], File2),
   putCompraAux(Compra, Id, File2, Saida).

putCompra() :-
   readCSVCarrinho([_|Compra]),
   id(Id),
   readCSV(File),
   putCompraAux(Compra, Id, File, Saida),
   write("Compra realizada com ID: "),
   writeln(Id),
   csv_write_file("../db/compraDB.csv", Saida).

% Removendo um agente
removeCompraCSV([], _, []).
removeCompraCSV([row(Id, _, _)|T], Id, T).
removeCompraCSV([H|T], Id, [H|Out]) :- removeCompraCSV(T, Id, Out).

removeCompra(Id) :-
   readCSV(File),
   removeCompraCSV(File, Id, Saida),
   csv_write_file("../db/compraDB.csv", Saida).
