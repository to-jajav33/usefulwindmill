extends Node2D


# Declare member variables here. Examples:
export var nextLevel = 0;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"/root/Common".fnRegisterEnemies();
	$"/root/Common".connect("signal_unlock_portal", self, "fnOnUnlockPortal");
	$"/root/Common".connect("signal_player_reached_goal", self, "fnOnPlayerReachedGoal");
	pass # Replace with function body.

func fnOnUnlockPortal():
	$Hole.fnUnlock();
	return;

func fnOnPlayerReachedGoal():
	if (nextLevel > 0):
		$"/root/Common".fnChangeSceneTo("Level" + str(nextLevel));
	else:
		$"/root/Common".fnChangeSceneTo("EndScene");
	return;
