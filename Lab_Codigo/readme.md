## Pacotes necessários
É necessário instalar os pacotes de protoc tanto para python quanto para ruby, para tal, execute os seguintes comandos

pip install protobuf
gem install google-protobuf

## Como executar
Para executar a aplicação abra o terminal e aplique os seguintes comandos:

python server.py
ruby cliente.rb

## Funcionamento
O cliente envia uma mensagem no formato de um objeto de uma classe que foi definida no arquivo .proto, o servidor recebe essa mensagem e imprime o texto contido nela.

## Tecnologias utilizadas
- Ruby
- Python
- Protocol Buffers
```