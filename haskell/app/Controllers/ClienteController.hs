{-# LANGUAGE OverloadedStrings #-}
module Controllers.ClienteController where
import Database.PostgreSQL.Simple
import Models.Cliente

cadastraCliente::Connection -> String -> String -> String -> String -> String -> String -> String -> IO ()

getClientePorId:: Connection -> Int -> IO [Cliente]
getClientePorLoginSenha:: Connection -> String -> String -> IO [Cliente]

atualizaNome::Connection -> String -> Int -> IO ()
atualizaTelefone::Connection -> String -> Int -> IO ()
atualizaEndereco::Connection -> String -> Int -> IO ()
atualizaSenha::Connection -> String -> Int -> IO ()
atualizaEmail::Connection -> String -> Int -> IO ()

cadastraCliente conn nome cpf login senha endereco telefone email = do
    let q = "INSERT INTO Cliente (Nome, CPF, Login, Senha, Endereco, Telefone, Email) VALUES (?,?,?,?,?,?,?)"
    execute conn q (nome, cpf, login, senha, endereco, telefone, email)
    return ()

getClientePorId conn id = do
    let q = "SELECT Id_Cliente, Nome, CPF, Login, Senha, Endereco, Telefone, Email From Cliente WHERE Id_Cliente = ?;"
    query conn q (Only (id::Int)) :: IO [Cliente]

getClientePorLoginSenha conn login senha = do
    let q = "SELECT Id_Cliente, Nome, CPF, Login, Senha, Endereco, Telefone, Email From Cliente WHERE Login = ? AND Senha = ?;"
    query conn q (login, senha) :: IO [Cliente]

atualizaNome conn nome id = do
    let q = "UPDATE Cliente SET Nome = ? WHERE Id_Cliente = ?"
    execute conn q (nome, id)
    return ()

atualizaEmail conn email id = do
    let q = "UPDATE Cliente SET Email = ? WHERE Id_Cliente = ?"
    execute conn q (email, id)
    return ()

atualizaSenha conn senha id = do
    let q = "UPDATE Cliente SET senha = ? WHERE Id_Cliente = ?"
    execute conn q (senha, id)
    return ()

atualizaTelefone conn telefone id = do
    let q = "UPDATE Cliente SET Telefone = ? WHERE Id_Cliente = ?"
    execute conn q (telefone, id)
    return ()

atualizaEndereco conn endereco id = do
    let q = "UPDATE Cliente SET Endereco = ? WHERE Id_Cliente = ?"
    execute conn q (endereco, id)
    return ()