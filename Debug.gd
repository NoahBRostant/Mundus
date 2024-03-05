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
		write_to_debug.text += "[center][code][/code] Help (Commands)[/center]\n"
		write_to_debug.text += "- [color="+CBlue+"]help[/color] : Bring up the command menu or for more information on other comands\n"
		write_to_debug.text += "- [color="+CBlue+"]info[/color] : Information on Mundus\n"
		write_to_debug.text += "- [color="+CBlue+"]cls[/color] : Clear the Debug Console\n"
		write_to_debug.text += "- [color="+CBlue+"]print()[/color] : Write to the Terminal\n"
		write_to_debug.text += "- [color="+CBlue+"]func[/color] : Toggle Functions within Mundus\n"
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
			write_to_debug.text += "[code][/code]   Godot: Godot_v4.2.1.stable\n"
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
		if tempcmd.ends_with(")"):
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
		else:
			ERROR("0003")
	elif cmd == "info":
		write_to_debug.text += "[color="+CBlue+"][code][/code]    Info: Mundus is a program designed to help you genorate and build worlds from your imagination.[/color]\n"
		write_to_debug.text += "[color="+CBlue+"]             Find out more at [url]www.mundusbuilder.co.uk[/url][/color]\n"
	# Map Options ----------------------------------------------------
	elif cmd.begins_with("map."):
		if cmd == "map.loadimage":
			get_node("/root/Node3D/VBoxContainer/Control/FileDialog").show()
	# GPT-3 Options ---------------------------------------------------
	#elif cmd.begins_with("gpt("): # Detect correct command
		#if cmd.ends_with(")"): # Ensure its a closed command
			#var tempcmd = cmd.trim_prefix("gpt(") # Gets raw data from command "PROMPT",MAX_TOKENS
			#tempcmd = tempcmd.trim_suffix(")")
			#var cmdsplit = tempcmd.split(",",true,1)
			#if str(cmdsplit[0]).begins_with("'"):
				#if cmdsplit[0].ends_with("'"):
					#cmdsplit[0] = cmdsplit[0].trim_prefix("'")
					#cmdsplit[0] = cmdsplit[0].trim_suffix("'")
					#Global.openaiRequest = cmdsplit[0]
					#if cmdsplit.size() == 1:
						#Global.gptTokenLimit = Global.gptTokenDefault
					#else:
						#Global.gptTokenLimit = int(cmdsplit[1])
					#OpenAi.run_gpt()
					#write_to_debug.text += Global.openaiResponse
				#else:
					#ERROR("0004")
			#elif str(cmdsplit[0]).begins_with('"'):
				#if cmdsplit[0].ends_with('"'):
					#cmdsplit[0] = cmdsplit[0].trim_prefix('"')
					#cmdsplit[0] = cmdsplit[0].trim_suffix('"')
					#Global.openaiRequest = cmdsplit[0]
					#if cmdsplit.size() == 1:
						#Global.gptTokenLimit = Global.gptTokenDefault
#						ThreadPoolManager.submit_task_unparameterized(self, "RUNGPT3","executegpt3",10000)
						#OpenAi.run_gpt()
						#write_to_debug.text += "GPT3: "+str(cmdsplit[0])
						#write_to_debug.text += Global.openaiResponse
					#elif cmdsplit[1].is_valid_int():
						#Global.gptTokenLimit = int(cmdsplit[1])
#						ThreadPoolManager.submit_task_unparameterized(self, "RUNGPT3","executegpt3",10000)
						#OpenAi.run_gpt()
						#write_to_debug.text += Global.openaiResponse
					#else:
						#ERROR("0008")
				#else:
					#ERROR("0004")
			#else:
				#ERROR("0007")
		#else:
			#ERROR("0003")
#	elif cmd.begins_with("dalle("):
#		if cmd.ends_with(")"):
#			cmd.trim_prefix("dalle(")
#			cmd.trim_suffix(")")
#			var cmdsplit = cmd.split(",",false,1)
#			Global.openaiRequest = cmdsplit[0]
#			if cmdsplit.size() == 1:
#				Global.gptTokenLimit = Global.gptTokenDefault
#			else:
#				Global.gptTokenLimit = int(cmdsplit[1])
#			$"/root/Spatial/VBoxContainer/Control/HBoxContainer/VBoxContainer2/Panel6/TabContainer/ProphetAI".run_dalle()
#			write_to_debug.bbcode_text += Global.openaiResponse
#		else:
#			ERROR("0003")
	elif cmd == "exit":
		get_tree().quit()
	else:
		ERROR("0002")
	%CMDLine.editable = true


func ERROR(ECode):
	if ECode == "0002":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Not a valid Command[/color]\n'
	elif ECode == "0003":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Expected ")"[/color]\n'
	elif ECode == "0004":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Expected " or '+"'"+'[/color]\n'
	elif ECode == "0005":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Expected boolian in argument[/color]\n'
	elif ECode == "0006":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Expected variable in argument[/color]\n'
	elif ECode == "0007":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Expected string in argument[/color]\n'
	elif ECode == "0008":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to execute "'+cmd+'"[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Expected integer in argument[/color]\n'
	elif ECode == "0050":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: OpenAI - GPT ran into an issue[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Unknown Issue[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Check API Key, Check OpenAI Account, and Check Billing Preferences[/color]\n'
	elif ECode == "0051":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: OpenAI - GPT ran into an issue[/color]\n'
		write_to_debug.text += '[color='+CRed+']             API Key not Recognised[/color]\n'
	elif ECode == "0060":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: OpenAI - DALL-E ran into an issue[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Unknown Issue[/color]\n'
	elif ECode == "1000":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to Load "'+cmd+'" as a Texture2D[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Internal Failure[/color]\n'
	elif ECode == "1001":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: Failed to Load "'+cmd+'" as a Texture2D[/color]\n'
		write_to_debug.text += '[color='+CRed+']             Not a valid file format ( ".PNG", ".JPG", ".JPEG" )[/color]\n'
	elif ECode == "1002":
		write_to_debug.text += '[color='+CRed+'][code]󰅙[/code]   Error: An error occurred when trying to access the path.[/color]\n'
		write_to_debug.text += '[color='+CRed+']             '+Console.debug+'[/color]\n'
