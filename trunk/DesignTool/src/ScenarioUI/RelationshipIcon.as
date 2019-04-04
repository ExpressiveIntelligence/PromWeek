package ScenarioUI
{
	import mx.flash.UIMovieClip;
	import spark.components.Group;
	import mx.controls.Image;  import com.util.SmoothImage;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class RelationshipIcon extends Group
	{
		
		public var whoRelIsWith:String;
		public var relType:String;
		
		public var offsetX:Number;
		public var offsetY:Number;
		
		private var mc:UIMovieClip;
		
		
		public function RelationshipIcon(type:String, who:String)
		{
			whoRelIsWith = who;
			relType = type;
			
			//Set default locations relative to avatars for each type of relationship
			switch(relType)
			{
				case "friends":
					mc = new friendIcon1() as UIMovieClip;
					offsetX = -50;
					offsetY = 50;
					break;
				case "dating":
					mc = new datingIcon1() as UIMovieClip;
					offsetX = 50;
					offsetY = 50;
					break;
				case "enemies":
					mc = new enemyIcon1() as UIMovieClip;
					offsetX = 0;
					offsetY = 50;
					break;
			}
			var scaleVal:Number = 0.4;
			offsetX *= scaleVal;
			offsetY *= scaleVal;
			mc.scaleX *= scaleVal;
			mc.scaleY *= scaleVal;
			mc.stop();
			
			mc.y = 25;
			
			this.addElement(mc);
		}
		
		/*		
		public function update():void
		{
			var charX:Number = gameEngine.worldGroup.avatars[whoRelIsWith].locX;
			var charY:Number = gameEngine.worldGroup.avatars[whoRelIsWith].locY;
			
			var newLoc:Point = gameEngine.worldGroup.avatars[whoRelIsWith].localToGlobal(new Point(charX + offsetX, charY + offsetY));
			
			this.top = newLoc.y;
			this.left = newLoc.x;
			
			//trace(relType + " " + whoRelIsWith);
		}
		*/
	}
}