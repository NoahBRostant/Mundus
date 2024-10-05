extends Panel

@onready var write_to_debug:Object = %DebugText
@onready var get_cmd:Object = %CMDLine
var cmd:String
var ECode:String

var fps:bool = false
var currentFps:float

var CWhite:String = "#D9D9D9"
var CBlue:String = "#77B3FE"
var CRed:String = "#FE8B68"
var CGreen:String = "#76C578"
var CYellow:String = "#E6F385"

var Consoledebug:String = Console.debug

func _ready():
	#write_to_debug.text += "[code][/code]  Debug Terminal\n"
	#write_to_debug.text += "	Welcome to Mundus...\n"
	pass

func _process(_delta):
	if fps == true && currentFps != Engine.get_frames_per_second():
		write_to_debug.text += "fps: "+str(Engine.get_frames_per_second())+"\n"
		currentFps = Engine.get_frames_per_second()
	if Console.debug != "":
		if Console.ECode == "0000":
			write_to_debug.text += "[color="+CGreen+"][code][/code] Success: "+Console.debug+"[/color]\n"
		elif Console.ECode == "0001":
			write_to_debug.text += "[color="+CBlue+"][code][/code] Execute: "+Console.debug+"[/color]\n"
		else:
			ECode = Console.ECode
			cmd = Console.debug
			ERROR(ECode)
		Console.debug = ""
	else:
		Consoledebug = Console.debug


func _on_CMDLine_text_entered(_new_text):
	%CMDLine.editable = false
	var t = Timer.new()
	t.set_wait_time(0.1)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
	cmd = get_cmd.text
	get_cmd.text = ""
	# Custom Terminal Options ---------------------------------------
	if cmd == "cls":
		write_to_debug.text = ""
	elif cmd == "cls -r":
		write_to_debug.text = ""
		write_to_debug.text += "[code][/code]  Debug Terminal\n"
		write_to_debug.text += "Welcome to Mundus...\n"
	elif cmd == "help":
		write_to_debug.text += "[color="+CBlue+"][code][/code]    Help: List of Commands[/color]\n"
		write_to_debug.text += "[color="+CBlue+"]             help[/color] : Bring up the command menu or for more information on other comands\n"
		write_to_debug.text += "[color="+CBlue+"]             info[/color] : Information on Mundus\n"
		write_to_debug.text += "[color="+CBlue+"]             cls[/color] : Clear the Console\n"
		write_to_debug.text += '[color='+CBlue+']             console()[/color] : Print to the Console\n'
		write_to_debug.text += "[color="+CBlue+"]             func[/color] : Toggle Functions within Mundus\n"
	elif cmd.begins_with("help "):
		if cmd.trim_prefix("help ") == "-v" or cmd.trim_prefix("help ") == "-version":
			write_to_debug.text += "[color="+CBlue+"][code][/code]   Help:[/color] Mundus_"+Console.verState+"_v"+Console.version+"\n"
	elif cmd.begins_with("func.fps"):
		if cmd.begins_with("func.fps("):
			if cmd.ends_with(")"):
				var tempcmd = cmd.trim_prefix("func.fps(")
				tempcmd = tempcmd.trim_suffix(")")
				if tempcmd == "true":
					fps = true
				if tempcmd == "false":
					fps = false
				else:
					ERROR("0005")
			else:
				ERROR("0003")
		else:
			if fps == true:
				fps = false
			else:
				fps = true
	elif cmd.begins_with("godot"):
		if cmd == "godot -v":
			write_to_debug.text += "[code][/code]   Godot: Godot_v4.3.stable\n"
		else:
			pass
	elif cmd.begins_with("console"):
		var consoleType
		var error = true
		var tempcmd = cmd.trim_prefix("console")
		if tempcmd.begins_with(".log("):
			consoleType = CWhite+"][code][/code] Console: "
			tempcmd = tempcmd.trim_prefix(".log(")
			error = false
		elif tempcmd.begins_with(".error("):
			consoleType = CRed+"][code]󰅙[/code]   Error: "
			tempcmd = tempcmd.trim_prefix(".error(")
			error = false
		elif tempcmd.begins_with(".alert("):
			consoleType = CYellow+"][code][/code]   Alert: "
			tempcmd = tempcmd.trim_prefix(".alert(")
			error = false
		elif tempcmd.begins_with(".success("):
			consoleType = CGreen+"][code][/code] Success: "
			tempcmd = tempcmd.trim_prefix(".success(")
			error = false
		#elif !tempcmd.begins_with(".success(") or !tempcmd.begins_with(".alert(") or tempcmd.begins_with(".error(") or tempcmd.begins_with(".log("):
			#error = true
		if tempcmd.ends_with(")") and error != true:
			tempcmd = tempcmd.trim_suffix(")")
			if tempcmd.begins_with("'"):
				if tempcmd.ends_with("'"):
					tempcmd = tempcmd.trim_prefix("'")
					tempcmd = tempcmd.trim_suffix("'")
					write_to_debug.text += "[color="+consoleType+str(tempcmd)+"[/color]\n"
				else:
					ERROR("0004")
			elif tempcmd.begins_with('"'):
				if tempcmd.ends_with('"'):
					tempcmd = tempcmd.trim_prefix('"')
					tempcmd = tempcmd.trim_suffix('"')
					write_to_debug.text += "[color="+consoleType+str(tempcmd)+"[/color]\n"
				else:
					ERROR("0004")
			else:
				var variable = $"/root/Global".get(tempcmd)
				write_to_debug.text += "[color="+consoleType+str(tempcmd)+"[/color]\n"
		elif !tempcmd.ends_with(")"):
			ERROR("0003")
		if error == true and tempcmd.ends_with(")"):
			ERROR("0020")
	elif cmd == "info":
		write_to_debug.text += "[color="+CBlue+"][code][/code]    Info: Mundus is a program designed to help you genorate and build worlds from your imagination.[/color]\n"
		write_to_debug.text += "[color="+CBlue+"]             Find out more at [url]www.mundusbuilder.co.uk[/url][/color]\n"
	# Map Options ----------------------------------------------------
	elif cmd.begins_with("map."):
		if cmd == "map.loadimage":
			get_node("/root/Node3D/VBoxContainer/Control/FileDialog").show()
	elif cmd == "exit":
		get_tree().quit()
	else:
		ERROR("0002")
	%CMDLine.editable = true


## ---------------------------------- Error Handling

func ERROR(ECode):
	match ECode:
		"0002":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Not a valid Command[/color]\n'
		"0003":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Expected ")"[/color]\n'
		"0004":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Expected " or '+"'"+'[/color]\n'
		"0005":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Expected boolean in argument[/color]\n'
		"0006":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Expected variable in argument[/color]\n'
		"0007":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Expected string in argument[/color]\n'
		"0008":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Expected integer in argument[/color]\n'
		"0020":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Console command not defined as a type ( ".log", ".success", ".alert", ".error" )[/color]\n'
		"0050":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: OpenAI - GPT ran into an issue[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Unknown Issue[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Check API Key, Check OpenAI Account, and Check Billing Preferences[/color]\n'
		"0051":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: OpenAI - GPT ran into an issue[/color]\n'
			write_to_debug.text += '[color='+CRed+']             API Key not Recognised[/color]\n'
		"0060":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: OpenAI - DALL-E ran into an issue[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Unknown Issue[/color]\n'
		"1000":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to Load "'+cmd+'" as a Texture2D[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Internal Failure[/color]\n'
		"1001":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to Load "'+cmd+'" as a Texture2D[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Not a valid file format ( ".PNG", ".JPG", ".JPEG" )[/color]\n'
		"1002":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: An error occurred when trying to access the path.[/color]\n'
			write_to_debug.text += '[color='+CRed+']             '+Console.debug+'[/color]\n'
		"2000":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to run Notify[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Notify Encountered an Error on Attempted Push Notification[/color]\n'
		"2001":
			write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to run Notify[/color]\n'
			write_to_debug.text += '[color='+CRed+']             Notify Push Notification Unavailable on ( "'+OS.get_name()+'" )[/color]\n'
