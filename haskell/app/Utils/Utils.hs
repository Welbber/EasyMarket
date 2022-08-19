{-# LANGUAGE OverloadedStrings #-}
module Utils.Utils where

completeVazio::String->Int->Int->String
criaEspacoVazio::Int->String

criaEspacoVazio tamanho 
    | tamanho <= 0 = ""
    | otherwise = " " ++ criaEspacoVazio (tamanho - 1)

completeVazio campo quantidadeEsquerda quantidadeDireita = criaEspacoVazio quantidadeEsquerda ++ campo ++ criaEspacoVazio (quantidadeDireita - (length campo) - quantidadeEsquerda)