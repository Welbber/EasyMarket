module Models.Compra where
import Database.PostgreSQL.Simple.FromRow
import Utils.Utils
toString::Compra -> String

toString compra = "ID da compra: " ++ show (id_Compra compra) ++ "\nTipo de pagamento: " ++ tipoPagamento compra ++ "\nData de pagamento: " ++ dataPagamento compra ++  "\nTotal da compra: R$ " ++ show (totalCompra compra) ++ "\nID do cliente: " ++ show (id_Cliente compra)

toStringHeader:: String
toStringHeader = "|" ++ completeVazio "ID" 2 6 ++ "|" ++ completeVazio "Tipo de pagamento" 5 25 ++ "|" ++ completeVazio "Data do pagamento" 5 25 ++ "|" ++ completeVazio "Total da compra" 5 25 ++ "|" ++ completeVazio "ID do cliente" 5 23 ++ "|"

toStringList::[Compra] -> String
toStringList [] = toStringHeader
toStringList compra = toStringHeader ++ "\n" ++ formataLinha compra

formataLinha::[Compra] -> String
formataLinha (compra:[]) = "|" ++ completeVazio (show (id_Compra compra)) 2 6  ++ "|" ++ completeVazio (tipoPagamento compra) 2 25 ++ "|" ++ completeVazio (dataPagamento compra) 5 24 ++ " |" ++ completeVazio (show (totalCompra compra)) 8 25 ++ "|" ++ completeVazio (show (id_Cliente compra)) 10 23 ++ "|\n"
formataLinha (compra:t) = "|" ++ completeVazio (show (id_Compra compra)) 2 6  ++ "|" ++ completeVazio (tipoPagamento compra) 2 25 ++ "|" ++ completeVazio (dataPagamento compra) 5 24 ++ " |" ++ completeVazio (show (totalCompra compra)) 8 25 ++ "|" ++ completeVazio (show (id_Cliente compra)) 10 23 ++ "|\n" ++ formataLinha t


data Compra = Compra {
    id_Compra:: Int,
    tipoPagamento:: String,
    dataPagamento:: String, 
    totalCompra:: Float,
    id_Cliente:: Int
} deriving (Show, Read, Eq)

instance FromRow Compra where
    fromRow = Compra <$> field <*> field <*> field <*> field <*> field 