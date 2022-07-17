{-# LANGUAGE OverloadedStrings #-}
module Views.MainAdm where

import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.AdmController
import Controllers.ProdutoController 
import Models.Adm as A
import Models.Produto as P
import Models.Balanco as B
--TELAS DOS ADMS

mainAdm::Connection-> Int-> IO()
mainAdm conn id_estabelecimento = do
    putStr "\ESC[2J"
    putStrLn "             +-+-+-+"
    putStrLn "             |A|D|M|"
    putStrLn "             +-+-+-+"

    putStrLn " ===================================== "
    putStrLn "|                                    |"
    putStrLn "|       1- CADASTRAR PRODUTO         |"
    putStrLn "|       2- EXCLUIR PRODUTO           |"
    putStrLn "|       3- VER BALANÇO DE ESTOQUE    |"
    putStrLn "|       4- VER INFORMAÇÕES CONTA     |"
    putStrLn "|       5- SAIR                      |"
    putStrLn "|                                    |"
    putStrLn " ===================================== "

    putStrLn "Digite sua opção:"
    input <- getLine
    let opcao = read input

    selecao conn id_estabelecimento opcao

selecao::Connection-> Int->Int->IO()
selecao conn id_estabelecimento 1 = telaCadastrarProduto  conn id_estabelecimento
selecao conn id_estabelecimento 2 = telaExcluirProduto conn id_estabelecimento
selecao conn id_estabelecimento 3 = telaBalancoEstoque conn id_estabelecimento
selecao conn id_estabelecimento 4 = telaPerfil conn id_estabelecimento
selecao conn id_estabelecimento 5 = telaSair 
selecao conn id_estabelecimento x = erroAdm conn id_estabelecimento

telaCadastrarProduto:: Connection-> Int -> IO()
telaCadastrarProduto conn id_estabelecimento = do
    putStr "\ESC[2J"
    putStrLn " ==================================== "
    putStrLn "|        CADASTRAR PRODUTO           |"
    putStrLn " ==================================== "

    putStrLn "Digite o nome do produto:"
    nome <- getLine

    putStrLn "Digite o preço da unidade:"
    input <- getLine
    let preco = read input

    putStrLn "Digite a descrição(em uma única linha):"
    descricao <- getLine

    putStrLn "Digite a categoria:"
    categoria <- getLine

    putStrLn "Digite a quantidade:"
    input2 <- getLine
    let quantidadeEstoque = read input2

    --cadastra o produto
    cadastraProd conn nome preco descricao categoria quantidadeEstoque id_estabelecimento

    putStrLn "sucesso"

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaExcluirProduto::Connection-> Int->IO()
telaExcluirProduto conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|        EXCLUIR PRODUTO             |"
    putStrLn " ==================================== "

    putStrLn "Qual o id do produto que você deseja excluir:"
    input <- getLine
    let identificador = read input

  
    deletaProd conn identificador
    putStrLn "Produto excluído."

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaBalancoEstoque::Connection-> Int->IO()
telaBalancoEstoque conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|        BALANÇO DE ESTOQUE           |"
    putStrLn " ==================================== "

    putStrLn " ==================================== "
    putStrLn "|                                    |"
    putStrLn "|       1- LISTAGEM DE PRODUTOS      |"
    putStrLn "|       2- VENDAS REALIZADAS         |"
    putStrLn "|       3- DETALHAMENTO DE PRODUTO   |"
    putStrLn "|                                    |"
    putStrLn " ==================================== "

    input <- getLine
    let opcao = read input
    selecaoEstoque conn id_estabelecimento opcao

selecaoEstoque::Connection-> Int-> Int -> IO()
selecaoEstoque conn id_estabelecimento 1 = telaListagemDeProdutos  conn id_estabelecimento
selecaoEstoque conn id_estabelecimento 2 = telaVendasRealizadas conn id_estabelecimento
selecaoEstoque conn id_estabelecimento 3 = telaDetalhamentoDeProduto conn id_estabelecimento
selecaoEstoque conn id_estabelecimento x = erroAdm conn id_estabelecimento

telaListagemDeProdutos::Connection-> Int->IO()
telaListagemDeProdutos conn id_estabelecimento = do
    putStr "\ESC[2J"
    putStrLn " ==================================== "
    putStrLn "|        LISTAGEM DE PRODUTOS        |"
    putStrLn " ==================================== " 

    produtos <- getProdPorIdEstabelecimento conn id_estabelecimento
    
    putStrLn (P.toStringList produtos)

    putStr "Digite enter para continuar"
    opcao <- getLine
    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaVendasRealizadas::Connection-> Int->IO()
telaVendasRealizadas conn id_estabelecimento = do
    putStr "\ESC[2J"
    putStrLn " ==================================== "
    putStrLn "|        VENDAS REALIZADAS           |"
    putStrLn " ==================================== " 

    balanco <- getBalanco conn id_estabelecimento

    putStrLn (B.toString balanco)

    putStrLn "Digite 0 para continuar ou Id Compra para ver detalhes compra"
    opcao <- getLine 
    if opcao /= "0" then do
        putStr "\ESC[2J"
        putStrLn " ==================================== "
        putStrLn "|        DETALHES DA COMPRA          |"
        putStrLn " ==================================== "

        produtos <- getProdPorIdCompra conn (read opcao)

        putStrLn (P.toStringList produtos)

        putStrLn "Pressione enter para continuar"
        opcao <- getLine
        mainAdm conn id_estabelecimento
    else 
        mainAdm conn id_estabelecimento

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaDetalhamentoDeProduto::Connection-> Int->IO()
telaDetalhamentoDeProduto conn id_estabelecimento = do
    putStr "\ESC[2J"
    putStrLn " ==================================== "
    putStrLn "|      DETALHAMENTO DE PRODUTO       |"
    putStrLn " ==================================== " 

    putStrLn "Digite o código do produto:"
    
    id <- getLine

    produto <- getProdPorId conn (read id)

    putStrLn (P.toString (head produto))

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento

telaPerfil::Connection->Int->IO()
telaPerfil conn id_estabelecimento = do
    putStrLn " ==================================== "
    putStrLn "|        PERFIL DO ESTABELECIMENTO   |"
    putStrLn " ==================================== "

    estabelecimento <- getEstabelecimentoPorId conn id_estabelecimento

    putStrLn (A.toString (head estabelecimento))

    putStrLn " ============================================= "
    putStrLn "Deseja voltar à tela inicial(0) ou editar informações(1)?"
    opcao <- getLine
    if opcao == "0" then 
        mainAdm conn id_estabelecimento
    else if opcao == "1" then
        telaUpdateInformacoes conn id_estabelecimento
    else do
        putStrLn "Opção invalida"
        telaPerfil conn id_estabelecimento

telaUpdateInformacoes::Connection  -> Int -> IO()
telaUpdateInformacoes conn id_estabelecimento = do

    putStrLn " ======================================== "
    putStrLn "|             EDITAR PERFIL              |"
    putStrLn " ======================================== "

    putStrLn " ======================================== "
    putStrLn "|  Qual informação você deseja alterar?  |"
    putStrLn "|                                        |"
    putStrLn "|            1. Nome do Estabelecimento  |"
    putStrLn "|            2. Senha                    |"
    putStrLn "|            3. Endereço                 |"
    putStrLn "|            4. Telefone                 |"
    putStrLn " ======================================== "
    putStrLn "Escolha uma opção: "
    input <- getLine
    --let op = read input
    if input == "1" then do
        putStrLn "Informe novo nome: "
        nome <- getLine
        atualizaNome conn nome id_estabelecimento 
        putStrLn "Nome alterado com sucesso"
    else if input == "2" then do 
        putStrLn "Informe nova senha: "
        senha1 <- getLine

        putStrLn "Informe novamente a senha: "
        senha2 <- getLine
        if senha1 == senha2 then do
            atualizaSenha conn senha1 id_estabelecimento
            putStrLn "Senha alterado com sucesso"
        else do
            putStrLn "Senhas diferentes"
            telaUpdateInformacoes conn id_estabelecimento
    else if input == "3" then do 
        putStrLn "Informe novo endereço: "
        endereco <- getLine
        atualizaEndereco conn endereco id_estabelecimento
        putStrLn "Endereço alterado com sucesso"
    else if input == "4" then do 
        putStrLn "Informe novo telefone: "
        telefone <- getLine
        atualizaTelefone conn telefone id_estabelecimento
        putStrLn "Telefone alterado com sucesso"
    else
        putStrLn "Opção Invalida..."
    mainAdm conn id_estabelecimento


telaSair::IO()
telaSair = do
    putStrLn " ==================================== "
    putStrLn "|     SAINDO...ATÉ A PRÓXIMA :D      |"
    putStrLn " ==================================== "

erroAdm::Connection-> Int-> IO()
erroAdm conn id_estabelecimento = do  
    putStrLn "Dado inválido"

    --voltando para a tela inicial de adm
    mainAdm conn id_estabelecimento