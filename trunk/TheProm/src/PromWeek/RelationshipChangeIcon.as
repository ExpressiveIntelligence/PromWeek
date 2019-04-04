package PromWeek 
{
	import flash.events.Event;
	import flash.geom.Point;
	import mx.controls.Image;  import com.util.SmoothImage;
	import mx.flash.UIMovieClip;
	import spark.components.Group;
	import spark.components.RichText;
	import flash.text.engine.FontWeight;
	import PromWeek.assets.ResourceLibrary;
	import com.util.SmoothImage;
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class RelationshipChangeIcon extends Group
	{
		private var gameEngine:GameEngine;
		private var resourceLibrary:PromWeek.assets.ResourceLibrary;
		
		/**
		 * Name of the character who this social change is happening to
		*/
		public var fromWho:String;
		public var toWho:String;
		
		public var offsetX:Number = 0;
		public var offsetY:Number = -50;
		
		public var alphaSpeed:Number = 0.5;
		public var deltaAlpha:Number = 0;
		
		public var timeToRemove:Boolean = false;
		
		public var timeLength:Number = 8000;
		
		private var startTime:Number;

		public var relationshipImage:SmoothImage;
		
		private var mc:UIMovieClip;
		
		public function RelationshipChangeIcon(fromWho1:String, toWho1:String, relType:String, negated:Boolean)
		{
			gameEngine = GameEngine.getInstance();
			resourceLibrary = PromWeek.assets.ResourceLibrary.getInstance();
			
			this.fromWho = fromWho1;
			this.toWho = toWho1;
			
			//this.relationshipImage = new Image();
			
			if (negated && relType == "friends")
			{
				this.mc = this.resourceLibrary.getRelationshipIcon("friendsEnd");
				//this.relationshipImage.source = resourceLibrary.relationshipIcons["endFriends"];
			}
			else if (negated && relType == "dating")
			{
				this.mc = this.resourceLibrary.getRelationshipIcon("datingEnd");
				//this.relationshipImage.source = resourceLibrary.relationshipIcons["endDating"];
			}
			else if (negated && relType == "enemies")
			{
				this.mc = this.resourceLibrary.getRelationshipIcon("enemiesEnd");
				//this.relationshipImage.source = resourceLibrary.relationshipIcons["endEnemies"];
			}
			else if (relType == "friends" || relType == "dating" || relType == "enemies")
			{
				this.mc = this.resourceLibrary.getRelationshipIcon(relType);
				//this.relationshipImage.source = resourceLibrary.relationshipIcons[relType];
			}
			else
			{
				trace("Relationship partial change not recognized: " + relType);
			}
			
			
			
			this.mc.addEventListener("end", mcEnded );
			
			//this.addElement(relationshipImage);
			
			this.addElement(mc);
			
			var leftChar:String;
			var rightChar:String;
			if (gameEngine.worldGroup.avatars[this.fromWho.toLowerCase()].locX > gameEngine.worldGroup.avatars[this.toWho.toLowerCase()].locX)
			{
				leftChar = this.toWho;
				rightChar = this.fromWho;
			}
			else
			{
				leftChar = this.fromWho;
				rightChar = this.toWho;
			}
			
			var locX:Number = gameEngine.worldGroup.avatars[leftChar].locX + (gameEngine.worldGroup.avatars[rightChar.toLowerCase()].locX - gameEngine.worldGroup.avatars[leftChar].locX)/2 - this.mc.width / 2 + this.offsetX;
			//var locY:Number = gameEngine.worldGroup.avatars[fromWho].locY + - gameEngine.worldGroup.avatars[rightChar.toLowerCase()].clip.height/2 + this.offsetY;
			var locY:Number = (gameEngine.worldGroup.avatars[leftChar].locY + gameEngine.worldGroup.avatars[rightChar].locY)/2 + - gameEngine.worldGroup.avatars[rightChar.toLowerCase()].clip.height/2 + this.offsetY;
			
			//var newLoc:Point = gameEngine.worldGroup.avatars[leftChar].localToGlobal(new Point(locX, locY));
			var newLoc:Point = new Point(locX, locY);
			newLoc = Utility.translatePoint(newLoc, gameEngine.worldGroup, gameEngine.hudGroup)
			
			
			this.left = newLoc.x;
			this.top = newLoc.y;
			
			startTime = new Date().time;
		}

		public function mcEnded(e:Event):void
		{
			this.visible = false;
			timeToRemove = true;
		}
		
		public function update(elapsedTime:Number):void
		{	
			//if we should be over then go invisible
			if (((new Date().time) - this.startTime) > timeLength || timeToRemove || gameEngine.worldGroup.avatars[fromWho] == null)
			{
				//remove this from the list of networkChangeIcons
				gameEngine.hudGroup.relationshipChangeIcons.splice(gameEngine.hudGroup.relationshipChangeIcons.indexOf(this),1);
				gameEngine.hudGroup.removeElement(this);
			}
		}
	}
		
}