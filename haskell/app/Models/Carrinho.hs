module Models.Carrinho where

import Database.PostgreSQL.Simple.FromRow
 

toString::[Carrinho] -> String
somaQuantidadeTotal::[Carrinho] -> Int
somaTotalValor::[Carrinho] -> Float

toString [] = ""
toString (carrinho:[]) = "Id_Cliente: " ++ show (id_cliente carrinho) ++ " | Id_Produto: " ++ show (id_produto carrinho) ++ " | Quantidade Produto: " ++ show (quantidadeDoProduto carrinho) ++ " | Nome Produto: " ++ nomeProduto carrinho ++ " | Preço: " ++ show(preco carrinho) 
toString (carrinho:t) = "Id_Cliente: " ++ show (id_cliente carrinho) ++ " | Id_Produto: " ++ show (id_produto carrinho) ++ " | Quantidade Produto: " ++ show (quantidadeDoProduto carrinho) ++ " | Nome Produto: " ++ nomeProduto carrinho ++ " | Preço: " ++ show(preco carrinho) ++ "\n"++ toString t

somaQuantidadeTotal [] = 0
somaQuantidadeTotal (carrinho:[]) = quantidadeDoProduto carrinho
somaQuantidadeTotal (carrinho:t) = (quantidadeDoProduto carrinho) + somaQuantidadeTotal t

somaTotalValor [] = 0.0
somaTotalValor (carrinho:[]) = (preco carrinho) * (fromIntegral (quantidadeDoProduto carrinho))
somaTotalValor (carrinho:t) = ((preco carrinho) * (fromIntegral (quantidadeDoProduto carrinho))) + somaTotalValor t

data Carrinho = Carrinho {
    id_cliente:: Int,
    id_produto:: Int,
    quantidadeDoProduto:: Int,
    nomeProduto::String,
    preco::Float
} deriving (Show, Read, Eq)

instance FromRow Carrinho where
    fromRow = Carrinho <$> field <*> field <*> field <*> field <*> field 