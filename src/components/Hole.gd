extends Node2D


# Declare member variables here. Examples:
var __isLocked = true;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func fnUnlock() -> void:
	self.__isLocked = false;
	$AnimationPlayer.play_backwards("lock");
	return;


func _on_StaticBody2D_body_entered(body: Node) -> void:
	if (body.is_in_group("player") && (self.__isLocked == false)):
		$"/root/Common".fnPlayerReachedGoal();
	pass # Replace with function body.
