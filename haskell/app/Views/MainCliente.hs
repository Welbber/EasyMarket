{-# LANGUAGE OverloadedStrings #-}
module Views.MainCliente where

import Database.PostgreSQL.Simple
import Models.Produto as P
import Models.Carrinho as C
import Models.Compra as CO
import Models.Cliente as CL
import Controllers.ProdutoController
import Controllers.CompraController
import Controllers.ClienteController 

mainCliente::Connection->Int->IO()
mainCliente conn id_cliente= do
    putStr "\ESC[2J"
    putStrLn "         +-+-+-+-+-+-+-+"
    putStrLn "         |C|L|I|E|N|T|E|"
    putStrLn "         +-+-+-+-+-+-+-+"

    putStrLn " ==================================== "
    putStrLn "|                                    |"
    putStrLn "|       1- LISTAGEM DE PRODUTOS      |"
    putStrLn "|       2- VER CARRINHO ATUAL        |"
    putStrLn "|       3- VER PERFIL                |"
    putStrLn "|       4- LISTAR COMPRAS            |"
    putStrLn "|       5- SAIR                      |"
    putStrLn "|                                    |"
    putStrLn " ==================================== "

    putStrLn "Digite sua opção:"
    input <- getLine
    let opcao = read input
    selecao conn id_cliente opcao

selecao:: Connection->Int->Int -> IO()
selecao conn id_cliente 1 = telaListagemDeProdutos conn id_cliente
selecao conn id_cliente 2 = telaCarrinhoAtual conn id_cliente
selecao conn id_cliente 3 = telaPerfil conn id_cliente
selecao conn id_cliente 4 = telaCompras conn id_cliente  
selecao conn id_cliente 5 = telaSair  
selecao conn id_cliente x = erroCliente conn id_cliente

telaListagemDeProdutos:: Connection->Int->IO()
telaListagemDeProdutos conn id_cliente = do
    putStr "\ESC[2J"
    putStrLn " ==================================== "
    putStrLn "|        LISTAGEM DE PRODUTOS        |"
    putStrLn " ==================================== "

    produtos <- getProds conn

    putStrLn (P.toStringList produtos)

    putStrLn "Qual produto deseja comprar?digite o id do produto:"
    putStrLn "OBS:Digite -1 para ir para o carrinho ou -2 para voltar à tela inicial."

    input <- getLine
    let idProduto = read input

    lerProdutos conn id_cliente idProduto

lerProdutos::Connection->Int-> Int -> IO()
lerProdutos conn id_cliente (-1) = telaCarrinhoAtual conn id_cliente
lerProdutos conn id_cliente (-2) = mainCliente conn id_cliente
lerProdutos conn id_cliente id_produto = do
    --adicionar o proprecioneduto no carrinho da compra do cliente
    putStrLn "Informe a quantidade de produtos desejados:"
    quantidade <- getLine
    produto <- getProdPorId conn id_produto

    if (quantidadeEstoque (head (produto)) < read quantidade) 
        then do
            putStrLn "Quantidade não disponivel no momento, pressione enter para continuar"
            opcao <- getLine
            putStrLn "\n"
    else do
        insereProdutoCarrinho conn id_produto id_cliente (read quantidade)
        putStrLn "Produto adicionado."
        
    produtos <- getProds conn
    putStrLn (P.toStringList produtos)

    putStrLn "Qual produto deseja comprar?digite o id do produto:"
    putStrLn "OBS:Digite -1 para ir para o carrinho ou -2 para voltar à tela inicial."
    opcao <- getLine
    let idProximoProduto = read opcao

    lerProdutos conn id_cliente idProximoProduto --adicionar o novo produto informado
    --essa função só para de ler os produtos quando o usuário informa se quer ir para o carrinho ou voltar à tela inicial


telaCarrinhoAtual::Connection->Int->IO()
telaCarrinhoAtual conn id_cliente = do
    putStr "\ESC[2J"
    putStrLn " ==================================== "
    putStrLn "|        CARRINHO DE COMPRAS         |"
    putStrLn " ==================================== "

    carrinho <- getCarrinhoPorIdCliente conn id_cliente

    putStrLn (C.toString carrinho)

    --EXIBE OS PRODUTOS

    putStrLn "Deseja excluir algum produto(digite o id)?(S/N)"
    op <- getLine 

    if(op `elem` ["S","s","SIM","sim","Sim"])
        then do
            putStrLn "Digite o id do produto que deseja excluir:"
            input <- getLine
            
            deleteCarrinhoPorIdClienteIdProduto conn id_cliente (read input)
            
            putStrLn "Produto excluído."
            
            telaCarrinhoAtual conn id_cliente
    else do
        putStrLn "Deseja finalizar a compra?(S/N)"
        opcao <- getLine

        if(opcao `elem` ["S","s","SIM","sim","Sim"])
            then telaFinalizarCompra conn id_cliente
        else 
            mainCliente conn id_cliente


telaFinalizarCompra::Connection->Int->IO()
telaFinalizarCompra conn id_cliente= do

    putStrLn " ==================================== "
    putStrLn "|       FINALIZANDO COMPRA...        |"
    putStrLn " ==================================== "

    putStrLn "Informe o tipo de pagamento:(cartão/em espécie/PIX)"
    tipoDePagamento <- getLine

    carrinho <- getCarrinhoPorIdCliente conn id_cliente 

    compra <- insereCompra conn tipoDePagamento carrinho id_cliente

    putStrLn "..."
    putStrLn "Compra finalizada."

    putStrLn " ==================================== "
    putStrLn "|        DETALHES DA COMPRA          |"
    putStrLn " ==================================== "

    putStrLn (CO.toString (head compra))
   
    --exibir detalhes da comprar:produtos + preço final + tipo de pagamento + status finalizado

    putStrLn " ============================================= "
    putStrLn "  Deseja voltar à tela inicial(0) ou sair(1)?"
    input <- getLine
    let opcao = read input

    telaVoltarAInicialOuSair conn id_cliente opcao

telaPerfil::Connection->Int->IO()
telaPerfil conn id_cliente = do
    putStrLn " ==================================== "
    putStrLn "|        PERFIL DO CLIENTE           |"
    putStrLn " ==================================== "

    cliente <- getClientePorId conn id_cliente

    putStrLn (CL.toString (head cliente))

    putStrLn " ============================================= "
    putStrLn "Deseja voltar à tela inicial(0) ou editar informações(1)?"
    opcao <- getLine
    if opcao == "0" then 
        mainCliente conn id_cliente
    else if opcao == "1" then
        telaUpdateInformacoes conn id_cliente
    else do
        putStrLn "Opção invalida"
        telaPerfil conn id_cliente
telaUpdateInformacoes::Connection  -> Int -> IO()
telaUpdateInformacoes conn id_cliente = do
    putStrLn " ======================================== "
    putStrLn "|             EDITAR PERFIL              |"
    putStrLn " ======================================== "

    putStrLn " ======================================== "
    putStrLn "|  Qual informação você deseja alterar?  |"
    putStrLn "|                                        |"
    putStrLn "|            1. Nome                     |"
    putStrLn "|            2. Senha                    |"
    putStrLn "|            3. Endereço                 |"
    putStrLn "|            4. Telefone                 |"
    putStrLn "|            5. Email                    |"
    putStrLn " ======================================== "
    putStrLn "Escolha uma opção: "
    input <- getLine
    --let op = read input
    if input == "1" then do
        putStrLn "Informe novo nome: "
        nome <- getLine
        atualizaNome conn nome id_cliente 
        putStrLn "Nome alterado com sucesso"
    else if input == "2" then do 
        putStrLn "Informe nova senha: "
        senha1 <- getLine

        putStrLn "Informe novamente a senha: "
        senha2 <- getLine
        if senha1 == senha2 then do
            atualizaSenha conn senha1 id_cliente
            putStrLn "Senha alterado com sucesso"
        else do
            putStrLn "Senhas diferentes"
            telaUpdateInformacoes conn id_cliente
    else if input == "3" then do 
        putStrLn "Informe novo endereço: "
        endereco <- getLine
        atualizaEndereco conn endereco id_cliente
        putStrLn "Endereço alterado com sucesso"
    else if input == "4" then do 
        putStrLn "Informe novo telefone: "
        telefone <- getLine
        atualizaTelefone conn telefone id_cliente
        putStrLn "Telefone alterado com sucesso"
    else if input == "5" then do 
        putStrLn "Informe novo e-mail: "
        email <- getLine
        atualizaEmail conn email id_cliente
        putStrLn "Email alterado com sucesso"
    else
        putStrLn "Opção Invalida..."
    mainCliente conn id_cliente

telaCompras::Connection -> Int -> IO()
telaCompras conn id_cliente = do
    putStr "\ESC[2J"
    putStrLn " ======================================== "
    putStrLn "|            COMPRAS REALIZADAS          |"
    putStrLn " ======================================== "

    compras <- getComprasPorIdCliente conn id_cliente

    putStrLn (CO.toStringList compras)
    putStrLn "Digite 0 para continuar ou Id Compra para ver produtos comprados"
    opcao <- getLine 
    if opcao /= "0" then do
        
        putStrLn " ==================================== "
        putStrLn "|        DETALHES DA COMPRA          |"
        putStrLn " ==================================== "

        produtos <- getProdPorIdCompra conn (read opcao)

        putStrLn (P.toStringList produtos)

        putStrLn "Pressione enter para continuar"
        opcao <- getLine
        mainCliente conn id_cliente
    else 
        mainCliente conn id_cliente

telaVoltarAInicialOuSair::Connection->Int->Int -> IO()
telaVoltarAInicialOuSair conn id_cliente 0 = mainCliente conn id_cliente
telaVoltarAInicialOuSair conn id_cliente 1 = telaSair
telaVoltarAInicialOuSair conn id_cliente x = erroCliente conn id_cliente

telaSair::IO()
telaSair = do
    putStrLn " ==================================== "
    putStrLn "|     SAINDO...ATÉ A PRÓXIMA :D      |"
    putStrLn " ==================================== "

erroCliente::Connection->Int-> IO()
erroCliente conn id_cliente = do  
    putStrLn "Dado inválido :("

    --voltando para a tela inicial de adm
    mainCliente conn id_cliente