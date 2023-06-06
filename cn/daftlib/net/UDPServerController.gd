class_name UDPServerController

extends Node

const MAX_ALIVE_TIMEOUT:int = 1
const SERVER_PREFIX:String = "[UDP_SERVER_CONTROLLER] "
const PULSE_MESSAGE:String = SERVER_PREFIX + "Pulse"

signal message(content:String)

var _port:int
var _server := UDPServer.new()
var _peers:Array[PeerData] = []
var _pulse_count:int = 0

func _init(port:int = 4242):
	_port = port

func _ready():
	_server.listen(_port)
	var timer:Timer = Timer.new()
	self.add_child(timer)
	timer.timeout.connect(_pulse_peers)
	timer.start(1)

func _process(_delta):
	_server.poll() # Important!

	if _server.is_connection_available():
		var peer:PacketPeerUDP = _server.take_connection()
		var packet = peer.get_packet()
		message.emit("Accepted: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
		message.emit(packet.get_string_from_utf8())
		# Reply so it knows we received the message.
		peer.put_packet((SERVER_PREFIX + "Client connected").to_utf8_buffer())
		# Keep a reference so we can keep contacting the remote peer.
		var data:PeerData = PeerData.new()
		data.peer = peer
		data.alive_timeout = 0
		data.is_alive = true
		_peers.append(data)

	if _peers.size() > 0:
		_check_packet()

func _pulse_peers():
	if _peers.size() == 0: return
	
	if _pulse_count % 2 == 0:
		_send_pulse()
	else:
		_update_alive()

	_pulse_count += 1

func _send_pulse():
	for i in range(0, _peers.size()):
		var data:PeerData = _peers[i]
		data.is_alive = false
		data.peer.put_packet(PULSE_MESSAGE.to_utf8_buffer())

func _check_packet():
	for i in range(0, _peers.size()):
		var data:PeerData = _peers[i]
		if data.peer.get_available_packet_count():
			var packet = data.peer.get_packet()
			var content:String = packet.get_string_from_utf8()
			if content == PULSE_MESSAGE:
				data.is_alive = true
				data.alive_timeout = 0
			elif content.length() > 0:
				message.emit(content)

func _update_alive():
	for i in range(_peers.size()-1, -1, -1):
		var data:PeerData = _peers[i]
		if data.is_alive == false:
			if data.alive_timeout >= MAX_ALIVE_TIMEOUT:
				var dead:PeerData = _peers.pop_at(i)
				var peer:PacketPeerUDP = dead.peer
				message.emit("Disconnect: %s:%s" % [peer.get_packet_ip(), peer.get_packet_port()])
			else:
				data.alive_timeout += 1

class PeerData:
	var peer:PacketPeerUDP
	var is_alive:bool
	var alive_timeout:int
