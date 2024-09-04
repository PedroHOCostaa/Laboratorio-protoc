require 'socket'

HOST = '127.0.0.1'
PORT = 65433

socket = TCPSocket.new(HOST, PORT)

loop do
  puts "Digite a mensagem a ser enviada: "
  msg = gets.chomp.encode('UTF-8')
  socket.write([msg.bytesize].pack('L>'))
#  print "enviado #{msg.length} com 4 bytes\n"
  socket.write(msg)
#  print "enviado #{msg} com #{msg.length}bytes\n"
  tamanhoResposta = socket.read(4).unpack1('L>')
  resposta = socket.read(tamanhoResposta)
  puts "Tamanho mensagem recebida: #{tamanhoResposta}, mensagem recebida: #{resposta}"
  if msg == "STOP"
    puts "STOP recebido do servidor. Encerrando conexão."
    break
  end
end