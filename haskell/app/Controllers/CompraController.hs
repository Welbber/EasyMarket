{-# LANGUAGE OverloadedStrings #-}
module Controllers.CompraController where
import Database.PostgreSQL.Simple
import Models.Compra
import Models.Carrinho

cadastraCompra::Connection -> String -> String -> String -> String -> String -> IO ()

insereProdutoCarrinho::Connection->Int->Int->Int-> IO ()
insereCompra:: Connection -> String -> [Carrinho] -> Int -> IO [Compra]

getComprasPorIdCliente:: Connection ->Int -> IO [Compra]
getCompraPorId:: Connection -> Int -> IO [Compra]
getCarrinhoPorIdCliente:: Connection -> Int -> IO [Carrinho]

deleteCarrinhoPorIdClienteIdProduto:: Connection -> Int -> Int -> IO ()

subtraiQuantidadeProdutos:: Connection -> [Carrinho] -> IO ()

cadastraCompra conn tipoPagamento dataPagamento status totalCompra id_Cliente = do
    let q = "INSERT INTO Compra (TipoPagamento, DataPagamento, Status, TotalCompra, Id_Cliente) VALUES (?,?,?,?,?)"
    execute conn q (tipoPagamento, dataPagamento, status, totalCompra, id_Cliente)
    return ()

insereProdutoCarrinho conn id_produto id_cliente quantidade = do
    let q = "INSERT INTO Carrinho (Id_Produto, Id_Cliente, QuantidadeDoProduto) VALUES (?,?,?);"
    execute conn q (id_produto, id_cliente, quantidade)
    return ()

getComprasPorIdCliente conn id_cliente = do
    let q = "SELECT ID_Compra, TipoPagamento, cast(dataPagamento as varchar(15)) AS DataPagamento, TotalCompra, Id_Cliente FROM Compra WHERE Id_Cliente = ? ;"
    query conn q (Only (id_cliente::Int)) :: IO [Compra]

getCompraPorId conn id = do
    let q = "SELECT ID_Compra, TipoPagamento DataPagamento Status TotalCompra Id_Cliente FROM Compra WHERE Id_Compra = ?;"
    query conn q (Only (id::Int)) :: IO [Compra]

getCarrinhoPorIdCliente conn id = do
    let q = "SELECT CA.Id_Cliente, CA.Id_Produto, CA.QuantidadeDoProduto, PR.Nome, PR.preco FROM Carrinho AS CA INNER JOIN Produto AS PR ON PR.Id_Produto = CA.Id_Produto WHERE CA.Id_Cliente = ? AND CA.ID_COMPRA IS NULL;"
    query conn q (Only (id::Int)) :: IO [Carrinho]

deleteCarrinhoPorIdClienteIdProduto conn id_cliente id_produto = do
    let q = "DELETE FROM CARRINHO WHERE ID_CLIENTE = ? AND ID_PRODUTO = ? AND ID_COMPRA IS NULL;"
    execute conn q (id_cliente, id_produto)
    return ()

insereCompra conn tipoPagamento carrinho id_cliente = do
    let q1 = "INSERT INTO COMPRA (TipoPagamento, DataPagamento, TotalCompra, Id_Cliente) VALUES (?, NOW(), ?, ?) returning id_compra, tipoPagamento, cast(dataPagamento as varchar(15)) AS DataPagamento, TotalCompra, Id_Cliente;"
    
    compra  <- query conn q1 (tipoPagamento, (somaTotalValor carrinho), id_cliente) :: IO [Compra]
    
    let id_compra = id_Compra (head compra)
    
    subtraiQuantidadeProdutos conn carrinho

    let q3 = "UPDATE Carrinho SET Id_Compra = ? WHERE Id_Cliente = ? AND Id_Compra IS NULL;"
    execute conn q3 (id_compra, id_cliente)
    return compra

subtraiQuantidadeProdutos conn (carrinho:[]) = do
    let q = "UPDATE Produto SET QuantidadeEstoque = QuantidadeEstoque - ? WHERE Id_Produto = ?"
    a <- execute conn q (quantidadeDoProduto carrinho, id_produto carrinho)
    putStrLn ""

subtraiQuantidadeProdutos conn (carrinho:t) = do
    let q = "UPDATE Produto SET QuantidadeEstoque = QuantidadeEstoque - ? WHERE Id_Produto = ?"

    a <- execute conn q (quantidadeDoProduto carrinho, id_produto carrinho)

    subtraiQuantidadeProdutos conn t