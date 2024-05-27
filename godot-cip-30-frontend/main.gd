extends Node2D

var window = JavaScriptBridge.get_interface("window")

const seedphrase: String = "camp fly lazy street predict cousin pen science during nut hammer pool palace play vague divide tower option relax need clinic chapter common coast"
const token: String = "mainnet8Gf1JxRjFsKJMXmK3B3uPYfnXRqKOydP"

var loader
var provider
var godot_wallet

# Called when the node enters the scene tree for the first time.
func _ready():
	print("WASM check")
	print("test v3")
	var tx_hash1 = _TransactionHash._from_hex("ff")
	prints("Tx hash1: ", tx_hash1.is_ok(), "should be ", false)
	var tx_hash2 = _TransactionHash._from_hex("6cce5658b52a7dbaa369198e61746084a53f4a5c1a6f0cffe40f77db970d34b7")
	prints("Tx hash2: ", tx_hash2.is_ok(), " should be ", true)
	print("WASM check end")
	
	init_cardano_wallet()

func init_cardano_wallet():
	print("GD: init_cardano_wallet")
	loader = SingleAddressWalletLoader.new(Provider.Network.MAINNET)
	provider = BlockfrostProvider.new(
		Provider.Network.MAINNET,
		token
	)
	add_child(loader)
	add_child(provider)
	var importRes = await loader.import_from_seedphrase_wo_new_thread(
		seedphrase, "", "", 0, "Acc name", "Acc description"
		)
	if importRes.is_err():
		print("Failed to load cardano wallet")
		return
	godot_wallet = Wallet.MnemonicWallet.new(importRes.value.wallet, provider)
	prints("GD: Godot wallet address bech32: ", godot_wallet.single_address_wallet.get_address().to_bech32())
	prints("GD: Godot wallet address hex: ", godot_wallet.single_address_wallet.get_address().to_hex())
	_on_godot_wallet_ready()

func _on_godot_wallet_ready():
	init_buttons()
	inject_cip_30_callbacks()

func init_buttons():
	var buttons = Buttons.new(godot_wallet, window)
	buttons.set_name("Buttons")
	add_child(buttons)

# TODO: CIP-30 compliant errors
# CIP-30 callbacks
## Adding to `window`
func inject_cip_30_callbacks():
	if !window:
		print("GD: Browser 'window' not found - skip injecting CIP-30 callbacks")
		return
	window.cardano.godot.callbacks.get_used_addresses = cb_get_used_addresses
	window.cardano.godot.callbacks.get_unused_addresses = cb_get_unused_addresses
	window.cardano.godot.callbacks.sign_data = cb_sign_data
	print("GD: injecting CIP-30 callbacks is done")

## Definitions
var cb_get_used_addresses = JavaScriptBridge.create_callback(_cb_get_used_addresses)
func _cb_get_used_addresses(args):
	var addresses = JavaScriptBridge.create_object("Array", 1)
	addresses[0] = godot_wallet.single_address_wallet.get_address().to_hex()
	var promise_callback: JavaScriptObject = args[0]
	promise_callback.call("call", promise_callback.this, addresses)
	
var cb_get_unused_addresses = JavaScriptBridge.create_callback(_cb_get_unused_addresses)
func _cb_get_unused_addresses(args):
	var addresses = JavaScriptBridge.create_object("Array", 0)
	var promise_callback: JavaScriptObject = args[0]
	promise_callback.call("call", promise_callback.this, addresses)
	
var cb_sign_data = JavaScriptBridge.create_callback(_cb_sign_data)
func _cb_sign_data(args):
	prints("GD: _cb_sign_data")
	var promise_callback: JavaScriptObject = args[0]
	var signing_address = args[1]
	var cbor_string = args[2]
	#prints("GD: address: ", address)
	#prints("GD: msg to sign: ", cbor_string)
	var sign_res = godot_wallet.single_address_wallet.sign_data("", signing_address, cbor_string)
	var signResult = JavaScriptBridge.create_object("Object")
	signResult.key = sign_res.value._cose_key_hex()
	signResult.signature = sign_res.value._cose_sig1_hex()
	promise_callback.call("call", promise_callback.this, signResult)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
