#adds a random value between minTime and maxTime to baseTime and then sets that value to the wait time of timer node
extends Timer

export var baseTime : float = 0.0
export var minTime : float = 0.0
export var maxTime : float = 1.0

export var randomInitialize : bool = false

##--INITIALIZE--##
func _ready():
	self.connect("timeout", self, "set_timer_wait_time")
	if(randomInitialize):
		randomize()
##--##--##

func set_timer_wait_time():
	start(baseTime + rand_range(minTime, maxTime))
