# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: mflix.proto

require 'google/protobuf'


descriptor_data = "\n\x0bmflix.proto\x12\x05mflix\"u\n\x05\x46ilme\x12\n\n\x02id\x18\x01 \x01(\t\x12\x0e\n\x06titulo\x18\x02 \x01(\t\x12\x11\n\tdiretores\x18\x03 \x03(\t\x12\x0b\n\x03\x61no\x18\x04 \x01(\x05\x12\x0e\n\x06\x61tores\x18\x05 \x03(\t\x12\x0f\n\x07generos\x18\x06 \x03(\t\x12\x0f\n\x07\x64uracao\x18\x07 \x01(\x05\"?\n\x06Pedido\x12\n\n\x02op\x18\x01 \x01(\x05\x12\x1b\n\x05\x66ilme\x18\x02 \x01(\x0b\x32\x0c.mflix.Filme\x12\x0c\n\x04\x66unc\x18\x03 \x01(\x05\"K\n\x0b\x43onfirmacao\x12\x11\n\tresultado\x18\x01 \x01(\x05\x12\x1b\n\x05\x66ilme\x18\x02 \x01(\x0b\x32\x0c.mflix.Filme\x12\x0c\n\x04\x65rro\x18\x03 \x01(\x05\x62\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool
pool.add_serialized_file(descriptor_data)

module Mflix
  Filme = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("mflix.Filme").msgclass
  Pedido = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("mflix.Pedido").msgclass
  Confirmacao = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("mflix.Confirmacao").msgclass
end
