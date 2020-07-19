extends Node


# Declare member variables here. Examples:
signal signal_unlock_portal;
signal signal_player_reached_goal;

var __mainScene : Control;
var __startingGameState : Dictionary = {
	"enemyCount": -1
};
var __currentGameState : Dictionary = {};


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

func fnRegisterEnemies():
	var enemies = get_tree().get_nodes_in_group("enemy");
	self.__startingGameState["enemyCount"] = enemies.size();
	
	for enemy in enemies:
		enemy.get_parent().connect("signal_destroyed", self, "fnOnEnemyDestroyed");
	
	self.__currentGameState["enemyCount"] = self.__startingGameState["enemyCount"];
	return;

func fnOnEnemyDestroyed():
	self.__currentGameState["enemyCount"] -= 1;
	
	if (self.__currentGameState["enemyCount"] == 0):
		emit_signal("signal_unlock_portal");
	return;\

func fnPlayerReachedGoal():
	emit_signal("signal_player_reached_goal");
	return;
