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
var pattern = "res://shader_images/squares.png"
var fadeType = TransitionSprite.FadeType.Blend
var fadeDirection = TransitionSprite.FadeDirection.Out
var sprite:TransitionSprite = TransitionSprite.new(fadeType, fadeDirection, duration, pattern)
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

AudioPlayer
```gdscript
# Add AudioPLayer as Autoload
AudioPlayer.playMusic("res://music/title.mp3")
AudioPlayer.playSound("res://sound/hit.mp3")
AudioPlayer.stopAll()
SoundUtil.setVolumeForBus(AudioPlayer.MUSIC, -10)
```
