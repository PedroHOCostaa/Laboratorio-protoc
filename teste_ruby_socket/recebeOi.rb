require 'socket'
require 'thread'

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
      loop do
        # Lê o tamanho da mensagem (assumindo que o tamanho é enviado como um inteiro de 4 bytes)
        size_data = conn.read(4)
        if size_data.nil?
          puts "Erro: não foi possível ler o tamanho da mensagem."
          break
        end

        message_size = size_data.unpack1('L>')  # Desempacota o tamanho como um inteiro de 4 bytes em big-endian
#        puts "Tamanho da mensagem: #{message_size}"

        # Lê a mensagem completa com base no tamanho recebido
        message = conn.read(message_size)
        if message.nil?
          puts "Erro: não foi possível ler a mensagem completa."
          break
        end
        message = message.encode('UTF-8')
        puts "Mensagem recebida: #{message}"

        # Envia a mesma mensagem de volta ao cliente
        conn.write([message.length].pack('L>'))  # Empacota o tamanho da mensagem como um inteiro de 4 bytes em big-endian
        conn.write(message)

        # Verifica se a mensagem é "STOP"
        if message == "STOP"
          puts "Mensagem de parada recebida. Encerrando conexão."
          break
        end

      end
    rescue => e
      puts "Erro na conexão: #{e.message}"
    ensure
      # Fecha a conexão
      conn.close
      puts "Conexão encerrada."
    end
  end
end