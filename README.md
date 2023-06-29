# daftlib-gdscript
A collection of commonly used utility classes and data structures.

## Usage Example
Queue loader
```gdscript
var ql = QueueLoader.new()
ql.progress.connect(onProgress)
ql.complete.connect(onComplete)
ql.addItem("res://assets/art/enemyFlyingAlt_1.png")
ql.addItem("res://assets/art/enemyFlyingAlt_2.png")
ql.addItem("res://assets/art/enemySwimming_1.png")
ql.addItem("res://assets/art/enemySwimming_2.png")
ql.addItem("res://assets/art/enemyWalking_1.png")
ql.addItem("res://assets/art/enemyWalking_2.png")
ql.addItem("res://assets/art/House In a Forest Loop.ogg")
ql.start()
self.add_child(ql)

func onComplete():
	$Sprite2D.texture = ql.getItem("res://assets/art/enemyWalking_2.png")

func onProgress(percent):
	print(percent)
```

Transition Sprite
```gdscript

var imageTexture:ImageTexture = null
imageTexture = DisplayObjectUtil.getScreenShotImageTexture(self)

var duration = 0.5
var sprite:TransitionSprite = TransitionSprite.new()
sprite.type = TransitionSprite.Type.FADE
sprite.direction = TransitionSprite.Direction.OUT
sprite.duration = duration
sprite.shader_pattern_path = "res://shader_images/squares.png"
sprite.texture = imageTexture if duration > 0 else null
self.add_child(sprite)

var scale = DisplayObjectUtil.getCorrectionForAspectRatio(imageTexture)
sprite.scale = scale

sprite.complete.connect(_onTransComplete)
```

Simplify usage of UDP, and implemented heartbeat protocol
```gdscript
# Server side
var server:UDPServerController = UDPServerController.new()
server.message.connect(_onClientMessage)
self.add_child(server)

func _onClientMessage(content:String):
	_append_text(content)
```
```gdscript
# Client side
var client:UDPClient = UDPClient.new()
client.message.connect(_onServerMessage)
self.add_child(client)

func _onServerMessage(content:String):
	print(content)

func _sendMessageToServer(content:String):
	client.send_package(content)
```

Address
```gdscript
var address:Address = Address.new()
address.change.connect(on_address_change)
address.setValue("/learn/")
address.setValue("")
address.setValue("/blog/articles/godot")
address.up()
address.setValue("contact")
address.setValue("news")
address.back()
address.setValue("/about")
address.forward()
address.back()

func on_address_change(value):
	print(value)
```

Scenes Navigator
```json
{
	"scenes": [
		{
			"id": "scene1",
			"packed_res": "res://assets/scenes/scene1.tscn",
			"music": "",
			"dialogues": []
		},
		{
			"id": "scene2",
			"packed_res": "res://assets/scenes/scene2.tscn",
			"music": "",
			"dialogues": []
		},
		{
			"id": "scene3",
			"packed_res": "res://assets/scenes/scene3.tscn",
			"music": "",
			"dialogues": []
		}
	]
}
```
```gdscript
# Add Navigator as Autoload
for item in data.scenes:
	var sceneId:String = item.get("id")
	Navigator.link(sceneId, item)
Navigator.change.connect(onSceneChange)
Navigator.finished.connect(onAllSceneFinished)
Navigator.first()

func onSceneChange(_id:String, data:Dictionary):
	var scene = load(data.get("packed_res")).instantiate()
	self.addChild(scene)
```

MP3Player
```gdscript
# Add MP3PLayer as Autoload
MP3Player.playMusic("res://music/title.mp3")
MP3Player.playSound("res://sound/hit.mp3")
MP3Player.stopAll()
SoundUtil.setVolumeForBus(MP3Player.MUSIC, -10)
```

SpineCanvas
```gdscript
var canvas:SpineCanvas = %SpineCanvas
print(canvas.getAnimationNames())
canvas.audio.connect(MP3Player.playSound)
canvas.playAnimation()
```

GameState
```gdscript
GameState.change.connect(onStateChange)
GameState.current = GameState.TRANSITIONING
GameState.current = GameState.GAME_PLAYING
func onStateChange(_current:String, _previous:String):
	print("GameState: ", _current, "PreviousState: ", _previous)
```

SignalManager
```gdscript
# Add SignalManager as Autoload
SignalManager.connectSignal(btn.pressed, _listenerA)
SignalManager.connectSignal(btn.pressed, _listenerB)
SignalManager.connectSignal(btn.pressed, _listenerC.bind(args))
SignalManager.disconnectAllForSignal(btn.pressed)
```
