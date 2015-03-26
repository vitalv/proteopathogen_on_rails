class User < ActiveRecord::Base
  
  attr_accessor :password
  before_save :encrypt_password
  
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
  
  def self.authenticate(session_params)
    user = find_by_email(session_params[:email])
    if user && user.password_hash == BCrypt::Engine.hash_secret(session_params[:password], user.password_salt)
      user
    else
      nil
    end
  end  
  
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end  
  
  def admin?
    #Podria hacer una migracion para poner una columna "role" o "admin"
    #y este metodo comprobaría si esa columna tiene un valor "admin" o "true"
    #pero al fin y al cabo hago lo mismo, que es comprobar un valor de un campo
    if self.id == 1 and self.email == "vital@ucm.es"
      return true  
    else 
      return false
    end
  end
  
end
