require "active_support/core_ext/string"
require "mp3info"
require_relative "audio_file_metadata"

class EpisodeCreator
  def initialize(episode_title: nil, mp3_filename: nil)
    @episode_title = episode_title
    @mp3_filename = mp3_filename
  end

  def create_yaml_file
    File.open(yaml_filename, "w") do |file|
      file.puts episode_yaml
    end
  end

  def episode_yaml
    episode.to_yaml
  end

  def yaml_filename
    "_episodes/#{yaml_basename}"
  end

  private

  attr_reader :episode_title, :mp3_filename

  def episode
    @episode ||= init_episode
  end

  def init_episode
    if mp3_filename
      metadata = AudioFileMetadata.new(mp3_filename: mp3_filename)
      Episode.new(metadata.to_episode_params.merge(title: episode_title))
    elsif episode_title
      Episode.new(title: episode_title)
    else
      Episode.new
    end
  end

  def yaml_basename
    if episode.title
      dashified_title = episode.title.parameterize
      "#{episode.guid}-#{dashified_title}.yml"
    else
      "#{episode.guid}.yml"
    end
  end
end
