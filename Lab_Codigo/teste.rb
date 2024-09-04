require 'google/protobuf'
require_relative 'mflix_pb'  # Ajuste o caminho conforme necessário

# Criar uma nova mensagem Filme
filme = Mflix::Filme.new(
  id: 1,
  titulo: 'Inception',
  diretor: 'Christopher Nolan',
  ano: 2010,
  atores: ['Leonardo DiCaprio', 'Joseph Gordon-Levitt'],
  genero: ['Sci-Fi', 'Action'],
  duracao: 148.0
)

# Mostrar o filme
puts "Filme:"
puts "ID: #{filme.id}"
puts "Título: #{filme.titulo}"
puts "Diretor: #{filme.diretor}"
puts "Ano: #{filme.ano}"
puts "Atores: #{filme.atores.join(', ')}"
puts "Gêneros: #{filme.genero.join(', ')}"
puts "Duração: #{filme.duracao} minutos"

# Criar uma nova mensagem Pedido
pedido = Mflix::Pedido.new(
  op: 1,
  filme: filme
)

# Mostrar o pedido
puts "\nPedido:"
puts "Operação: #{pedido.op}"
puts "Filme: #{pedido.filme.titulo}"

# Criar uma nova mensagem Confirmacao
confirmacao = Mflix::Confirmacao.new(
  resultado: 0,
  filme: filme
)

# Mostrar a confirmação
puts "\nConfirmação:"
puts "Resultado: #{confirmacao.resultado}"
puts "Filme: #{confirmacao.filme.titulo}"
