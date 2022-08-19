:- module(adm, [printAdm/0, getAdmPorId/3, getAdmPorLoginSenha/4, getAdmSenhaLogin/3, getAdm/2, putAdm/7, removeAdm/1]).
:- use_module(library(csv)).

% Retorna o ultimo elemento de uma lista.
last(X,[X]).
last(X,[_|Z]) :- last(X,Z).

% Retorna o ultimo id de AdmDB.csv
getLastId(Id):-
   readCSV(File),
   last(row(X, _, _, _, _, _, _, _), File),
   (
      X == 'id' -> Id is 0;
      Id is X
   ).

% Fato dinâmico para gerar o id dos Adms
id(X) :- getLastId(LastId), X is LastId + 1.

% Lendo arquivo JSON puro
readCSV(File) :- csv_read_file("../db/admDB.csv", File).

% Regras para listar todos os Adms
printAdmAux([]).
printAdmAux([row(ID, Nome, CNPJ, Login, _, Endereco, Telefone, Email)|T]) :-
   write("ID:"), writeln(ID),
   write("Nome: "), writeln(Nome),
   write("CPNJ: "), writeln(CNPJ),
   write("Login: "), writeln(Login),
   write("Endereço: "), writeln(Endereco),
   write("Telefone: "), writeln(Telefone),
   write("E-mail: "), writeln(Email), nl, printAdmAux(T).

printAdm() :-
   readCSV([_|File]),
   printAdmAux(File),
   print("Digite qualquer tecla para voltar..."),
   read(_).

% Recuperar um Adm da lista
getAdmPorId(Id, Adm, [row(CId, Nome, CNPJ, Login, _, Endereco, Telefone, Email)|T]) :-
   (
   CId =:= Id -> Adm = row(CId, Nome, CNPJ, Login, _, Endereco, Telefone, Email);
   getAdmPorId(Id, Adm, T)
   ).

getAdmPorLoginSenha(Login, Senha, Adm, []).
getAdmPorLoginSenha(Login, Senha, Adm, [row(CId, Nome, CNPJ, CLogin, CSenha, Endereco, Telefone, Email)|T]) :-
   (
   Login == CLogin, Senha == CSenha -> Adm = row(CId, Nome, CNPJ, CLogin, CSenha, Endereco, Telefone, Email);
   getAdmPorLoginSenha(Login, Senha, Adm, T)
   ).

getAdmSenhaLogin(Senha, Login, Adm) :-
   readCSV([_|File]),
   getAdmPorLoginSenha(Senha, Login, Adm, File).

getAdm(Id, Adm) :-
   readCSV([_|File]),
   getAdmPorId(Id, Adm, File).


% Salvar em arquivo CSV
putAdm(Nome, Identificador, Login, Senha, End, Tel, Email) :-
   id(ID),
   print(ID),
   readCSV(File),
   writeln(File),
   append(File, [row(ID, Nome, Identificador, Login, Senha, End, Tel, Email)], Saida),
   csv_write_file("../db/admDB.csv", Saida).

% Removendo um Adm da base
removeAdmCSV([], _, []).
removeAdmCSV([row(X, _, _, _, _, _, _, _)|T], Id, T).
removeAdmCSV([H|T], Id, [H|Out]) :- removeAdmCSV(T, Id, Out).

removeAdm(Id) :-
   readCSV(File),
   removeAdmCSV(File, Id, Saida),
   csv_write_file("../db/admDB.csv", Saida).