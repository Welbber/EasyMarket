module Models.Adm where
import Database.PostgreSQL.Simple.FromRow

toString::Adm -> String

toString estabelecimento = "ID do Estabelecimento: " ++ show (id_Estabelecimento estabelecimento)  ++ "\nLogin: " ++ login estabelecimento ++ "\nEmail: " ++ email estabelecimento ++ "\nTelefone: " ++ telefone estabelecimento ++ "\nNome: " ++ nome estabelecimento ++ "\nCNPJ: " ++ cnpj estabelecimento ++ "\nEndereço: " ++ endereco estabelecimento

data Adm = Adm {
    id_Estabelecimento:: Int,
    login:: String,
    senha:: String,
    email:: String,
    telefone:: String,
    nome:: String,
    cnpj:: String,
    endereco:: String
} deriving (Show, Read, Eq)

instance FromRow Adm where
    fromRow = Adm <$> field <*> field <*> field <*> field <*> field <*> field <*> field <*> field