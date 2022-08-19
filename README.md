# EasyMarket

> Baseando-se na realidade, observamos que pequenos comerciantes costumam ter dificuldades para gerenciar seu negócio devido à falta de acesso a softwares de administração com interfaces user-friendly. O projeto a ser desenvolvido pela equipe consiste em uma aplicação que será desenvolvida nas linguagens de programação: Haskell e Prolog. Nesse sentido, a ideia pensada por nosso grupo pretende fornecer a esses comerciantes um sistema que permita administrar o comércio deles de forma facilitada.

- As instruções abaixo vão demonstrar alguns pontos importantes para o desenvolvimento do projeto.
- GHC 8.10.7;
- Cabal 3.6.2.0;
- PSQL (PostgreSQL) 12.11

## Build Aplication

> Instalação  GHCUP no Ubuntu
```
    curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
```

> Instalação postgresql no Ubuntu
```
    sudo apt update
    sudo apt install postgresql postgresql-contrib
    sudo systemctl start postgresql.service
```

> Instalação das depêndencias necessárias
```
    cabal update
    cabal install --lib postgresql-simple
    apt install libpq-dev
```

> Compilar Projeto.
```
    cabal build
```

> Executar Projeto.
```
    cabal run
```