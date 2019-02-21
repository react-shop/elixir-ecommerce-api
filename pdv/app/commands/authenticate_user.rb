class AuthenticateUser
  prepend SimpleCommand

  def initialize(username, password)
    @username = username
    @password = password
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  attr_accessor :username, :password

  def user
    user = User.find_by_username(username)
    return user if user && user.authenticate(password)

    errors.add :user_authentication, 'invalid credentials'
    nil
  end
end

# O comando leva os parâmetros e inicializa uma instância de classe com emaile passwordatributos que são acessíveis dentro da classe. O método privado userusa as credenciais para verificar se o usuário existe no banco de dados usando User.find_by.

# Se o usuário for encontrado, o método usa o authenticatemétodo interno. Esse método pode ser disponibilizado colocando-se has_secure_password no modelo User para verificar se a senha do usuário está correta. Se tudo for verdade, o usuário será retornado. Caso contrário, o método retornará nil.