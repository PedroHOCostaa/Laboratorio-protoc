require_relative 'pessoa_pb'

# Cria uma nova instância da mensagem Pessoa
pessoa = Pessoa::Pessoa.new(
  nome: "João",
  idade: 30,
  altura: 1.80
)

# Serialização
pessoa_serializada = pessoa.to_proto

# Desserialização
pessoa2 = Pessoa::Pessoa.decode(pessoa_serializada)

# Exibe as informações da pessoa
puts "Nome: #{pessoa.nome}"
puts "Idade: #{pessoa.idade}"
puts "Altura: #{pessoa.altura}"

puts "Nome: #{pessoa2.nome}"
puts "Idade: #{pessoa2.idade}"
puts "Altura: #{pessoa2.altura}"