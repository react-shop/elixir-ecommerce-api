class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end
 
    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
 end

# O primeiro método, encodeusa três parâmetros - o ID do usuário, o prazo de expiração (1 dia) e a chave base exclusiva do aplicativo Rails - para criar um token exclusivo.
# O segundo método, decodepega o token e usa a chave secreta do aplicativo para decodificá-lo.

# Aqui estão os dois casos em que esses métodos serão usados:
  
# Para autenticar o usuário e gerar um token para ele / ela usando encode.
# Para verificar se o token do usuário anexado em cada solicitação está correto usando decode.
# Para garantir que tudo funcionará, o conteúdo do libdiretório deve ser incluído quando o aplicativo Rails for carregado.