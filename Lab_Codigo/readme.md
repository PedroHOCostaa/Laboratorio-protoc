# Representação externa de dados utilizando Proto Buffer

Este trabalho consiste em um projeto de sistemas distribuídos para implementar a base de dados Mflix e estabelecer uma comunicação entre cliente e servidor utilizando o protocol buffer. O objetivo é aplicar os conhecimentos adquiridos nas aulas de representação externa de dados.

## Pacotes necessários

É necessário instalar os pacotes de protoc tanto para python quanto para ruby, para tal, execute os seguintes comandos

pip install protobuf
gem install google-protobuf

Também é necessário criar uma conta atlas e baixar o cluter Mflix, disponível em: [https://www.mongodb.com/pt-br/docs/atlas/sample-data/sample-mflix/]

## Como executar

Para executar a aplicação abra o terminal e aplique os seguintes comandos:

1. python server.py
2. ruby cliente.rb
3. Selecione as opções que estão disponíveis ao cliente.

## Funcionamento

A aplicação é dividida em duas partes principais de execução: o servidor e o cliente.

O servidor, feito em Python, é responsável por realizar as operações de CRUD no banco de dados e também pelo tratamento do cliente.

O cliente, feito em ruby tem como função solicitar informações ao servidor. No início da execução, é solicitado ao cliente que selecione uma das seis funcionalidades relacionadas às operações de CRUD. Em seguida, um pacote é enviado via TCP ao servidor, que executa a solicitação e retorna a mensagem ao cliente, também via TCP. Ambos utilizam o protocolo Protocol Buffers.

## Tecnologias utilizadas

- Ruby
- Python
- Protocol Buffers
