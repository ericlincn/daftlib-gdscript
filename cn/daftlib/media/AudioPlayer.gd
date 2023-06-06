extends Node

const EXT:String = ".mp3"
const MUSIC_PATH:String = "res://assets/music/"
const MUSIC:String = "Music"
const SOUND_PATH:String = "res://assets/sound/"
const SOUND:String = "FX"

var _currentMusicPlayer:AudioStreamPlayer
var _currentMusicId:String = ""
var _currentSoundPlayer:AudioStreamPlayer

func playMusic(id:String, stream:AudioStreamMP3 = null):
	if _currentMusicId == id:
		return
		
	_currentMusicId = id
	
	if _currentMusicPlayer:
		SoundUtil.fadeoutAndFree(_currentMusicPlayer)

	_currentMusicPlayer = AudioStreamPlayer.new()
	self.add_child(_currentMusicPlayer)
	
	_currentMusicPlayer.bus = MUSIC
	_currentMusicPlayer.stream = _getStream(id, stream, MUSIC)
	_currentMusicPlayer.play()

func playSound(id:String, stream:AudioStreamMP3 = null):
	if _currentSoundPlayer:
		SoundUtil.fadeoutAndFree(_currentSoundPlayer)
	
	_currentSoundPlayer = AudioStreamPlayer.new()
	self.add_child(_currentSoundPlayer)
	
	_currentSoundPlayer.bus = SOUND
	_currentSoundPlayer.stream = _getStream(id, stream, SOUND)
	_currentSoundPlayer.play()

func stopMusic():
	if _currentMusicPlayer:
		SoundUtil.fadeoutAndFree(_currentMusicPlayer)
		_currentMusicId = ""
		_currentMusicPlayer = null
		
func stopSound():
	if _currentSoundPlayer:
		SoundUtil.fadeoutAndFree(_currentSoundPlayer)
		_currentSoundPlayer = null

func stopAll():
	stopMusic()
	stopSound()

func _getStream(id:String, stream:AudioStreamMP3, type:String):
	if !stream:
		if id.contains(EXT):
			stream = load(id) as AudioStreamMP3
			if type == MUSIC:
				stream.loop = true
		else:
			if type == MUSIC:
				stream = load(MUSIC_PATH + id + EXT) as AudioStreamMP3
				stream.loop = true
			else:
				stream = load(SOUND_PATH + id + EXT) as AudioStreamMP3
	
	return stream
