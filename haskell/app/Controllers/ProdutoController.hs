{-# LANGUAGE OverloadedStrings #-}
module Controllers.ProdutoController where
import Database.PostgreSQL.Simple
import Models.Produto

cadastraProd::Connection -> String -> Float -> String -> String -> Int -> Int -> IO ()

getProds::Connection -> IO [Produto]
getProdPorId:: Connection -> Int -> IO [Produto]
getProdPorIdCompra:: Connection -> Int -> IO [Produto]
getProdPorIdEstabelecimento:: Connection -> Int -> IO [Produto]

deletaProd:: Connection -> Int -> IO ()

cadastraProd conn nome preco descricao categoria quantidadeEstoque id_Estabelecimento = do
  let q = "INSERT INTO Produto (Nome, Preco, Descricao, Categoria, QuantidadeEstoque, Id_Estabelecimento) VALUES (?,?,?,?,?,?);"
  execute conn q (nome, preco, descricao, categoria, quantidadeEstoque,id_Estabelecimento )
  return ()

getProds conn = do
  let q = "SELECT Id_Produto, Nome, preco, Descricao, Categoria, QuantidadeEstoque, Id_Estabelecimento FROM Produto;"
  query_ conn q :: IO [Produto]

getProdPorId conn id = do
  let q = "SELECT Id_Produto, Nome, preco, Descricao, Categoria, QuantidadeEstoque, Id_Estabelecimento FROM Produto WHERE Id_Produto = ?;"
  query conn q (Only (id::Int)) :: IO [Produto]

getProdPorIdCompra conn id = do
  let q = "SELECT P.Id_Produto, Nome, preco, Descricao, Categoria, CA.QuantidadeDoProduto AS QuantidadeEstoque, Id_Estabelecimento \
  \FROM Compra AS C \
  \INNER JOIN Carrinho AS CA ON CA.Id_Compra = C.Id_Compra \
  \INNER JOIN Produto AS P ON P.Id_Produto = CA.Id_Produto \
  \WHERE C.Id_Compra = ?;"
  query conn q (Only (id::Int)) :: IO [Produto]

getProdPorIdEstabelecimento conn id_estabelecimento = do
  let q = "SELECT Id_Produto, Nome, preco, Descricao, Categoria, QuantidadeEstoque,Id_Estabelecimento FROM Produto WHERE Id_Estabelecimento = ?;"
  query conn q (Only (id_estabelecimento::Int)) :: IO [Produto]

deletaProd conn id = do
    let q = "DELETE FROM Produto WHERE Id_Produto = ?;"
    execute conn q (Only (id::Int))
    return ()