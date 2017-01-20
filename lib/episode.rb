require "yaml"

class Episode
  BASE_URL = "https://episodes.hunchpig.audio/".freeze
  AUTHOR = "Ian C. Anderson and Matthew Sumner"

  attr_reader :title

  def initialize(duration: nil, enclosure_length: nil, mp3_basename: nil, title: nil)
    @mp3_basename = mp3_basename || calculate_mp3_basename
    @duration = duration
    @enclosure_length = enclosure_length
    @title = title
  end

  def guid
    sprintf("%04d", episode_number)
  end

  def to_yaml
    YAML.dump(
      "title" => title_with_episode_number,
      "author" => AUTHOR,
      "subtitle" => "",
      "summary" => summary,
      "guid" => guid,
      "pubDate" => formatted_publication_date,
      "enclosureUrl" => enclosure_url,
      "enclosureLength" => enclosure_length,
      "enclosureType" => "audio/mpeg",
      "duration" => duration,
    )
  end

  private

  attr_reader :mp3_basename, :duration, :enclosure_length

  def sponsorship_cost_next_episode
    episode_number - 14
  end

  def summary
    sprintf(
      <<-EOS, sponsorship_cost_next_episode
        Ian and Matt talk.
        Contact us at http://twitter.com/hunchpig for sponsorship opportunities.
        Our next sponsorship is available for $%d!
      EOS
    )
  end

  def calculate_mp3_basename
    "#{guid}.mp3"
  end

  def enclosure_url
    BASE_URL + mp3_basename
  end

  def formatted_publication_date
    Time.now.utc.strftime "%a, %e %b %Y %H:%M:%S GMT"
  end

  def title_with_episode_number
    "#{episode_number} - #{title}"
  end

  def episode_number
    if mp3_basename
      mp3_basename.split(".").first.to_i
    else
      last_episode_number + 1
    end
  end

  def last_episode_number
    @last_episode_number ||=
      Dir.entries("_episodes").last.split("-").first.to_i
  end
end
