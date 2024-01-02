extends Panel

var projectFileName = ""
var projectName = ""
var projectType = ""
var projectMadeDate = ""
var projectModDate = ""
var projectDescription = ""
var projectThumbnail = ""

func _ready():
	var date = Time.get_date_dict_from_system()
	var day = date.day
	var month = date.month
	var year = date.year
	print(day,month,year)
	if day < 10:
		day = "0"+str(day)
	if month < 10:
		month = "0"+str(month)
	year = str(year).right(2)
	projectMadeDate = str(day)+"/"+str(month)+"/"+str(year)
	projectModDate = str(day)+"/"+str(month)+"/"+str(year)

func _on_button_button_down():
	get_parent().remove_child(self)
	

func _on_start_btn_button_down():
	%StartBtn.hide()
	%ProgressBar.show()
	createSave()
	Global.projectName = projectName
	Console.debug = 'Successfuly Created "'+projectName+'"'
	Console.ECode = "0000"
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_line_edit_text_changed(new_text):
	projectName = new_text
	if projectName != "":
		%StartBtn.disabled = false
	else:
		%StartBtn.disabled = true


func createSave():
	var fileType
	if $Panel2/VBoxContainer/Panel/HBoxContainer/VBoxContainer2/OptionButton.selected == 1:
		projectType = "DnD5e"
	var dir = DirAccess.open("user:///saves")
	dir.make_dir(projectName)
	projectFileName = projectName
	var f = FileAccess.open("user:///saves/"+projectName+"/data.save",FileAccess.WRITE)
	if projectThumbnail.ends_with(".png") or projectThumbnail.ends_with(".PNG") or projectThumbnail.ends_with(".jpg") or projectThumbnail.ends_with(".JPG") or projectThumbnail.ends_with(".jpeg") or projectThumbnail.ends_with(".JPEG"):
		var dir2 = DirAccess.open("user:///saves/"+projectFileName)
		var tempPath = projectThumbnail.split(".",false)
		fileType = str(tempPath[tempPath.size()-1])
		dir2.copy(projectThumbnail,"user:///saves/"+projectFileName+"/Thumbnail."+fileType)
	else:
		pass
	f.store_line(projectFileName+","+projectName+","+projectMadeDate+","+projectType+","+projectDescription+","+projectModDate)
	f.close()


func _on_native_file_dialog_file_selected(path):
	projectThumbnail = path


func _on_button_button_up():
	$NativeFileDialog.show()
