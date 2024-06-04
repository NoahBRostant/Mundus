extends MarginContainer

var treefolder = preload("res://TreeNodeFolder.tscn")
var treeitem = preload("res://TreeNodeItem.tscn")

func _ready():
	var root_tree_inst = $VBoxContainer/Tree/MarginContainer/ScrollContainer/VBoxContainer2
	get_all_files("user://saves/"+Global.projectName+"/data", "", [], root_tree_inst)


func get_all_files(path: String, file_ext := "", files := [], parent_node = null):
	var dir = DirAccess.open(path)

	if DirAccess.get_open_error() == OK:
		dir.list_dir_begin()

		var file_name = dir.get_next()
		var file_path

		while file_name != "":
			if dir.current_is_dir():
				var folderinst = treefolder.instantiate()
				folderinst.title = file_name
				parent_node.add_child(folderinst)
				files = get_all_files(dir.get_current_dir() +"/"+ file_name, file_ext, files, folderinst.get_node("CollapsibleContainer/MarginContainer/VBoxContainer"))
			else:
				if file_ext and file_name.get_extension() != file_ext:
					file_path = dir.get_current_dir()
					file_name = dir.get_next()
					continue
				var iteminst = treeitem.instantiate()
				iteminst.title = file_name
				iteminst.filepath = path+"/"+file_name
				parent_node.add_child(iteminst)
				files.append(dir.get_current_dir() +"/"+ file_name)

			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access %s." % path)

	return files


func _on_button_3_button_down():
	var childeren = $VBoxContainer/Tree/MarginContainer/ScrollContainer/VBoxContainer2.get_children()
	for i in childeren:
		$VBoxContainer/Tree/MarginContainer/ScrollContainer/VBoxContainer2.remove_child(i)
	_ready()


func _on_button_2_pressed():
	get_node("/root/Control/AddFileTree").show()
