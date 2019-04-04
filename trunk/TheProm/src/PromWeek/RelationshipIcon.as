package PromWeek 
{
	import mx.flash.UIMovieClip;
	import mx.graphics.SolidColorStroke;
	import mx.graphics.Stroke;
	import spark.components.Group;
	import mx.controls.Image;  import com.util.SmoothImage;
	import flash.geom.Point;
	import PromWeek.assets.ResourceLibrary;
	
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class RelationshipIcon extends Group
	{
		private var gameEngine:GameEngine;
		private var resourceLibrary:PromWeek.assets.ResourceLibrary;
		
		public var whoRelIsWith:String;
		public var relType:String;
		
		public var offsetX:Number;
		public var offsetY:Number;
		
		private var mc:UIMovieClip;
		
		
		public function RelationshipIcon(who:String, type:String)
		{
			gameEngine = GameEngine.getInstance();
			resourceLibrary = PromWeek.assets.ResourceLibrary.getInstance();
			
			whoRelIsWith = who;
			relType = type;
			
			mc = resourceLibrary.characterClips["edward"];//resourceLibrary.getRelationshipIcon(relType);
			
			//Set default locations relative to avatars for each type of relationship
			switch(relType)
			{
				case "friends":
					offsetX = 25;
					offsetY = -150;
					break;
				case "dating":
					offsetX = -70;
					offsetY = -150;
					break;
				case "enemies":
					offsetX = 0;
					offsetY = -165
					break;
			}
			
			this.top = gameEngine.worldGroup.avatars[whoRelIsWith].locX;
			this.left = gameEngine.worldGroup.avatars[whoRelIsWith].locY;
			
			this.addElement(mc);
		}
		
		
		public function update():void
		{
			var charX:Number = gameEngine.worldGroup.avatars[whoRelIsWith].locX;
			var charY:Number = gameEngine.worldGroup.avatars[whoRelIsWith].locY;
			
			var newLoc:Point = gameEngine.worldGroup.avatars[whoRelIsWith].localToGlobal(new Point(charX + offsetX, charY + offsetY));
			
			this.top = newLoc.y;
			this.left = newLoc.x;
			
			//trace(relType + " " + whoRelIsWith);
		}
	}
}