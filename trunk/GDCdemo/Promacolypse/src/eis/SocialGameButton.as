package eis 
{
	import spark.components.Button;
	import flash.events.MouseEvent;
	
	public class SocialGameButton extends Button
	{	
		public var socialGame:FilledGame;
		public var offsetX:Number;
		public var offsetY:Number;
		
		public function SocialGameButton(sg:FilledGame)
		{
			socialGame = sg;
			this.addEventListener(MouseEvent.CLICK, clickHander);
		}
		
		private function clickHander(e:MouseEvent):void
		{
			//here is where we send the command to play the social game and deselect
			trace(socialGame);
		}
	}
}