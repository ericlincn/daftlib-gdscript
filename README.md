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
var pattern = "res://res/shader_images/squares.png"
var fadeType = TransitionSprite.FadeType.Blend
var fadeDirection = TransitionSprite.FadeDirection.Out
var sprite:TransitionSprite = TransitionSprite.new(fadeType, fadeDirection, duration, pattern)
sprite.texture = imageTexture if duration > 0 else null
self.add_child(sprite)

var scale = DisplayObjectUtil.getCorrectionForAspectRatio(imageTexture)
sprite.scale = scale
```
