require "yaml"
require_relative "./audio_file_metadata"
require_relative "./episode"

class EpisodeUpdater
  def initialize(mp3_filename:)
    @mp3_filename = mp3_filename
  end

  def update_yaml_file
    @last_episode_yaml = YAML.load(File.read(yaml_filename))

    File.open(yaml_filename, "w") do |file|
      file.puts updated_episode_yaml
    end
  end

  def yaml_filename
    "_episodes/#{Dir.entries('_episodes').sort.last}"
  end

  def updated_episode_yaml
    YAML.dump(
      last_episode_yaml.merge(audio_file_metadata.as_yaml)
    )
  end

  private

  attr_reader :last_episode_yaml, :mp3_filename

  def audio_file_metadata
    AudioFileMetadata.new(mp3_filename: mp3_filename)
  end
end
