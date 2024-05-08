extends Node2D

var window = JavaScriptBridge.get_interface("window")
var console = JavaScriptBridge.get_interface("console")
var peps = window.paima.endpoints


# Callbacks
## Definitions
var cb_get_used_addresses = JavaScriptBridge.create_callback(_cb_get_used_addresses)
func _cb_get_used_addresses(args):
	prints("GD running: _cb_get_used_addresses")
	
	var addresses = JavaScriptBridge.create_object("Array", 1)
	addresses[0] = MY_NAMI_USED_ADDRESS
	var jsCallback: JavaScriptObject = args[0] # todo: check not null
	console.log("jsCallback: ", jsCallback)
	#jsCallback.get_interface("Function").call(addresses)
	jsCallback.call("call", jsCallback.this, addresses)
	
var cb_get_unused_addresses = JavaScriptBridge.create_callback(_cb_get_unused_addresses)
func _cb_get_unused_addresses(args):
	prints("GD running: _cb_get_unused_addresses")
	var addresses = JavaScriptBridge.create_object("Array", 0)
	var jsCallback: JavaScriptObject = args[0] # todo: check not null
	jsCallback.call("call", jsCallback.this, addresses)
	
var cb_sign_data = JavaScriptBridge.create_callback(_cb_sign_data)
func _cb_sign_data(args):
	prints("GD running: _cb_sign_data")
	
	var jsCallback: JavaScriptObject = args[0] # todo: check not null
	
	var address = args[1]
	var paylodadBytes = args[2]
	prints("address: ", address)
	prints("paylodadBytes: ", paylodadBytes)
		
	var signResult = JavaScriptBridge.create_object("Object")
	signResult.key = "a4010103272006215820eafb118d61ccbd59a67d397640a3ed1fb0916cc21a5baabb1cbe8f4a7461bd3b"
	signResult.signature = "ff"
	jsCallback.call("call", jsCallback.this, signResult)


## Adding to `window`
func inject_callbacks():
	print("injecting callbacks")
	window.cardano.godot.callbacks.get_used_addresses = cb_get_used_addresses
	window.cardano.godot.callbacks.get_unused_addresses = cb_get_unused_addresses
	window.cardano.godot.callbacks.sign_data = cb_sign_data
	print("injecting callbacks done")
	


# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready v6")
	inject_callbacks()
	
	#JavaScriptBridge.eval("""
		#console.log(window.paima.endpoints)
	#""", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

const MY_NAMI_USED_ADDRESS = "012c2dad3e1d19d3e1764f96d4a3033ae6978a57936fd2a6cca3ce4033d7cc83ef07d1d2e23017d3d1df6e9d4410d8b5ec3f71378ccc7e5d88"
