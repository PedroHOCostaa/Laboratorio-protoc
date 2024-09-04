# Certifique-se de que o arquivo Python gerado está no diretório correto
import pessoa_pb2

# Cria uma nova instância da mensagem Pessoa
pessoa = pessoa_pb2.Pessoa(
    nome="João",
    idade=30,
    altura=2
)

# Exibe as informações da pessoa
print(f"Nome: {pessoa.nome}")
print(f"Idade: {pessoa.idade}")
print(f"Altura: {pessoa.altura}")
