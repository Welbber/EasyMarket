:- module(cliente, [printClientes/0, getClientePorId/3, getClientePorLoginSenha/4, getClienteSenhaLogin/3, getCliente/2, putCliente/7, removeCliente/1]).
:- use_module(library(csv)).

% Retorna o ultimo elemento de uma lista.
last(X,[X]).
last(X,[_|Z]) :- last(X,Z).

% Retorna o ultimo id de clienteDB.csv
getLastId(Id):-
   readCSV(File),
   last(row(X, _, _, _, _, _, _, _), File),
   (
      X == 'id' -> Id is 0;
      Id is X
   ).

% Fato dinâmico para gerar o id dos clientes
id(X) :- getLastId(LastId), X is LastId + 1.

% Lendo arquivo JSON puro
readCSV(File) :- csv_read_file("../db/clienteDB.csv", File).

% Regras para listar todos os clientes
printClienteAux([]).
printClienteAux([row(ID, Nome, CPF, Login, _, Endereco, Telefone, Email)|T]) :-
   write("ID:"), writeln(ID),
   write("Nome: "), writeln(Nome),
   write("CPF: "), writeln(CPF),
   write("Login: "), writeln(Login),
   write("Endereço: "), writeln(Endereco),
   write("Telefone: "), writeln(Telefone),
   write("E-mail: "), writeln(Email), nl, printClienteAux(T).

printClientes() :-
   readCSV([_|File]),
   printClienteAux(File),
   print("Digite qualquer tecla para voltar..."),
   read(_).

% Recuperar um cliente da lista
getClientePorId(Id, Cliente, [row(CId, Nome, CPF, Login, _, Endereco, Telefone, Email)|T]) :-
   (
   CId =:= Id -> Cliente = row(CId, Nome, CPF, Login, _, Endereco, Telefone, Email);
   getClientePorId(Id, Cliente, T)
   ).

getClientePorLoginSenha(Login, Senha, Cliente, []).
getClientePorLoginSenha(Login, Senha, Cliente, [row(CId, Nome, CPF, CLogin, CSenha, Endereco, Telefone, Email)|T]) :-
   (
   Login == CLogin, Senha == CSenha -> Cliente = row(CId, Nome, CPF, CLogin, CSenha, Endereco, Telefone, Email);
   getClientePorLoginSenha(Login, Senha, Cliente, T)
   ).

getClienteSenhaLogin(Senha, Login, Cliente) :-
   readCSV([_|File]),
   getClientePorLoginSenha(Senha, Login, Cliente, File).

getCliente(Id, Cliente) :-
   readCSV([_|File]),
   getClientePorId(Id, Cliente, File).


% Salvar em arquivo CSV
putCliente(Nome, Identificador, Login, Senha, End, Tel, Email) :-
   id(ID),
   print(ID),
   readCSV(File),
   writeln(File),
   append(File, [row(ID, Nome, Identificador, Login, Senha, End, Tel, Email)], Saida),
   csv_write_file("../db/clienteDB.csv", Saida).

% Removendo um cliente da base
removeClienteCSV([], _, []).
removeClienteCSV([row(X, _, _, _, _, _, _, _)|T], Id, T).
removeClienteCSV([H|T], Id, [H|Out]) :- removeClienteCSV(T, Id, Out).

removeCliente(Id) :-
   readCSV(File),
   removeClienteCSV(File, Id, Saida),
   csv_write_file("../db/clienteDB.csv", Saida).