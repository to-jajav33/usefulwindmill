extends Node


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"
var __mainScene : Control;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func fnSetMainScene (paramScene : Control):
	self.__mainScene = paramScene;
	return;

func fnChangeSceneTo (paramSceneName : String):
	if (self.__mainScene):
		if (self.__mainScene.get_child_count()):
			var oldScene = self.__mainScene.get_child(0);
			oldScene.queue_free();
		
		var newChildInst = load("res://components/" + paramSceneName + ".tscn").instance();
		self.__mainScene.add_child(newChildInst);
	return;
