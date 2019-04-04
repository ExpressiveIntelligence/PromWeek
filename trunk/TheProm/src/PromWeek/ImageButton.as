package PromWeek 
{	
	import mx.controls.Image;  import com.util.SmoothImage;
	import spark.components.Button;
	import flash.events.MouseEvent;
	import spark.components.ToggleButton;
	import com.util.SmoothImage;
	
	public class ImageButton extends ToggleButton
	{			
		private var gameEngine:GameEngine;
		
		public var image:SmoothImage;
		
		//public var textField:RichText;
		
		public function ImageButton()
		{
			gameEngine = GameEngine.getInstance();
			this.addEventListener(MouseEvent.CLICK, clickHander);
			
			this.image = new SmoothImage();
			this.addElement(this.image);
		}

		public function setImage(data:Class):void
		{
			this.image.source = data;
			this.image.horizontalCenter = this.horizontalCenter;
			this.image.verticalCenter = this.verticalCenter;
		}
		
		private function clickHander(e:MouseEvent):void
		{			
			
		}
	}
}