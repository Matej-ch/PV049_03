# encoding: utf-8
require 'sequel'
require 'sinatra/base'
require 'sinatra/reloader'

require_relative '../config/database'
require_relative './helpers/facebook'

class FacebookStats < Sinatra::Base
  include Facebook
  configure :development do
    register Sinatra::Reloader
  end
  set :views, './views'
  set :public_folder, './public'
  set :method_override, true
  links_dataset = DB.from(:Links)
  stats_dataset = DB.from(:Stats)

  before do
    @author = 'Matej'
    @year   = Time.now.year
  end

  helpers do
    def all_links_get
      @links = DB[:Links].all
    end

    def db_urls
      @urls = DB.from(:Links).select(:id, :url)
    end
  end

  not_found do
    halt 404, 'page not found'
  end

  get '/' do
    all_links_get
    slim :index
  end

  # POST - add link
  post '/links' do
    face_data = Facebook.data(params[:url])
    lid = links_dataset.insert(:url => params[:url],
                               :domain => face_data['host'])

    stats_dataset.insert(:link_id => lid,
                         :like_count => face_data['article_likes'],
                         :share_count => face_data['article_shares'],
                         :time => Time.now)
    redirect back
  end

  # DELETE - delete link
  delete '/link/:link' do
    stats_dataset.where(:link_id => params[:link]).delete
    links_dataset.where(:id => params[:link]).delete
    all_links_get
    redirect to('/')
  end

  # GET - get links statistics
  get '/link/:link/stats' do
    @link = links_dataset.first(:id => params[:link])
    @stats = stats_dataset.where(:link_id => params[:link])
    slim :stats
  end

  # refresh statistics one link
  get '/refreshOne/:link' do
    link_data = links_dataset.first(:id => params[:link])
    face_data = Facebook.data(link_data[:url])
    stats_dataset.insert(:link_id => params['link'],
                         :like_count => face_data['article_likes'],
                         :share_count => face_data['article_shares'],
                         :time => Time.now)
    redirect back
  end

  # refresh statistics all links
  get '/refresh' do
    db_urls.each do |url|
      face_data = Facebook.data(url[:url])
      stats_dataset.insert(:link_id => url[:id],
                           :like_count => face_data['article_likes'],
                           :share_count => face_data['article_shares'],
                           :time => Time.now)
    end
    redirect back
  end

  get '/link/:link' do
    @link = links_dataset.first(:id => params[:link])
    slim :link_form
  end

  # PUT - edit link information
  put '/link/:link' do
    face_data = Facebook.data(params[:url])
    links_dataset.where(:id => params['link']).update(:url => params[:url],
                                                      :domain => face_data['host'])
    stats_dataset.where(:link_id => params['link']).update(:like_count => face_data['article_likes'],
                                                           :share_count => face_data['article_shares'],
                                                           :time => Time.now)
    all_links_get
    redirect to('/')
  end
end
