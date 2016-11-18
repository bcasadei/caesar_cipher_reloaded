require 'sinatra'
require 'sinatra/reloader' if development?

def create_cipher(key)
  letters = ('a'..'z').to_a
  letters << letters.slice!(0..key - 1)
  letters.flatten
end

def caesar_cipher(string, key)
  alphabet = ('a'..'z').to_a
  cipher = create_cipher(key)

  result = string.chars.map do |char|
      if char.match(/[a-z]/)
        cipher[alphabet.index(char)]
      elsif char.match(/[A-Z]/)
        cipher[alphabet.index(char.downcase)].upcase
      else
        char
      end
  end

  result.join('')
end

def decipher(string, key)
  alphabet = ('a'..'z').to_a
  cipher = create_cipher(key)

  result = string.chars.map do |char|
      if char.match(/[a-z]/)
        alphabet[cipher.index(char)]
      elsif char.match(/[A-Z]/)
        alphabet[cipher.index(char.downcase)].upcase
      else
        char
      end
  end

  result.join('')
end

def filter_errors(cipher, key, ciphertype)
  if cipher.empty?
    :empty_cipher
  elsif key == 0
    :empty_key
  elsif ciphertype == 'decipher'
    :decipher
  else
    :cipher
  end
end

def alert_style(filter)
  case filter
  when :empty_cipher
    'alert-info'
  when :empty_key
    'alert-danger'
  else
    'alert-success'
  end
end

def message(filter, cipher, key)
  case filter
  when :empty_cipher
    'Enter text in the field above to be ciphered or deciphered.'
  when :empty_key
    'Select a key value!'
  when :decipher
    decipher(cipher, key)
  else
    caesar_cipher(cipher, key)
  end
end

get '/' do
  cipher = params["cipher"].to_s
  key = params["key"].to_i
  ciphertype = params["ciphertype"].to_s
  filter = filter_errors(cipher, key, ciphertype)
  results = message(filter, cipher, key)
  alert = alert_style(filter)

  erb :index, :locals => {
    :results => results,
    :alert => alert
  }
end
