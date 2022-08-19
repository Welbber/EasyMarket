
module Models.Cliente where

import Database.PostgreSQL.Simple.FromRow

toString::Cliente -> String

toString cliente = "Id_Cliente: " ++ show (id_cliente cliente) ++ "\nNome: " ++ nome cliente ++ "\nCPF: " ++ cpf cliente ++ "\nLogin: " ++ login cliente ++ "\nEndereco: " ++ endereco cliente ++ "\nTelefone: " ++ telefone cliente ++ "\nEmail: " ++ email cliente

data Cliente = Cliente {
    id_cliente:: Int,
    nome:: String,
    cpf:: String,
    login:: String,
    senha:: String,
    endereco:: String,
    telefone:: String,
    email:: String
} deriving (Show, Read, Eq)

instance FromRow Cliente where
    fromRow = Cliente <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field
