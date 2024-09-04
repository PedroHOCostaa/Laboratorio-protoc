require 'google/protobuf'
require './person_pb'

# Criar uma nova instância de Person
person = Person.new(
  name: "John Doe",
  id: 1234,
  email: "john.doe@example.com"
)

# Serializar a mensagem para uma string binária
serialized_person = person.encode

# Desserializar a mensagem de volta para um objeto Person
deserialized_person = Person.decode(serialized_person)

# Exibir as informações
puts "Name: #{deserialized_person.name}"
puts "ID: #{deserialized_person.id}"
puts "Email: #{deserialized_person.email}"
