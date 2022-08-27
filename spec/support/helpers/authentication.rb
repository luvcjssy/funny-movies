module Helpers
  module Authentication
    def sign_in_as(user)
      session[:user_id] = user&.id
    end

    def capybara_sign_in_as(user)
      visit root_path
      fill_in "username", with: user.username
      fill_in "password", with: user.password
      click_button "Login / Register"

      expect(page).to have_text "Logged in successfully"
      expect(page).to have_text "Welcome #{user.username}"
    end
  end
end
