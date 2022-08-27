require 'rails_helper'

describe VideosController, type: :controller do
  describe 'GET #index' do
    let(:videos) { create_list(:video, 20) }

    it 'returns videos list' do
      get :index

      expect(response).to have_http_status 200
    end
  end

  describe 'GET #new' do
    it 'returns new page if user logged in' do
      user = create(:user)
      sign_in_as(user)
      get :new

      expect(response).to have_http_status 200
    end

    it 'returns root page with warning message if guest user' do
      get :new

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You must be signed in'
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    let(:video) { build(:video, user: user) }

    it 'returns error message if user not log in' do
      post :create, params: { video: { title: video.title, url: video.url, description: video.description } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You must be signed in'
    end

    context 'valid data' do
      before do
        sign_in_as(user)
      end

      it 'returns root page with successfully created video' do
        post :create, params: { video: { title: video.title, url: video.url, description: video.description } }

        expect(Video.count).to eq 1
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq 'Successfully shared video'
      end
    end

    context 'invalid data' do
      before do
        sign_in_as(user)
      end

      it 'returns 422 with title is not present' do
        post :create, params: { video: { title: '', url: video.url, description: video.description } }

        expect(response).to have_http_status 422
        expect(flash[:error]).to include "Title can't be blank"
      end

      it 'returns 422 with url is not present' do
        post :create, params: { video: { title: video.title, url: '', description: video.description } }

        expect(response).to have_http_status 422
        expect(flash[:error]).to include "Url can't be blank"
      end

      it 'returns 422 with url is invalid' do
        post :create, params: { video: { title: video.title, url: 'video.url', description: video.description } }

        expect(response).to have_http_status 422
        expect(flash[:error]).to include "Url is an invalid URL"
      end

      it 'returns 422 with url is not Youtube url format' do
        post :create, params: { video: { title: video.title, url: 'http://video.url/123', description: video.description } }

        expect(response).to have_http_status 422
        expect(flash[:error]).to include "Url is not youtube URL"
      end
    end
  end

  describe 'GET #edit' do
    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }

    it 'returns edit page if user logged in' do
      sign_in_as(user)
      get :edit, params: { id: video.id }

      expect(response).to have_http_status 200
    end

    it 'returns root page with warning message user not log in' do
      get :edit, params: { id: video.id }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You must be signed in'
    end

    it 'returns root page with error message if you are not owner' do
      other_user = create(:user)
      sign_in_as(other_user)
      get :edit, params: { id: video.id }

      expect(response).to redirect_to root_path
      expect(flash[:error]).to eq 'You are not permitted to perform this action'
    end
  end

  describe 'PUT #update' do
    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }

    it 'returns error message if user not log in' do
      put :update, params: { id: video.id, video: { title: video.title, url: video.url, description: video.description } }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You must be signed in'
    end

    context 'valid data' do
      before do
        sign_in_as(user)
      end

      it 'returns root page with successfully updated video' do
        put :update, params: { id: video.id, video: { title: 'New title', url: video.url, description: video.description } }
        video.reload

        expect(video.title).to eq 'New title'
        expect(response).to redirect_to root_path
        expect(flash[:notice]).to eq 'Successfully updated video'
      end
    end

    context 'invalid data' do
      before do
        sign_in_as(user)
      end

      it 'returns 422 with title is not present' do
        put :update, params: { id: video.id, video: { title: '', url: video.url, description: video.description } }

        expect(response).to have_http_status 422
        expect(flash[:error]).to include "Title can't be blank"
      end

      it 'returns 422 with url is not present' do
        put :update, params: { id: video.id, video: { title: 'New title', url: '', description: video.description } }

        expect(response).to have_http_status 422
        expect(flash[:error]).to include "Url can't be blank"
      end

      it 'returns 422 with url is invalid' do
        put :update, params: { id: video.id, video: { title: 'New title', url: 'video.url', description: video.description } }

        expect(response).to have_http_status 422
        expect(flash[:error]).to include 'Url is an invalid URL'
      end

      it 'returns 422 with url is not Youtube url format' do
        put :update, params: { id: video.id, video: { title: 'New title', url: 'http://video.url/123', description: video.description } }

        expect(response).to have_http_status 422
        expect(flash[:error]).to include 'Url is not youtube URL'
      end

      it 'returns root page with error message if you are not owner' do
        other_user = create(:user)
        sign_in_as(other_user)
        put :update, params: { id: video.id, video: { title: 'New title', url: video.url, description: video.description } }

        expect(response).to redirect_to root_path
        expect(flash[:error]).to eq 'You are not permitted to perform this action'
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:user) { create(:user) }
    let(:video) { create(:video, user: user) }

    it 'returns root page with message delete video successfully' do
      sign_in_as(user)
      delete :destroy, params: { id: video.id }

      expect(flash[:notice]).to eq 'Successfully deleted video'
    end

    it 'returns root page with warning message if user is not log in' do
      delete :destroy, params: { id: video.id }

      expect(response).to redirect_to root_path
      expect(flash[:alert]).to eq 'You must be signed in'
    end

    it 'returns root page with error message if you are not owner' do
      other_user = create(:user)
      sign_in_as(other_user)
      delete :destroy, params: { id: video.id }

      expect(response).to redirect_to root_path
      expect(flash[:error]).to eq 'You are not permitted to perform this action'
    end
  end
end
