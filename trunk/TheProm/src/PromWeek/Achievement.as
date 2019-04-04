package PromWeek 
{
	import CiF.*;
	import mx.controls.Image;  import com.util.SmoothImage;
	import PromWeek.assets.ResourceLibrary;
	
	public class Achievement
	{		
		public var cif:CiFSingleton;
		public var gameEngine:PromWeek.GameEngine;

		private var rL:PromWeek.assets.ResourceLibrary = PromWeek.assets.ResourceLibrary.getInstance();
		
		public var name:String;
		public var picture:Class;
		public var grayedPicture:Class;
		public var toolTip:String;
		public var locX:Number;
		public var locY:Number;
		public var needsToFadeIn:Boolean;
		public var complete:Boolean;
		
		public function Achievement(){
			this.name = "Default Achievement";
			this.toolTip = "There is never a way to get this achievement.";
			this.picture = rL.portraits["gunter"];
			this.grayedPicture = rL.portraits["noOne"];
			this.needsToFadeIn = false;
			this.complete = false;
		}
	}
}