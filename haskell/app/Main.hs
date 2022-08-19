{-# LANGUAGE OverloadedStrings #-}
module Main where

import Database.PostgreSQL.Simple
import LocalDB.ConnectionDB
import Controllers.ClienteController
import Controllers.AdmController
import Models.Cliente
import Models.Adm
import Views.MainAdm
import Views.MainCliente
import Utils.Utils

main :: IO ()
main = do
    putStr "\ESC[2J"
    --Realizando comunicacao com a base
    conn <- iniciandoDatabase
   
    putStrLn "      +-+-+-+-+ +-+-+-+-+-+-+"
    putStrLn "      |E|a|s|y| |M|a|r|k|e|t|"
    putStrLn "      +-+-+-+-+ +-+-+-+-+-+-+"

    putStrLn " ================================= "
    putStrLn "|                                 |"
    putStrLn "|       1-  ADMINISTRADOR         |"
    putStrLn "|       2-    CLIENTE             |"
    putStrLn "|                                 |"
    putStrLn " ================================= "

    putStrLn "Digite sua opção:"
    
    opcao <- getLine
    
    let tipoDeUsuario = read opcao

    if tipoDeUsuario == 1 || tipoDeUsuario == 2
        then cadastrarOuLogar conn tipoDeUsuario
    else erro

cadastrarOuLogar:: Connection -> Int -> IO()
cadastrarOuLogar conn tipoDeUsuario = do

    putStrLn " =================================  "
    putStrLn "|       1-   CADASTRO             |"
    putStrLn "|       2-    LOGIN               |"
    putStrLn " ================================= "

    putStrLn "Digite sua opção:"
    input <- getLine
    let opcao = read input

    seletorCadastroOuLogin conn opcao tipoDeUsuario

--De acordo com a opção na função acima, é chamado uma tela/função
seletorCadastroOuLogin:: Connection -> Int -> Int -> IO()
seletorCadastroOuLogin conn 1 tipoDeUsuario = telaCadastro conn tipoDeUsuario
seletorCadastroOuLogin conn 2 tipoDeUsuario = telaLogin conn tipoDeUsuario
seletorCadastroOuLogin coon x tipoDeUsuario = erro

telaCadastro:: Connection -> Int -> IO()
telaCadastro conn tipoDeUsuario = do

    putStrLn " ================================= "
    putStrLn "|           CADASTRO              |"
    putStrLn " ================================= "

    if(tipoDeUsuario == 1) --adm
      then 
        putStrLn "Digite seu CNPJ:"
    else  
      putStrLn "Digite seu CPF:"
    
    codigo <- getLine
    
    putStrLn "Digite seu Nome:"
    nome <- getLine
    
    putStrLn "Escolha seu login:"
    login <- getLine
    
    putStrLn "Escolha uma senha:"
    senha <- getLine

    putStrLn "Digite seu endereço, tudo em uma linha só:"
    endereco <- getLine


    putStrLn "Digite o seu telefone:"
    telefone <- getLine
        
    putStrLn "Digite o seu email:"
    email <- getLine
        
    if(tipoDeUsuario == 2) --cliente
      then cadastraCliente conn nome codigo login senha endereco telefone email
    else cadastraEstabelecimento conn login senha nome email telefone codigo endereco
    
    cadastrarOuLogar conn tipoDeUsuario

telaLogin:: Connection -> Int -> IO()
telaLogin conn tipoDelUsuario = do
    
    putStrLn " ================================= "
    putStrLn "|             LOGIN               |"
    putStrLn " ================================= "

    putStrLn "Digite seu login:"
    login <- getLine
    
    putStrLn "Digite sua senha:"
    senha <- getLine
    
    if tipoDelUsuario == 1 then do
        
        estabelecimento <- getEstabelecimentoPorLoginSenha conn login senha
        
        if null estabelecimento then do
            putStrLn "Erro Login ou senha invalido"
            main
        else 
            mainAdm conn (id_Estabelecimento (head estabelecimento))
    else do
        cliente <- getClientePorLoginSenha conn login senha
        if null cliente then do
            putStrLn "Erro Login ou senha invalido"
            main
        else 
            mainCliente conn (id_cliente (head cliente))
            
erro::IO()
erro = do  
    putStrLn "Dado inválido"