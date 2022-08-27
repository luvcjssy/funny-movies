require 'rails_helper'

describe VideosController, type: :system do
  describe "Videos" do
    context "video page" do
      before do
        create_list(:video, 20)
        visit root_path
      end

      scenario 'return videos list' do
        expect(page).to have_selector('div.card.p-2.m-3', count: 10)
        expect(page).to have_selector('ul.pagination')
      end

      scenario 'return pagination with page 2' do
        expect(all('.page-item')[0]['class']).to include('active')
        visit root_path(page: 2)
        expect(all('.page-item').last['class']).to include('active')
      end
    end

    context 'access new page' do
      scenario 'return video form if user logged in' do
        user = create(:user)
        capybara_sign_in_as(user)
        visit new_video_path

        expect(page).to have_text 'Share a Youtube movie'
      end

      scenario 'return root page with warning message' do
        visit new_video_path

        expect(page).to have_text 'You must be signed in'
      end
    end

    context 'create new video' do
      let(:user) { create(:user) }
      let(:video) { build(:video, user: user) }

      before do
        capybara_sign_in_as(user)
      end

      scenario 'with valid data' do
        click_link 'Share a video'
        fill_in 'video_title', with: video.title
        fill_in 'video_url', with: video.url
        fill_in 'video_description', with: video.description
        click_button 'Share'

        expect(page).to have_text 'Successfully shared video'
      end

      scenario 'return 422 with title is not present' do
        click_link 'Share a video'
        fill_in 'video_title', with: ''
        fill_in 'video_url', with: video.url
        fill_in 'video_description', with: video.description
        click_button 'Share'

        expect(page).to have_text "Title can't be blank"
      end

      scenario 'return 422 with url is not present' do
        click_link 'Share a video'
        fill_in 'video_title', with: video.title
        fill_in 'video_url', with: ''
        fill_in 'video_description', with: video.description
        click_button 'Share'

        expect(page).to have_text "Url can't be blank"
      end

      scenario 'return 422 with url is invalid' do
        click_link 'Share a video'
        fill_in 'video_title', with: video.title
        fill_in 'video_url', with: 'abcxyz'
        fill_in 'video_description', with: video.description
        click_button 'Share'

        expect(page).to have_text "Url is an invalid URL"
      end

      scenario 'return 422 with url is not Youtube url format' do
        click_link 'Share a video'
        fill_in 'video_title', with: video.title
        fill_in 'video_url', with: 'http://vimeo.com/123'
        fill_in 'video_description', with: video.description
        click_button 'Share'

        expect(page).to have_text "Url is not youtube URL"
      end
    end

    context 'access edit page' do
      let(:user) { create :user }
      let(:video) { create :video, user: user }

      scenario 'return video form if user logged in' do
        capybara_sign_in_as(user)
        visit edit_video_path(video)

        expect(page).to have_text 'Share a Youtube movie'
      end

      scenario 'return root page with warning message user not log in' do
        visit edit_video_path(video)

        expect(page).to have_text 'You must be signed in'
      end

      scenario 'return root page with error message if you are not video owner' do
        other_user = create :user
        capybara_sign_in_as(other_user)
        visit edit_video_path(video)

        expect(page).to have_text "You are not permitted to perform this action"
      end
    end

    context 'update video' do
      let(:user) { create(:user) }
      let(:video) { create(:video, user: user) }

      context 'with owner video permission' do
        before do
          capybara_sign_in_as(user)
        end

        scenario 'with valid data' do
          visit edit_video_path(video)
          expect(page).to have_text "Share a Youtube movie"
          fill_in 'video_title', with: video.title
          fill_in 'video_url', with: video.url
          fill_in 'video_description', with: video.description
          click_button 'Share'

          expect(page).to have_text 'Successfully updated video'
        end

        scenario 'return 422 with title is not present' do
          visit edit_video_path(video)
          expect(page).to have_text "Share a Youtube movie"
          fill_in 'video_title', with: ''
          fill_in 'video_url', with: video.url
          fill_in 'video_description', with: video.description
          click_button 'Share'

          expect(page).to have_text "Title can't be blank"
        end

        scenario 'return 422 with url is not present' do
          visit edit_video_path(video)
          expect(page).to have_text "Share a Youtube movie"
          fill_in 'video_title', with: video.title
          fill_in 'video_url', with: ''
          fill_in 'video_description', with: video.description
          click_button 'Share'

          expect(page).to have_text "Url can't be blank"
        end

        scenario 'return 422 with url is invalid' do
          visit edit_video_path(video)
          expect(page).to have_text "Share a Youtube movie"
          fill_in 'video_title', with: video.title
          fill_in 'video_url', with: 'abcxyz'
          fill_in 'video_description', with: video.description
          click_button 'Share'

          expect(page).to have_text "Url is an invalid URL"
        end

        scenario 'return 422 with url is not Youtube url format' do
          visit edit_video_path(video)
          expect(page).to have_text "Share a Youtube movie"
          fill_in 'video_title', with: video.title
          fill_in 'video_url', with: 'http://vimeo.com/123'
          fill_in 'video_description', with: video.description
          click_button 'Share'

          expect(page).to have_text "Url is not youtube URL"
        end
      end

      context 'with other user' do
        scenario 'return root page with error message if you are not video owner' do
          other_user = create :user
          capybara_sign_in_as(other_user)

          visit edit_video_path(video)
          expect(page).to have_text "You are not permitted to perform this action"
        end
      end
    end

    context 'delete video' do
      before do
        @user = create :user
        @video = create :video, user: @user
      end

      scenario 'return root page with message delete video successfully' do
        capybara_sign_in_as(@user)
        find("a.delete_video_#{@video.id}").click
        al = page.driver.browser.switch_to.alert
        expect(al.text).to eq("Are you sure?")
        al.accept
        expect(page).to have_text 'Successfully deleted video'
      end

      scenario 'return root page with error message if you are not video owner' do
        other_user = create :user
        capybara_sign_in_as(other_user)
        expect(page).to have_no_css ".delete_video_#{@video.id}"
      end
    end
  end
end
