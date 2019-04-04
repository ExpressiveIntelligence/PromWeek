package PromWeek 
{
	
	import mx.controls.Image;  import com.util.SmoothImage;
	import spark.components.Button;
	
	import PromWeek.skins.StoryButtonSkin;
	
	public class StoryButton extends Button
	{
		[Bindable]
		public var title:String;
		
		[Bindable]
		public var description:String;
		
		[Bindable]
		public var imageData:Class;
		
		public var story:Story;
		
		public function StoryButton()
		{
			super();
			setStyle("skinClass", Class(StoryButtonSkin));
			setStyle("styleName", PromWeek.GameEngine.getInstance().activeStyleName);
		}
		
		public function setStyleName():void {
			this.setStyle("styleName", PromWeek.GameEngine.getInstance().activeStyleName);
			this.setStyle("skinClass", Class(StoryButtonSkin));
			this.invalidateProperties();
		}
	}
}