
import socket
import mflix_pb2
HOST = '127.0.0.1'
PORT =  65433

def envia_pedido(s ,pedido):
    msg = pedido.SerializeToString()
    tamanho_mensagem = len(msg).to_bytes(4, 'big')
    s.send(tamanho_mensagem)
    print("\nEnviado tamanho_mensagem", tamanho_mensagem)
    s.send(msg)
    print("\nEnviado msg", msg)

def recebe_confirmação(s):
    confirmacao = mflix_pb2.Confirmacao()
    tamanho_mensagem_bytes = s.recv(4)
#   print("\nRecebido file_size_bytes",file_size_bytes)
    tamanho_mensagem = (tamanho_mensagem_bytes[0] << 24) + (tamanho_mensagem_bytes[1] << 16) + (tamanho_mensagem_bytes[2] << 8) + tamanho_mensagem_bytes[3]
    confirmacao_empacotada = s.recv(tamanho_mensagem)
    confirmacao.ParseFromString(confirmacao_empacotada)
    return confirmacao

with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.connect((HOST, PORT))
    connection = 1
    pedido = mflix_pb2.Pedido()
    while(connection == 1):
        pedido.op = int(input(" 1 ---> Create\n 2 ---> Read\n 3 ---> Update\n 4 ---> Delete\n Digite a operação que deseja realizar:"))

        if pedido.op == 1:
            pedido.filme.titulo = input("Digite o titulo do filme a ser criado:")
            envia_pedido(s, pedido)
            confirmacao = recebe_confirmação(s)
            if confirmacao.resultado == 1:
                print("Titulo", confirmacao.filme.titulo, "criado com sucesso")

        elif pedido.op == 2:
            pedido.filme.id = int(input("Digite o id do filme a ser lido:"))
            envia_pedido(s, pedido)
            confirmacao = recebe_confirmação(s)
            if confirmacao.resultado == 1:
                print("Titulo", confirmacao.filme.titulo, "\nId", confirmacao.filme.id, "diretor", confirmacao.filme.diretor)
            else:
                print("Erro ao ler filme")

        elif pedido.op == 3:
            pedido.update = True

        elif pedido.op == 4:
            pedido.delete = True

        elif pedido.op == 5:
            envia_pedido(s, pedido)
            s.recv(len(b'ACK'))
            connection = 0

        else:
            print("Operação Invalida")

