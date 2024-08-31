import person_pb2

# Create a new Person instance
person = person_pb2.Person()
person.name = "John Doe"
person.id = 1234
person.email = "johndoe@example.com"

# Serialize to a binary format
serialized_person = person.SerializeToString()

# Write the serialized object to a file
with open('person.bin', 'wb') as f:
    f.write(serialized_person)

# Read the serialized object from the file
with open('person.bin', 'rb') as f:
    serialized_person_from_file = f.read()

# Deserialize from the binary format
new_person = person_pb2.Person()
new_person.ParseFromString(serialized_person_from_file)

print(f'Name: {new_person.name}')
print(f'ID: {new_person.id}')
print(f'Email: {new_person.email}')