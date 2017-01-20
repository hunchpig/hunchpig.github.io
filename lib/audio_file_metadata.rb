require "mp3info"

class AudioFileMetadata
  def initialize(mp3_filename:)
    @mp3_filename = mp3_filename
  end

  def to_episode_params
    Mp3Info.open(mp3_filename) do |mp3info|
      seconds = mp3info.length.round
      duration = format_duration(seconds)
      file_size = File.size(mp3_filename)
      mp3_basename = File.basename(mp3_filename)
      {
        duration: duration,
        enclosure_length: file_size,
        mp3_basename: mp3_basename,
      }
    end
  end

  def as_yaml
    Mp3Info.open(mp3_filename) do |mp3info|
      seconds = mp3info.length.round
      duration = format_duration(seconds)
      file_size = File.size(mp3_filename)
      {
        "duration" => duration,
        "enclosureLength" => file_size,
      }
    end
  end

  private

  attr_reader :mp3_filename

  def format_duration(total_seconds)
    seconds = total_seconds % 60
    minutes = (total_seconds / 60) % 60
    hours = total_seconds / (60 * 60)
    sprintf("%02d:%02d:%02d", hours, minutes, seconds)
  end
end
