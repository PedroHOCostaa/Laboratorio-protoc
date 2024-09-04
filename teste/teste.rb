# String original
original_string = "ãõẽ"

# Converte a string para UTF-8
utf8_string = original_string.force_encoding('UTF-8')
puts "UTF-8: #{utf8_string}"

# Converte a string para UTF-16
utf16_string = utf8_string.encode('UTF-16')
puts "UTF-16: #{utf16_string}"

# Converte a string de volta para UTF-8
utf8_again_string = utf16_string.encode('UTF-8')
puts "UTF-8 novamente: #{utf8_again_string}"