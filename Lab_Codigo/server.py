import socket
import threading
import mflix_pb2
import sys
HOST = '127.0.0.1'
PORT =  65433

class Banco:
    def create(self, Filme):
        print("Criando o Filme", Filme.titulo)
        return Filme.titulo
    def read(self, Filme):
        print("Lendo o filme", Filme.id)
        return Filme
    def update(self, Filme):
        print("Atualizando o nome do Filme", Filme.id, "Para", Filme.titulo)
    def delete(self, Filme):
        print("Deletando Filme" , Filme.id, Filme.titulo)

banco_de_dados = Banco()

def envia_filme(s ,filme):
    msg = filme.SerializeToString()
    tamanho_mensagem = len(msg).to_bytes(4, 'big')
    s.send(tamanho_mensagem)
    print("\nEnviado tamanho_mensagem", tamanho_mensagem)
    s.send(msg)
    print("\nEnviado msg", msg)

def envia_confirmacao(s, confirmacao):
    msg = confirmacao.SerializeToString()
    tamanho_mensagem = len(msg).to_bytes(4, 'big')
    s.send(tamanho_mensagem)
    print("\nEnviado tamanho_mensagem", tamanho_mensagem)
    s.send(msg)
    print("\nEnviado msg", msg)


def receber_pedido(s):
    tamanho_mensagem_bytes = s.recv(4)
    print("\nRecebido tamanho_mensagem", tamanho_mensagem_bytes)
    tamanho_mensagem = (tamanho_mensagem_bytes[0] << 24) + (tamanho_mensagem_bytes[1] << 16) + (tamanho_mensagem_bytes[2] << 8) + tamanho_mensagem_bytes[3]
    pedido = mflix_pb2.Pedido()
    pedido_empacotado = s.recv(tamanho_mensagem)
    pedido.ParseFromString(pedido_empacotado)
    return pedido


def handle_client(conn, addr):
    connection = 1
    while connection:
        
        pedido = receber_pedido(conn)
            
        confirmacao = mflix_pb2.Confirmacao()

        if pedido.op == 1:  # CREATE
            confirmacao.filme.titulo = banco_de_dados.create(pedido.filme)
            confirmacao.resultado = 1
            envia_confirmacao(conn, confirmacao)
        elif pedido.op == 2:  # READ
            filme_lido = banco_de_dados.read(pedido.filme)
            if filme_lido.id == -1:
                confirmacao.resultado = 0
            else:
                confirmacao.filme.CopyFrom(filme_lido)
                confirmacao.resultado = 1
            envia_confirmacao(conn, confirmacao)
            envia_filme(conn, filme_lido)
        elif pedido.op == 3:  # UPDATE
            banco_de_dados.update(pedido.filme)
        elif pedido.op == 4:  # DELETE
            banco_de_dados.delete(pedido.filme)
        elif pedido.op == 5: #DESCONECT
            conn.send(b'ACK')
            connection = 0
        else:
            print("Pedido inválido")





with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:

    server.bind((HOST, PORT))
    server.listen()

    while True:
        conn, addr = server.accept()
        thread = threading.Thread(target=handle_client, args=(conn, addr))
        thread.start()

