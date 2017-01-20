
## How to release a new episode

Create an episode YAML file with a title and an audio file:

`bin/create_episode "Here's the title" ~/Desktop/0089.mp3`

Or create it before the audio file is ready:

`bin/create_episode "Here's the title"`

Then update with the audio file when it's ready:

`bin/update_episode ~/Desktop/0089.mp3`
