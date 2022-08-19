{-# LANGUAGE OverloadedStrings #-}
module Controllers.AdmController where
import Database.PostgreSQL.Simple
import Models.Adm
import Models.Balanco

cadastraEstabelecimento::Connection -> String -> String -> String -> String -> String -> String -> String -> IO ()

getEstabelecimentoPorId:: Connection -> Int -> IO [Adm]
getEstabelecimentoPorLoginSenha:: Connection -> String -> String -> IO [Adm]
getBalanco:: Connection -> Int -> IO [Balanco]

atualizaNome::Connection -> String -> Int -> IO ()
atualizaTelefone::Connection -> String -> Int -> IO ()
atualizaEndereco::Connection -> String -> Int -> IO ()
atualizaSenha::Connection -> String -> Int -> IO ()

cadastraEstabelecimento conn login senha nome email telefone cnpj endereco = do
    let q = "INSERT INTO Estabelecimento (Login, Senha, Email, Telefone, Nome, CNPJ, Endereco) VALUES (?,?,?,?,?,?,?);"
    execute conn q (login, senha, email, telefone, nome, cnpj, endereco)
    return ()

getEstabelecimentoPorId conn id = do
    let q = "SELECT Id_Estabelecimento, Login, Senha, Email, Telefone, Nome, CNPJ, endereco From Estabelecimento WHERE Id_Estabelecimento = ?;"
    query conn q (Only (id::Int)) :: IO [Adm]

getEstabelecimentoPorLoginSenha conn login senha = do
    let q = "SELECT Id_Estabelecimento, Login, Senha, Email, Telefone, Nome, CNPJ, endereco From Estabelecimento WHERE Login = ? AND Senha = ?;"
    query conn q (login, senha) :: IO [Adm]

getBalanco conn id = do
    let q = "SELECT C.Id_Cliente, CO.ID_Compra, C.Nome, C.Telefone, C.Email, SUM(CA.QuantidadeDoProduto) AS quantidadeDeProdutos, CO.tipoPagamento, CO.TotalCompra, cast(CO.dataPagamento AS varchar(15)) AS DataPagamento \
    \From Estabelecimento AS E \
    \INNER JOIN Produto AS P ON P.Id_Estabelecimento = E.Id_Estabelecimento \
    \INNER JOIN Carrinho AS CA ON P.Id_Produto = E.Id_Estabelecimento \
    \INNER JOIN Cliente AS C ON C.ID_Cliente = CA.Id_Cliente \
    \INNER JOIN Compra AS CO ON CO.Id_Compra = CA.Id_Compra \
    \WHERE E.Id_Estabelecimento = ? \
    \GROUP BY C.Id_Cliente, CO.ID_Compra, C.Nome, C.Telefone, C.Email, CO.tipoPagamento, CO.TotalCompra, CO.dataPagamento;"
    
    query conn q (Only (id::Int)) :: IO [Balanco]

atualizaNome conn nome id = do
    let q = "UPDATE Estabelecimento SET Nome = ? WHERE Id_Estabelecimento = ?;"
    execute conn q (nome, id)
    return ()

atualizaSenha conn senha id = do
    let q = "UPDATE Estabelecimento SET senha = ? WHERE Id_Estabelecimento = ?;"
    execute conn q (senha, id)
    return ()

atualizaTelefone conn telefone id = do
    let q = "UPDATE Estabelecimento SET Telefone = ? WHERE Id_Estabelecimento = ?;"
    execute conn q (telefone, id)
    return ()

atualizaEndereco conn endereco id = do
    let q = "UPDATE Estabelecimento SET Endereco = ? WHERE Id_Estabelecimento = ?;"
    execute conn q (endereco, id)
    return ()