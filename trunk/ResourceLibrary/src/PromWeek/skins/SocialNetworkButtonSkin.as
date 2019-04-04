package PromWeek.skins 
{
	import spark.skins.spark.ButtonSkin;
	import flash.display.Graphics;
	
	public class SocialNetworkButtonSkin extends ButtonSkin
	{
		
		private var backgroundFillColor:Number;
		private var alphaValue:Number;
		
		public function SocialNetworkButtonSkin() 
		{
			super();
			backgroundFillColor = 0x000000;
			alphaValue = 1.0;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			switch (currentState) {
				case "up":
					backgroundFillColor = 0x1F497D;
					alphaValue = 0.8;
					break;
				case "over":
					backgroundFillColor = 0x2E69B3;
					alphaValue = 1.0;
					break;
				case "down":
					backgroundFillColor = 0x518AD1;
					alphaValue = 1.0;
					break;
			}
			
			graphics.clear();
			graphics.lineStyle(2, 0x000033, 1.0);
			graphics.beginFill(backgroundFillColor, alphaValue);
			graphics.drawRoundRectComplex(0, 0, unscaledWidth, unscaledHeight, 10, 10, 10, 10);
			graphics.endFill();
		}
	}
}