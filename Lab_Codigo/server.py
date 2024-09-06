import socket
import threading
import mflix_pb2
import sys
HOST = '127.0.0.1'
PORT =  65432

class Banco:
    def create(self, Filme):
        print("Criando o Filme", Filme.titulo)
        if Filme.titulo is None:
            return False
        else:
            return True
        
    def read(self, filme):
        print("Lendo o filme", filme.id)
        filme_lido = mflix_pb2.Filme()
        filme_lido.CopyFrom(filme)                  ### está parte será susbtituida pela leitura no banco e dai salva os bagui lido no filme_lido
        if filme_lido is None:
            return None
        else:
            return filme_lido
        
    def update(self, Filme):
        print("Atualizando o nome do Filme", Filme.id, "Para", Filme.titulo)
        if Filme.titulo is None:
            return False
        else:
            return True
        
    def delete(self, Filme):
        print("Deletando Filme" , Filme.id, Filme.titulo)
        if Filme.id is None:
            return False
        else:
            return True
        
banco_de_dados = Banco()

def envia_filme(s ,filme):
    msg = filme.SerializeToString()
    tamanho_mensagem = len(msg).to_bytes(4, 'big')
    s.send(tamanho_mensagem)
#    print("\nEnviado tamanho_mensagem", tamanho_mensagem)
    s.send(msg)
    print("\nEnviado msg", msg)

def envia_confirmacao(s, confirmacao):
    msg = confirmacao.SerializeToString()
    tamanho_mensagem = len(msg).to_bytes(4, 'big')
    s.send(tamanho_mensagem)
#    print("\nEnviado tamanho_mensagem", tamanho_mensagem)
    s.send(msg)
    print("\nEnviado msg de tamanho", len(msg))


def receber_pedido(s):
    tamanho_mensagem_bytes = s.recv(4)
#    print("\nRecebido tamanho_mensagem", tamanho_mensagem_bytes)
    tamanho_mensagem = (tamanho_mensagem_bytes[0] << 24) + (tamanho_mensagem_bytes[1] << 16) + (tamanho_mensagem_bytes[2] << 8) + tamanho_mensagem_bytes[3]
    pedido = mflix_pb2.Pedido()
    pedido_empacotado = s.recv(tamanho_mensagem)
    print("\nRecebido msg de tamanho", tamanho_mensagem)
    pedido.ParseFromString(pedido_empacotado)
    return pedido


def handle_client(conn, addr):
    print(f"Conexão com {addr} estabelecida.")
    connection = 1
    while connection:
        
        pedido = receber_pedido(conn)
            
        confirmacao = mflix_pb2.Confirmacao()
        
        if pedido.op == 1:  # CREATE

            if not pedido.filme.id:
                confirmacao.erro = 1  # Campo ID vazio
                confirmacao.resultado = 0
            elif not pedido.filme.titulo:
                confirmacao.erro = 2  # Campo Título vazio
                confirmacao.resultado = 0
            elif not pedido.filme.diretores:
                confirmacao.erro = 3  # Campo Diretor vazio
                confirmacao.resultado = 0
            elif not pedido.filme.ano:
                confirmacao.erro = 4  # Campo Ano vazio
                confirmacao.resultado = 0
            elif not pedido.filme.generos:
                confirmacao.erro = 5  # Campo Gêneros vazio
                confirmacao.resultado = 0
            elif not pedido.filme.atores:
                confirmacao.erro = 6  # Campo Atores vazio
                confirmacao.resultado = 0
            elif not pedido.filme.duracao:
                confirmacao.erro = 7  # Campo Duração vazio
                confirmacao.resultado = 0

            else:
                resultado = banco_de_dados.create(pedido.filme)
                if resultado == False:
                    confirmacao.resultado = 0
                    confirmacao.erro = 8  # Erro ao criar o filme
                else:
                    confirmacao.filme.CopyFrom(pedido.filme)
                    confirmacao.resultado = 1
            

        elif pedido.op == 2:  # READ

            if not pedido.filme.id:
                confirmacao.erro = 1  # Campo ID vazio
                confirmacao.resultado = 0
            else:
                filme_lido = banco_de_dados.read(pedido.filme)
                if filme_lido is None:
                    confirmacao.resultado = 0
                    confirmacao.erro = 9  # Erro ao ler o filme 
                else:   
                    confirmacao.filme.CopyFrom(filme_lido)
                    confirmacao.resultado = 2

    
        elif pedido.op == 3:  # UPDATE
            if not pedido.filme.id:
                confirmacao.erro = 1  # Campo ID vazio
                confirmacao.resultado = 0
            elif not pedido.filme.titulo:
                confirmacao.erro = 2  # Campo Título vazio
                confirmacao.resultado = 0
            elif not pedido.filme.diretores or any(diretor == "" for diretor in pedido.filme.diretores):
                confirmacao.erro = 3  # Campo Diretor vazio
                confirmacao.resultado = 0
            elif not pedido.filme.ano:
                confirmacao.erro = 4  # Campo Ano vazio
                confirmacao.resultado = 0
            elif not pedido.filme.generos or any(genero == "" for genero in pedido.filme.generos):
                confirmacao.erro = 5  # Campo Gêneros vazio
                confirmacao.resultado = 0
            elif not pedido.filme.atores or any(ator == "" for ator in pedido.filme.atores):
                confirmacao.erro = 6  # Campo Atores vazio
                confirmacao.resultado = 0
            elif not pedido.filme.duracao:
                confirmacao.erro = 7  # Campo Duração vazio
                confirmacao.resultado = 0
            elif any(diretor == "" for diretor in pedido.filme.diretores):
                confirmacao.erro = 12  # Campo Diretor vazio
                confirmacao.resultado = 0
            elif any(genero == "" for genero in pedido.filme.generos):
                confirmacao.erro = 13  # Campo Gêneros vazio
                confirmacao.resultado = 0
            elif any(ator == "" for ator in pedido.filme.atores):
                confirmacao.erro = 14  # Campo Atores vazio
                confirmacao.resultado = 0
            else:
                resultado = banco_de_dados.update(pedido.filme)
                if resultado == False:
                    confirmacao.resultado = 0
                    confirmacao.erro = 10  # Erro ao atualizar o filme
                else:
                    confirmacao.resultado = 3
            

        elif pedido.op == 4:  # DELETE

            if not pedido.filme.id:
                confirmacao.erro = 1  # Campo ID vazio
                confirmacao.resultado = 0
            else:
                resultado = banco_de_dados.delete(pedido.filme)
                if resultado == False:
                    confirmacao.resultado = 0
                    confirmacao.erro = 11  # Erro ao deletar o filme
                else:
                    confirmacao.filme.CopyFrom(pedido.filme)
                    confirmacao.resultado = 4

  
        elif pedido.op == 5: #DESCONECT
            confirmacao.resultado = 5
            connection = 0
            print(f"Conexão com {addr} encerrada.")


        envia_confirmacao(conn, confirmacao)





with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:

    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((HOST, PORT))
    server.listen()
    print(f"Servidor ouvindo em {HOST}:{PORT}")

    while True:
        conn, addr = server.accept()
        thread = threading.Thread(target=handle_client, args=(conn, addr))
        thread.start()

