require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'Validations' do
    before do
      @user = User.new(
        first_name: 'test',
        last_name: 'test',
        email: 'example@email.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    it 'must have a password' do
      @user.password = nil
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Password can't be blank")
    end

    it 'must have a password with a minimum length of 6 characters' do
      @user.password = 'pass'
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Password must be at least 6 characters")
    end

    it 'fails if password and password_confirmation do not match' do
      @user.password_confirmation = 'password1'
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'must have a matching password and password_confirmation' do
      expect(@user).to be_valid
    end

    it 'must have a unique email' do
      @user.save
      user2 = User.new(
        first_name: 'test',
        last_name: 'test',
        email: @user.email,
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include("Email has already been taken")
    end

    it 'emails are NOT case-sensitive' do
      @user.save
      user2 = User.new(
        first_name: 'test',
        last_name: 'test',
        email: 'EXAMPLE@email.com',
        password: 'password',
        password_confirmation: 'password'
      )
      expect(user2).to_not be_valid
      expect(user2.errors.full_messages).to include("Email has already been taken")
    end
  end


  describe '.authenticate_with_credentials' do
    before do
      @user = User.create(
        first_name: 'test',
        last_name: 'test',
        email: 'example@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end
  
    it 'should authenticate the user with the correct email and password' do
      authenticated_user = User.authenticate_with_credentials(@user.email, @user.password)
      expect(authenticated_user).to eq(@user)
    end
  
    it 'should not authenticate the user with the incorrect email or password' do
      authenticated_user = User.authenticate_with_credentials(@user.email, 'wrong_password')
      expect(authenticated_user).to be_nil
    end
  end
  

  describe 'edge cases' do
    before do
      @user = User.create(
        first_name: 'test',
        last_name: 'test',
        email: 'example@example.com',
        password: 'password',
        password_confirmation: 'password'
      )
    end

    it 'should authenticate the user with the correct email and password with spaces' do
      authenticated_user = User.authenticate_with_credentials('   example@example.com', @user.password)
      expect(authenticated_user).to eq(@user)
    end

    it 'should authenticate the user with the correct email with uppercases' do
      authenticated_user = User.authenticate_with_credentials('ExAmPle@EXAMPLE.com', @user.password)
      expect(authenticated_user).to eq(@user)
    end
  end

end
