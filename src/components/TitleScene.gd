extends Control


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.set_process_input(true);
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if ((event is InputEventMouse) || (event is InputEventMouseMotion)):
		return;
	
	$"/root/Common".fnChangeSceneTo("Level1");
	return;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
