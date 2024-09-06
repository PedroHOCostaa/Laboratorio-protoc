require 'socket'
require_relative 'mflix_pb'

# Codigo do cliente da atividade de protobuffer, este codigo utiliza mflix_pb.rb para utilizar metodos de marshling e unmarshling que sejam compativeis
# em direfentes linguagens, este cliente foi desenvolvido em ruby e o servidor foi desenvolvido em python, ambos utilizando o protobuffer na comunicação.
# O codigo envia uma mensagem pedido serializado para o servidor e então espera receber uma mensagem confirmacao serializada do servidor.
# Estas mensagem são sobre dados de um banco de dados com a amostra mflix que é abordada no codigo do servidor. Este cliente faz pedido do CRUD para
# o servidor.
# Tanto na estrutura pedido quanto na confirmacao possuimos o campo filme, que é utilizado para enviar dados tanto para o servidor quanto para o cliente.
# A comunicação realizada por sockets tcp ocorre da seguinte forma: 


    # Cliente envia para o servidor #
# ========================================================== #
# tamanho da string serializada do pedido em bytes (4 bytes) #
# ============================================================= #
# string do pedido serializado (tamanho enviado anteriormente)  #
# ============================================================= #

    # Cliente recebe do servidor #
# =============================================================== #
# tamanho da string serializada da confirmação em bytes (4 bytes) #
# ================================================================= #
# string da confirmação serializada (tamanho enviado anteriormente) #
# ================================================================= #


HOST = '127.0.0.1'
PORT = 65432

socket = TCPSocket.new(HOST, PORT)

loop do
  pedido = Mflix::Pedido.new
  pedido.filme = Mflix::Filme.new
  puts "Digite a opção\n Create - 1\t Read - 2\n Update - 3\t Remove - 4\n Quit - 5: "
  pedido.op = gets.chomp.to_i
  
  
  # ============================================================= #
  #               salva os dados em pedido.filme                  #
  # ============================================================= #
  

  case pedido.op                                      # ====== #
  when 1                                              # Create #                  
    puts "Digite o id do filme que será criado: "     # ====== #
    pedido.filme.id = gets.chomp
    puts "Digite o titulo do filme: "
    pedido.filme.titulo = gets.chomp
    puts "Quantidade de diretores"
    qtd_diretores = gets.chomp.to_i
    qtd_diretores.times do
      puts "Digite o nome do diretor: "
      diretor = gets.chomp
      pedido.filme.diretores.push(diretor)        # Adiciona o nome do diretor no array de diretores do filme
    end
    puts "Digite o ano de lançamento do filme: "
    pedido.filme.ano = gets.chomp.to_i    
    puts "Quantidade de atores do filme: "
      qtd_atores = gets.chomp.to_i
      qtd_atores.times do
        puts "Digite o ator do filme: "
        ator = gets.chomp
        pedido.filme.atores.push(ator)            # Adiciona o nome do gênero ao array de gêneros do filme
      end
      
      puts "Quantidade de generos do filme: "
      qtd_generos = gets.chomp.to_i
      qtd_generos.times do
        puts "Digite o genero do filme: "
        genero = gets.chomp
        pedido.filme.generos.push(genero)         # Adiciona o nome do gênero ao array de gêneros do filme
      end
      puts "Digite a duração do filme: "
      pedido.filme.duracao = gets.chomp.to_i
  
                                                  # ==== #
  when 2                                          # Read #
    puts "Digite o id do filme que será lido: "   # ==== #
    pedido.filme.id = gets.chomp

                                                          # ====== #
  when 3                                                  # Update #                  
    puts "Digite o id do filme que será atualizado: "     # ====== #
    pedido.filme.id = gets.chomp
    puts "Digite o titulo do filme: "
    pedido.filme.titulo = gets.chomp

    puts "Quantidade de diretores"
    qtd_diretores = gets.chomp.to_i
    qtd_diretores.times do
      puts "Digite o nome do diretor: "
      diretor = gets.chomp
      pedido.filme.diretores.push(diretor)        # Adiciona o nome do diretor no array de diretores do filme
    end

    puts "Digite o ano de lançamento do filme: "
    pedido.filme.ano = gets.chomp.to_i    

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


                                                        # ====== #
  when 4                                                # Remove #    
    puts "Digite o id do filme a ser deletado: "        # ====== #
    pedido.filme.id = gets.chomp
  
                                                        # ===== #
  when 5                                                # Close #
    puts "Enviar mensagem para terminar conexão"        # ===== #

  else
    puts "Opção inválida"
    pedido.op = 0
    next
  end

                  # ============================================================= #
                  #           envia mensagem do cliente para o servidor           #
                  # ============================================================= #

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
    puts "Diretores: #{confirmacao.filme.diretores}"
    puts "Atores: #{confirmacao.filme.atores}"
    puts "Gêneros: #{confirmacao.filme.generos}"
    puts "Duração: #{confirmacao.filme.duracao}"
    puts "Ano: #{confirmacao.filme.ano}"
  when 2
    puts "Filme lido com sucesso!"
    puts "ID: #{confirmacao.filme.id}"
    puts "Título: #{confirmacao.filme.titulo}"
    puts "Diretores: #{confirmacao.filme.diretores}"
    puts "Atores: #{confirmacao.filme.atores}"
    puts "Gêneros: #{confirmacao.filme.generos}"
    puts "Duração: #{confirmacao.filme.duracao}"
    puts "Ano: #{confirmacao.filme.ano}"
  when 3
    puts "Filme atualizado com sucesso!"
    puts "ID: #{confirmacao.filme.id}"
    puts "Título: #{confirmacao.filme.titulo}"
    puts "Diretores: #{confirmacao.filme.diretores}"
    puts "Atores: #{confirmacao.filme.atores}"
    puts "Gêneros: #{confirmacao.filme.generos}"
    puts "Duração: #{confirmacao.filme.duracao}"
    puts "Ano: #{confirmacao.filme.ano}"
  when 4
    puts "Filme removido com sucesso!"
    puts "ID: #{confirmacao.filme.id}"
  when 5
    puts "Conexão encerrada."
    break
  else
    case confirmacao.erro
    
    when 1
      puts "Campo id vazio"
    when 2
      puts "Campo titulo vazio"
    when 3
      puts "Lista de diretores vazia"
    when 4
      puts "Campo ano vazio"
    when 5
      puts "Lista de generos vazia"
    when 6
      puts "Lista de atores vazia"
    when 7
      puts "Campo duracao vazio"
    when 8
      puts "Erro ao criar filme"
    when 9
      puts "Erro ao ler filme"
    when 10
      puts "Erro ao atualizar filme"
    when 11
      puts "Erro ao remover filme"
    when 12
      puts "Campo de diretores vazio"
    when 13
      puts "Campo de generos vazio"
    when 14
      puts "Campo de atores vazio"
    end
  end
end

socket.close