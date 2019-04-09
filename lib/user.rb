require 'bcrypt'
#
class User
  attr_reader :id, :email

  def initialize(id:, email:)
    @id = id
    @email = email
  end

  def self.create(fullname:, email:, password:)
    encrypted_password = BCrypt::Password.create(password)
    result = DatabaseConnection.query("INSERT INTO users (fullname, email, password) VALUES('#{fullname}', '#{email}', '#{encrypted_password}') RETURNING id, email;")
    User.new(id: result[0]['id'], email: result[0]['email'])
  end

  def self.authenticate(email:, password:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE email = '#{email}'")
    return unless result.any?
    return unless BCrypt::Password.new(result[0]['password']) == password
    User.new(id: result[0]['id'], email: result[0]['email'])
  end
end