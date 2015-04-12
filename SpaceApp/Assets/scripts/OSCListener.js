private var UDPHost : String = "127.0.0.1";
private var listenerPort : int = 12000;
private var broadcastPort : int = 12000;
private var oscHandler : Osc;
private var contadorDeMensajes : int = 0;
private var eventName : String = "";
private var eventData : String = "";
private var counter : int = 0;
public var output_txt : GUIText;
public var posx : float = 0;
public var posy : float = 0;
public var ancho : float = 0;
public var alto : float = 0;


public function Start ()
{	
	var udp : UDPPacketIO = GetComponent("UDPPacketIO");
	//udp.init(UDPHost, broadcastPort, listenerPort);
	udp.remoteHostName = UDPHost;
	udp.remotePort = broadcastPort;
	udp.localPort = listenerPort;
	oscHandler = GetComponent("Osc");
	oscHandler.init(udp);
			
	oscHandler.SetAddressHandler("/test", updateText);
	oscHandler.SetAddressHandler("/counterTest", counterTest);
	
}
Debug.Log("Running");

function Update () {
	//output_txt.text = "Event: " + eventName + " Event data: " + eventData;
	//print("Event: " + eventName + " Event data: " + eventData);
	print("Pos X: "+posx+" Pos Y: "+posy+" Ancho: "+ancho+" alto: "+alto);
	//var cube = GameObject.Find("Cube");
	//var boxWidth:int = counter;
    //cube.transform.localScale = Vector3(boxWidth,5,5);	
}	

public function updateText(oscMessage : OscMessage) : void
{	
	eventName = Osc.OscMessageToString(oscMessage);
	eventData = oscMessage.Values[0]+" "+oscMessage.Values[1]+" "+oscMessage.Values[2]+" "+oscMessage.Values[3];
	posx = oscMessage.Values[0];
	posy = oscMessage.Values[1];
	ancho = oscMessage.Values[2];
	alto = oscMessage.Values[3];
} 

public function counterTest(oscMessage : OscMessage) : void
{	
	Osc.OscMessageToString(oscMessage);
	counter = oscMessage.Values[0];
} 

function OnGUI(){
	GUI.Box(Rect(10,10,300,50), "Pos X: "+posx+" Pos Y: "+posy+" Ancho: "+ancho+" alto: "+alto);
}
