class_name UDPClient

extends Node

signal message(content:String)

var connected:bool:
	get:
		return _connected

var _udp := PacketPeerUDP.new()
var _connected:bool = false

func _ready():
	_udp.connect_to_host("127.0.0.1", 4242)

func _exit_tree():
	_udp.close()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_udp.close()

func send_package(content:String):
	if _connected:
		_udp.put_packet(content.to_utf8_buffer())

func _process(_delta):
	if !_connected:
		# Try to contact server
		_udp.put_packet("Client connecting...".to_utf8_buffer())

	# Print first connection
	if _udp.get_available_packet_count() > 0 and !_connected:
		print(_udp.get_packet().get_string_from_utf8())
		_connected = true
	
	# Response for pulse from server
	if _udp.get_available_packet_count() > 0 and _connected:
		var packet = _udp.get_packet()
		var content:String = packet.get_string_from_utf8()
		if content == UDPServerController.PULSE_MESSAGE:
			_udp.put_packet(packet)
		else:
			message.emit(content)
