package eis 
{
	import spark.components.Button;
	import flash.events.MouseEvent;
	
	public class SocialNetworkButton extends Button
	{	
		public var network:String;
		
		public var toggleStatus:Boolean;
		
		public var offsetX:Number;
		public var offsetY:Number;
		
		public function SocialNetworkButton(net:String)
		{
			network = net;
			//this.addEventListener(MouseEvent.CLICK, clickHander);
			
			toggleStatus = false;
			
			this.width = 40;
			this.height = 40;
			
			this.label = network;
		}
		
		
		/*
		private function clickHander(e:MouseEvent):void
		{
			toggleStatus = !toggleStatus;
			//here is where we send the command to play the social game and deselect
			trace(network + " " + toggleStatus);
		}
		*/
	}
}