class_name TimerUtil

# While using "await get_tree().create_timer(2.0, false).timeout" can't be canceled or stopped, using this method instead:
# _timer = TimerUtil.createOneshotTimer(self, 2.0)
# await _timer.timeout

static func createOneshotTimer(target:Node, time_sec:float) -> Timer:
	var t:Timer = Timer.new()
	t.one_shot = true
	target.add_child(t)
	t.start(time_sec)
	return t
