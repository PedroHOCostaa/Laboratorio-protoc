require 'socket'
require 'google/protobuf'
require_relative 'mflix_pb' # Ajuste o caminho conforme necessário

HOST = '127.0.0.1'
PORT = 65433

def envia_pedido(socket, pedido)
  msg = pedido.to_proto
  tamanho_mensagem = [msg.size].pack('N')
  socket.write(tamanho_mensagem)
  puts "\nEnviado tamanho_mensagem: #{tamanho_mensagem.inspect}"
  socket.write(msg)
  puts "\nEnviado msg: #{msg.inspect}"
end

def recebe_confirmacao(socket)
  tamanho_mensagem_bytes = socket.read(4)
  tamanho_mensagem = tamanho_mensagem_bytes.unpack1('N')
  confirmacao_empacotada = socket.read(tamanho_mensagem)
  confirmacao = Mflix::Confirmacao.decode(confirmacao_empacotada)
  confirmacao
end

# Conexão com o servidor
socket = TCPSocket.new(HOST, PORT)

connection = 1

while connection == 1
  pedido = Mflix::Pedido.new

  print "1 ---> Create\n2 ---> Read\n3 ---> Update\n4 ---> Delete\nDigite a operação que deseja realizar: "
  pedido.op = gets.to_i

  case pedido.op
  when 1
    print "Digite o título do filme a ser criado: "
    pedido.filme.titulo = gets.chomp
    print "Digite o ID do filme: "
    pedido.filme.id = gets.to_i
    print "Digite o diretor do filme: "
    pedido.filme.diretor = gets.chomp
    print "Digite o ano de lançamento do filme: "
    pedido.filme.ano = gets.to_i
    print "Digite a duração do filme em minutos: "
    pedido.filme.duracao = gets.to_f

    atores = []
    print "Digite os atores do filme (separe por vírgula): "
    atores = gets.chomp.split(',').map(&:strip)
    pedido.filme.atores.concat(atores)

    generos = []
    print "Digite os gêneros do filme (separe por vírgula): "
    generos = gets.chomp.split(',').map(&:strip)
    pedido.filme.genero.concat(generos)

    envia_pedido(socket, pedido)
    confirmacao = recebe_confirmacao(socket)
    if confirmacao.resultado == 1
      puts "Título '#{confirmacao.filme.titulo}' criado com sucesso"
    end

  when 2
    print "Digite o ID do filme a ser lido: "
    pedido.filme.id = gets.to_i
    envia_pedido(socket, pedido)
    confirmacao = recebe_confirmacao(socket)
    if confirmacao.resultado == 1
      filme = confirmacao.filme
      puts "Título: '#{filme.titulo}'"
      puts "ID: #{filme.id}"
      puts "Diretor: #{filme.diretor}"
      puts "Ano: #{filme.ano}"
      puts "Duração: #{filme.duracao} minutos"
      puts "Atores: #{filme.atores.join(', ')}"
      puts "Gêneros: #{filme.genero.join(', ')}"
    else
      puts "Erro ao ler filme"
    end

  when 3
    pedido.update = true

  when 4
    pedido.delete = true

  when 5
    envia_pedido(socket, pedido)
    socket.recv(3) # Assumindo que ACK tem 3 bytes
    connection = 0

  else
    puts "Operação Inválida"
  end
end

socket.close
