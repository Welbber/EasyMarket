:- use_module(produto, [printProdutos/0, putProduto/3, removeProduto/1, getProduto/2]).
:- use_module(carrinho, [printCarrinho/0, putProdutoNoCarrinho/4, removeProdutoDoCarrinho/1, clearCarrinho/0]).
:- use_module(compra, [putCompra/0, printCompras/0]).
:- use_module(cliente, [printClientes/0, getClientePorId/3, getClientePorLoginSenha/4, getClienteSenhaLogin/3, getCliente/2, putCliente/7, removeCliente/1]).
:- use_module(adm, [printAdm/0, getAdmPorId/3, getAdmPorLoginSenha/4, getAdmSenhaLogin/3, getAdm/2, putAdm/7, removeAdm/1]).
:- use_module(library(csv)).

main():-
    write('\e[2J'),

    writeln('        +-+-+-+-+ +-+-+-+-+-+-+'),
    writeln('        |E|a|s|y| |M|a|r|k|e|t|'),
    writeln('        +-+-+-+-+ +-+-+-+-+-+-+'),
    writeln(' ===================================== '),
    writeln('          1- ADMINISTRADOR             '),
    writeln('          2- CLIENTE                   '),    
    writeln('          0- SAIR                      '),
    writeln(' ===================================== '),nl,

    write('Digite sua opcao: '),
    read(Option),
    cadastrarOuLogar(Option).

cadastrarOuLogar(0):- halt.
cadastrarOuLogar(TipoDeUsuario):-
    print(' ===================================== '),nl,
    print('          1- CADASTRO                  '),nl,
    print('          2- LOGIN                     '),nl,
    print(' ===================================== '),nl,nl,
    print('Digite sua opcao:'),
    read(OPCAO),
    telaCadastrarOuLogar(OPCAO,TipoDeUsuario).


telaCadastrarOuLogar(1,TipoDeUsuario):- telaCadastro(TipoDeUsuario).
telaCadastrarOuLogar(2,TipoDeUsuario):- telaLogin(TipoDeUsuario).

telaCadastro(TipoDeUsuario):-
    print(' ===================================== '),nl,
    print('             CADASTRO                  '),nl,
    print(' ===================================== '),nl,nl,
    (TipoDeUsuario =:= 1 -> print('Digite seu CNPJ:');print('Digite seu CPF:')),read(Identificador),nl,
    print('Digite seu Nome:'),read(Nome),nl,
    print('Escolha seu login:'),read(Login),nl,
    print('Escolha uma senha:'),read(Senha),nl,
    print('Digite seu endereco, tudo em uma linha so:'),read(End),nl,
    print('Digite o seu telefone:'),read(Tel),nl,
    print('Digite o seu email:'),read(Email),nl,nl,
    (TipoDeUsuario =:= 1 -> print('Salvando informações'), putAdm(Nome, Identificador, Login, Senha, End, Tel, Email);print('Salvando informações')), putCliente(Nome, Identificador, Login, Senha, End, Tel, Email),main.

telaLogin(TipoDeUsuario):-
    print(' ===================================== '),nl,
    print('              LOGIN                    '),nl,
    print(' ===================================== '),nl,nl,
    print('Digite seu login:'),read(Login),nl,
    print('Digite sua senha:'),read(Senha),nl,
    (TipoDeUsuario =:= 1 -> print('REALIZA LOGIN DE ESTABELECIMENTO AQUI'),nl,getAdmSenhaLogin(Login, Senha, Adm), login(TipoDeUsuario, Adm),nl; print('REALIZA LOGIN DE CLIENTE AQUI'),nl, getClienteSenhaLogin(Login, Senha, Cliente), login(TipoDeUsuario, Cliente)),nl.


login(TipoDeUsuario, []):- print('SENHA OU LOGIN INVALIDADO'),nl, telaLogin(2).

login(TipoDeUsuario,Usuario):-
    (TipoDeUsuario =:= 1 -> admin(); user()).

% User ----------------------------
user():-
    write('\e[2J'),
    writeln('             +-+-+-+-+-+-+-+'),
    writeln('             |C|L|I|E|N|T|E|'),
    writeln('             +-+-+-+-+-+-+-+'),nl,
    writeln(' ===================================== '),
    writeln('      1- LISTAGEM DE PRODUTOS          '),
    writeln('      2- LISTAGEM DE CARRINHO          '),
    writeln('      3- ADD PRODUTO CARRINHO          '),
    writeln('      4- REMOVER PRODUTO DO CARRINHO   '),
    writeln('      5- REALIZAR COMPRA               '),
    writeln('      6- LISTAR COMPRA                 '),
    writeln('      0- SAIR                          '),
    writeln(' ===================================== '),nl,
    write('Digite sua opcao: '),
    read(Option),
    userOption(Option),
    user().

userOption(1):- printProdutos().
userOption(2):- printCarrinho().
userOption(3):-
    print('Digite o ID:'),nl,
    read(Id),
    print('Digite a quantidade:'),nl,
    read(Quantidade),
    getProduto(Id, row(_, Nome, Preco, Categoria)),
    putProdutoNoCarrinho(Nome, Preco, Categoria, Quantidade).
userOption(4):-
    print('Digite o ID:'),nl,
    read(Id),
    removeProdutoDoCarrinho(Id).
userOption(5):-
    putCompra(),
    clearCarrinho().
userOption(6):- printCompras().
userOption(0):- main().
% ---------------------------------

% Admin ---------------------------
admin():-
    write('\e[2J'),
    writeln('                 +-+-+-+               '),
    writeln('                 |A|D|M|               '),
    writeln('                 +-+-+-+               '),nl,
    writeln(' ===================================== '),
    writeln('      1- CADASTRAR PRODUTO             '),
    writeln('      2- EXCLUIR PRODUTO               '),
    writeln('      3- LISTAR PRODUTOS               '),
    writeln('      0- SAIR                          '),
    writeln(' ===================================== '),nl,
    write('Digite sua opcao: '),

    read(Option),
    adminOption(Option),
    admin().

adminOption(1):-
    write('\e[2J'),
    print('Digite o nome do produto:'),nl,
    read(Nome),
    print('Digite o preço do produto:'),nl,
    read(Preco),
    print('Digite a categoria do produto:'),nl,
    read(Categoria),
    putProduto(Nome, Preco, Categoria).
adminOption(2):-
    write('\e[2J'),
    print('Digite o id do produto que deseja excluir:'),nl,
    read(Id),
    removeProduto(Id).
adminOption(3):- printProdutos().
adminOption(0):- main().
