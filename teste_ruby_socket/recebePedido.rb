require 'socket'
require 'thread'
require_relative 'mflix_pb'

# Porta onde o servidor vai escutar
HOST = '127.0.0.1'
PORT = 65433

# Cria um socket TCP para o servidor
server = TCPServer.new(PORT)
puts "Servidor escutando na porta #{PORT}..."

# Loop para aceitar conexões de clientes
loop do
  # Aceita uma nova conexão
  client = server.accept
  puts "Cliente conectado!"

  # Cria uma nova thread para lidar com a conexão
  Thread.new(client) do |conn|
    begin
      puts "thread iniciada"
      loop do
        # Lê o tamanho da mensagem (assumindo que o tamanho é enviado como um inteiro de 4 bytes)
        message_size = conn.read(4).unpack1('L>')
        
        puts "Tamanho da mensagem: #{message_size}"

        # Lê a mensagem completa com base no tamanho recebido
        message = conn.read(message_size)
        pedido = Mflix::Pedido.decode(message)

        
#        puts "Mensagem recebida: #{message}"
        confirmacao = Mflix::Confirmacao.new
        confirmacao.filme = Mflix::Filme.new
        
        # Case tratando cada operação
        case pedido.op
        when 1                                          ### Create
          puts "Create"                    
          if pedido.filme.id > 0
            puts pedido.filme.id
            confirmacao.filme.id = pedido.filme.id
            puts pedido.filme.titulo
            confirmacao.filme.titulo = pedido.filme.titulo
            puts pedido.filme.diretor
            confirmacao.filme.diretor = pedido.filme.diretor
            puts pedido.filme.ano 
            confirmacao.filme.ano = pedido.filme.ano
            confirmacao.resultado = 1
          else 
            confirmacao.resultado = -1
          end

        when 2                                          ### Read
          puts "Read"
          if pedido.filme.id > 0
            puts pedido.filme.id
            confirmacao.filme.id = pedido.filme.id
            confirmacao.filme.titulo = "Filme" + pedido.filme.id.to_s
            confirmacao.filme.diretor = "Diretor" + pedido.filme.id.to_s
            confirmacao.filme.ano = 2000 + pedido.filme.id
            confirmacao.resultado = 2
          else 
            confirmacao.resultado = -2
          end

        when 3                                          ### Update       
          puts "Update"           
          if pedido.filme.id > 0
            puts pedido.filme.id
            confirmacao.filme.id = pedido.filme.id
            puts pedido.filme.atores
            confirmacao.filme.atores = pedido.filme.atores
            puts pedido.filme.generos
            confirmacao.filme.generos = pedido.filme.generos
            puts pedido.filme.duracao
            confirmacao.filme.duracao = pedido.filme.duracao
            confirmacao.resultado = 3
          else
            confirmacao.resultado = -3
          end
        
        when 4                                          ### Remove      
          puts "Remove"
          if pedido.filme.id > 0
            puts pedido.filme.id
            confirmacao.filme.id = pedido.filme.id
            confirmacao.resultado = 4
          else
            confirmacao.resultado = -4
          end
        
        when 5
          puts "Mensagem recebida para terminar conexão"
          confirmacao.resultado = 5  
        else
          puts "Opção inválida"
          pedido.op = 0
          next
        end
        

        # Envia a confirmação para o cliente
        msg = confirmacao.to_proto # Faz processo de marshling
        conn.write([msg.bytesize].pack('L>')) # Empacota o tamanho da mensagem como um inteiro de 4 bytes em big-endian
        conn.write(msg)                       # Envia a mensagem

        # Verifica se a mensagem é "STOP"
        if pedido.op == 5
          puts "Mensagem de parada recebida. Encerrando conexão."
          break
        end
      end

    ensure
      # Fecha a conexão
      conn.close
      puts "Conexão encerrada."
    end
  end
end