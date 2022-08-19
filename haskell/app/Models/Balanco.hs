module Models.Balanco where

import Database.PostgreSQL.Simple.FromRow
import Utils.Utils

toString::[Balanco] -> String
toStringHeader:: String
formataLinha::[Balanco] -> String

toStringHeader =  "|" ++ completeVazio "ID Clien." 1 10 ++ "|" ++ completeVazio "Id Compra" 1 11 ++ "|" ++ completeVazio "Nome Cliente" 1 15 ++ "|" ++ completeVazio "Tele. Clien." 1 13 ++ "|" ++ completeVazio "E-mail Cliente" 10 31 ++ "|" ++ completeVazio "Quant. Prod. Compr. " 1 19 ++ "|" ++ completeVazio "Tipo Pagamento" 1 16 ++ "|" ++ completeVazio "Total Comp." 1 13 ++  "|" ++ completeVazio "Data Compr." 1 13 ++ "|\n"
toString [] = toStringHeader
toString balanco = toStringHeader ++ formataLinha balanco

formataLinha (balanco:[]) = "|" ++ completeVazio (show (id_cliente balanco)) 4 10  ++ "|" ++ completeVazio (show (id_compra balanco)) 4 11 ++ "|" ++ completeVazio (nome balanco) 1 15 ++ "|" ++ completeVazio (telefone balanco) 1 13 ++ "|" ++ completeVazio (email balanco) 1 31  ++ "|" ++ completeVazio (show (quantidadeDeProdutos balanco)) 7 21 ++ "|" ++ completeVazio (tipoPagamento balanco) 1 16 ++ "|" ++ completeVazio (show (totalCompra balanco)) 4 13  ++ "|" ++ completeVazio (show (dataPagamento balanco)) 1 12 ++ "|\n"
formataLinha (balanco:t) = "|" ++ completeVazio (show (id_cliente balanco)) 4 10  ++ "|" ++ completeVazio (show (id_compra balanco)) 4 11 ++ "|" ++ completeVazio (nome balanco) 1 15 ++ "|" ++ completeVazio (telefone balanco) 1 13 ++ "|" ++ completeVazio (email balanco) 1 31  ++ "|" ++ completeVazio (show (quantidadeDeProdutos balanco)) 7 21 ++ "|" ++ completeVazio (tipoPagamento balanco) 1 16 ++ "|" ++ completeVazio (show (totalCompra balanco)) 4 13  ++ "|" ++ completeVazio (show (dataPagamento balanco)) 1 12 ++ "|\n" ++ formataLinha t


data Balanco = Balanco {
    id_cliente:: Int,
    id_compra:: Int,
    nome:: String,
    telefone::String,
    email::String,
    quantidadeDeProdutos:: Int,
    tipoPagamento:: String,
    totalCompra::Float,
    dataPagamento:: String
} deriving (Show, Read, Eq)

instance FromRow Balanco where
    fromRow = Balanco <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field