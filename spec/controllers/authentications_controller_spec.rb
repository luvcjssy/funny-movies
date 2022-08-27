require 'rails_helper'

describe AuthenticationsController, type: :controller do
  describe  'POST #create' do
    context 'register new user' do
      context 'with valid data' do
        it 'returns root path and successfully register user' do
          post :create, params: { username: Faker::Internet.username, password: 'password' }

          expect(User.count).to eq 1
          expect(response).to redirect_to root_path
          expect(session[:user_id]).to_not eq nil
          expect(flash[:notice]).to eq 'Successfully created user'
        end
      end

      context 'with invalid data' do
        it 'returns unprocessable_entity with username is not present' do
          post :create, params: { username: '', password: 'password' }

          expect(session[:user_id]).to eq nil
          expect(flash[:error]).to include "Username can't be blank"
        end

        it 'returns unprocessable_entity with password is not present' do
          post :create, params: { username: Faker::Internet.username, password: '' }

          expect(session[:user_id]).to eq nil
          expect(flash[:error]).to include "Password can't be blank"
        end

        it 'returns unprocessable_entity with password is less than 8 characters' do
          post :create, params: { username: Faker::Internet.username, password: 'pass' }

          expect(session[:user_id]).to eq nil
          expect(flash[:error]).to include 'Password is too short (minimum is 8 characters)'
        end
      end
    end

    context 'login user' do
      let(:user) { create(:user) }

      it 'returns root page with logged in user' do
        post :create, params: { username: user.username, password: 'password' }

        expect(session[:user_id]).to eq user.id
        expect(flash[:notice]).to eq 'Logged in successfully'
      end

      it 'returns unprocessable_entity with wrong password' do
        post :create, params: { username: user.username, password: 'wrong' }

        expect(session[:user_id]).to eq nil
        expect(flash[:error]).to eq 'Invalid username or password'
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'logout user' do
      let(:user) { create(:user) }

      before do
        sign_in_as(user)
      end

      it 'returns root page and session is nil' do
        delete :destroy

        expect(session[:user_id]).to eq nil
        expect(flash[:notice]).to eq 'Logged out'
      end
    end
  end
end
