@tool
extends EditorPlugin

var button = Button.new()
var icon = preload("res://addons/github_push/github.svg")

func _enter_tree():
	button.icon = icon
	button.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	button.button_down.connect(_timetopush)
	
	add_control_to_container(EditorPlugin.CONTAINER_TOOLBAR, button)


func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_TOOLBAR, button)
	button.free()


func _timetopush():
	OS.execute("git",["push","origin","master"])
