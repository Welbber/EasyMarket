module Models.Produto where
import Database.PostgreSQL.Simple.FromRow
import Utils.Utils

toString::Produto -> String
toStringList::[Produto] -> String
toStringHeader:: String
formataLinha::[Produto] -> String

toStringHeader =  "|" ++ completeVazio "ID" 2 6 ++ "|" ++ completeVazio "Nome" 5 25 ++ "|" ++ completeVazio "Preço" 2 10 ++ "|" ++ completeVazio "Descrição" 10 30 ++ "|" ++ completeVazio "Quantidade Disponível" 1 20 ++ "|" ++ completeVazio "ID do estabelecimento" 1 25 ++ "|"

toString produto = "ID do produto: " ++ show (id_Produto produto)  ++ "\nNome: " ++ nome produto ++ "\nPreço: " ++ show (preco produto) ++ "\nDescrição: " ++ descricao produto ++ "\nQuantidade no Estoque: " ++ show (quantidadeEstoque produto) ++ "\nID do estabelecimento: " ++ show (id_Estabelecimento produto) 

toStringList [] = toStringHeader
toStringList produto = toStringHeader ++ "\n" ++ formataLinha produto

formataLinha (produto:[]) = "|" ++ completeVazio (show (id_Produto produto)) 2 6  ++ "|" ++ completeVazio (nome produto) 2 25 ++ "|" ++ completeVazio (show (preco produto)) 2 9 ++ " |" ++ completeVazio (descricao produto) 1 30 ++ "|" ++ completeVazio (show (quantidadeEstoque produto)) 10 22 ++ "|" ++ completeVazio (show (id_Estabelecimento produto)) 10 25 ++ "|\n" 
formataLinha (produto:t) = "|" ++ completeVazio (show (id_Produto produto)) 2 6  ++ "|" ++ completeVazio (nome produto) 2 25 ++ "|" ++ completeVazio (show (preco produto)) 2 9 ++ " |" ++ completeVazio (descricao produto) 1 30 ++ "|" ++ completeVazio (show (quantidadeEstoque produto)) 10 22 ++ "|" ++ completeVazio (show (id_Estabelecimento produto)) 10 25 ++ "|\n" ++ formataLinha t

data Produto = Produto {
    id_Produto:: Int,
    nome:: String,
    preco:: Float,
    descricao:: String,
    categoria:: String,
    quantidadeEstoque:: Int,
    id_Estabelecimento:: Int
} deriving (Show, Read, Eq)

instance FromRow Produto where
    fromRow = Produto <$> field <*> field <*> field <*> field <*> field <*> field <*> field 
