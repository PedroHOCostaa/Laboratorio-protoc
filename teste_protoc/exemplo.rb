# Certifique-se de que o arquivo Ruby gerado está no diretório correto
require_relative 'pessoa_pb'

# Cria uma nova instância da mensagem Pessoa
pessoa = Pessoa::Pessoa.new(
  nome: "João",
  idade: 30,
  altura: 1.80
)

# Exibe as informações da pessoa
puts "Nome: #{pessoa.nome}"
puts "Idade: #{pessoa.idade}"
puts "Altura: #{pessoa.altura}"
