class AuthorizeApiRequest
  prepend SimpleCommand

  def initialize(headers = {})
    @headers = headers
  end

  def call
    user
  end

  private

  attr_reader :headers

  # o ||=operador é usado para atribuir @useratribuindo "se não nil". Basicamente, se o User.find()retorna um set vazio ou decoded_auth_tokenretorna false, @userserá nil.
  def user
    @user ||= User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user || errors.add(:token, 'Invalid token') && nil
  end

  # decodifica o token recebido http_auth_headere recupera o ID do usuário.
  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  # extrai o token do cabeçalho de autorização recebido na inicialização da classe.
  def http_auth_header
    if headers['Authorization'].present?
      return headers['Authorization'].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end
end