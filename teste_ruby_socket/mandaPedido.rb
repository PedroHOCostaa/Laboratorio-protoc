require 'socket'
require_relative 'mflix_pb'

HOST = '127.0.0.1'
PORT = 65433

socket = TCPSocket.new(HOST, PORT)

loop do
  pedido = Mflix::Pedido.new
  pedido.filme = Mflix::Filme.new
  puts "Digite a opção\n Create - 1\t Read - 2\n Update - 3\t Remove - 4\n Quit - 5: "
  pedido.op = gets.chomp.to_i
  
  case pedido.op
  when 1                                          ### Create                    
    puts "Digite o id do filme: "
    pedido.filme.id = gets.chomp.to_i
    puts "Digite o titulo do filme: "
    pedido.filme.titulo = gets.chomp
    puts "Digite o nome do diretor do filme: "
    pedido.filme.diretor = gets.chomp
    puts "Digite o ano de lançamento do filme: "
    pedido.filme.ano = gets.chomp.to_i    
      
  when 2                                          ### Read
    puts "Digite o id do filme: "
    pedido.filme.id = gets.chomp.to_i

  when 3                                          ### Update                  
    puts "Digite o id do filme: "
    pedido.filme.id = gets.chomp.to_i
    puts "Quantidade de atores do filme: "
    qtd_atores = gets.chomp.to_i
    qtd_atores.times do
      puts "Digite o ator do filme: "
      ator = gets.chomp
      pedido.filme.atores.push(ator)  # Adiciona o nome do gênero ao array de gêneros do pedido
    end
    
    puts "Quantidade de generos do filme: "
    qtd_generos = gets.chomp.to_i
    qtd_generos.times do
      puts "Digite o genero do filme: "
      genero = gets.chomp
      pedido.filme.generos.push(genero)  # Adiciona o nome do gênero ao array de gêneros do pedido
    end
    puts "Digite a duração do filme: "
    pedido.filme.duracao = gets.chomp.to_i

  when 4                                          ### Remove      
    puts "Digite o id do filme: "
    pedido.filme.id = gets.chomp.to_i
  
  when 5
    puts "Enviar mensagem para terminar conexão"

  else
    puts "Opção inválida"
    pedido.op = 0
    next
  end

  msg = pedido.to_proto
  socket.write([msg.bytesize].pack('L>'))
  print "enviado #{msg.length} com 4 bytes\n"
  socket.write(msg)
  print "enviado #{msg.unpack1('H*')} com #{msg.length}bytes\n"


  tamanhoResposta = socket.read(4).unpack1('L>')
  msg = socket.read(tamanhoResposta)
  confirmacao = Mflix::Confirmacao.decode(msg)
    

  case confirmacao.resultado
  when 1
    puts "Filme criado com sucesso!"
    puts "ID: #{confirmacao.filme.id}"
    puts "Título: #{confirmacao.filme.titulo}"
    puts "Diretor: #{confirmacao.filme.diretor}"
    puts "Ano: #{confirmacao.filme.ano}"
  when 2
    puts "Filme lido com sucesso!"
    puts "ID: #{confirmacao.filme.id}"
    puts "Título: #{confirmacao.filme.titulo}"
    puts "Diretor: #{confirmacao.filme.diretor}"
    puts "Ano: #{confirmacao.filme.ano}"
  when 3
    puts "Filme atualizado com sucesso!"
    puts "ID: #{confirmacao.filme.id}"
    puts "Atores: #{confirmacao.filme.atores}"
    puts "Gêneros: #{confirmacao.filme.generos}"
    puts "Duração: #{confirmacao.filme.duracao}"
  when 4
    puts "Filme removido com sucesso!"
    puts "ID: #{confirmacao.filme.id}"
  when 5
    puts "Conexão encerrada."
    break
  else
    puts "Erro ao processar a solicitação, retorno #{confirmacao.resultado}."
  end
end

socket.close