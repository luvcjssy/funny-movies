require 'rails_helper'

describe AuthenticationsController, type: :system do
  describe 'Authentication' do
    before do
      visit root_path
    end

    context 'register new user' do
      scenario 'with valid data' do
        fill_in 'username', with: 'example'
        fill_in 'password', with: 'password'
        click_button 'Login / Register'

        expect(page).to have_text 'Successfully created user'
        expect(page).to have_text 'Welcome example'
      end

      scenario 'with username is not present' do
        fill_in 'username', with: ''
        fill_in 'password', with: 'password'
        click_button 'Login / Register'

        expect(page).to have_text "Username can't be blank"
      end

      scenario 'with password is not present' do
        fill_in 'username', with: 'example'
        fill_in 'password', with: ''
        click_button 'Login / Register'

        expect(page).to have_text "Password can't be blank"
      end

      scenario 'with password is less than 8 characters' do
        fill_in 'username', with: 'example'
        fill_in 'password', with: 'pass'
        click_button 'Login / Register'

        expect(page).to have_text 'Password is too short (minimum is 8 characters)'
      end
    end

    context 'login user' do
      let(:user) { create(:user) }

      scenario 'successfully' do
        fill_in 'username', with: user.username
        fill_in 'password', with: user.password
        click_button 'Login / Register'

        expect(page).to have_text 'Logged in successfully'
        expect(page).to have_text "Welcome #{user.username}"
      end

      scenario 'returns unprocessable_entity with wrong password' do
        fill_in 'username', with: user.username
        fill_in 'password', with: 'wrong_password'
        click_button 'Login / Register'

        expect(page).to have_text 'Invalid username or password'
      end
    end

    context 'logout user' do
      let(:user) { create(:user) }

      before do
        capybara_sign_in_as(user)
      end

      scenario 'returns root page and session in nil' do
        expect(page).to have_text 'Share a video'
        expect(page).to have_text 'Logout'

        click_link 'Logout'

        expect(page).to have_text 'Logged out'
      end
    end
  end
end
