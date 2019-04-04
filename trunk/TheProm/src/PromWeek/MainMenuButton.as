package PromWeek 
{
	
	import mx.controls.Image;  import com.util.SmoothImage;
	import spark.components.Button;
	
	import PromWeek.skins.MainMenuButtonSkin;
	import PromWeek.GameEngine;
	
	public class MainMenuButton extends Button
	{
		[Bindable]
		public var title:String;
		
		[Bindable]
		public var imageData:Class;
		
		private var gameEngine:PromWeek.GameEngine;
		
		public function MainMenuButton()
		{
			super();
			gameEngine = PromWeek.GameEngine.getInstance();
			setStyle("skinClass", Class(MainMenuButtonSkin));
			setStyle("styleName", PromWeek.GameEngine.getInstance().activeStyleName);
		}
		
		/**
		 * Sets the style according to what boolean is true in game engine. This is called in gameEngine with all other components that change
		 * their style at the same time.
		 */
		public function setStyleName():void {
			this.setStyle("styleName", PromWeek.GameEngine.getInstance().activeStyleName);
			/*if(gameEngine.classicPromColors) {
				this.setStyle("styleName", "classicPromWeek");
			}
			else if(gameEngine.greenPromColors) {
				this.setStyle("styleName", "greenColor");
			}
			else if(gameEngine.redPromColors) {
				this.setStyle("styleName", "redColor");
			}*/
			this.setStyle("skinClass", Class(MainMenuButtonSkin));
			this.invalidateProperties();
			this.skin.invalidateProperties();
		}
	}
}