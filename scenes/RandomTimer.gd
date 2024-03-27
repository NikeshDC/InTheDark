extends Timer

export var baseTime = 0.0
export var minTime = 0.0
export var maxTime = 1.0

export var randomInitialize = false

func _ready():
	self.connect("timeout", self, "set_timer_wait_time")
	if(randomInitialize):
		randomize()


func set_timer_wait_time():
	start(rand_range(baseTime + minTime, baseTime + maxTime))
