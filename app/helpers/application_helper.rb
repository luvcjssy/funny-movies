module ApplicationHelper
  def alert_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }[flash_type.to_sym] || flash_type.to_sym
  end

  def video_embed(video_url)
    # Regex extract video id
    regex_id = /(?:youtube(?:-nocookie)?\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{8,11})/
    match_id = regex_id.match(video_url)
    video_id = ''
    if match_id && !match_id[1].blank?
      video_id = match_id[1]
    end

    # Regex extract provider - youtube
    regex_prov = /(youtube|youtu\.be)/
    match_prov = regex_prov.match(video_url)
    video_prov = ''
    if match_prov && !match_prov[1].blank?
      video_prov = case match_prov[1]
                   when 'youtube', 'youtu.be'
                     :youtube
                   end
    end

    case video_prov
    when :youtube
      "https://www.youtube.com/embed/#{video_id}"
    end
  end
end
