package PromWeek 
{
	/**
	 * A Zone is meant to specify an area of the screen that a character occupies
	 * while they are idle.  Zones know whether or not someone is already standing
	 * inside of them.  Zones also know their center position, their relative width and height,
	 * and their distance from all other zones in a level.
	 * @author Ben*
	 */
	public class Zone
	{
		import CiF.Character;
		import CiF.Debug;
		import flash.geom.Point;
		import flash.utils.Dictionary;
		
		
		public var isOccupied:Boolean; //a character already lives in this zone.
		public var occupyingCharacter:String // the character that is currently living in this zone.
		public var center:Point; // the center of this zone, in x and y coordinates.
		public var width:int; //The width of this zone.
		public var height:int; // the height of this zone.
		public var leftBoundary:int; // the left boundary of this zone. right boundary = leftBoundary + width
		public var topBoundary:int; // the top boundry of this zone. bottomBoundary = topBoundary + height
		public var row:int; //an understanding of where this zone is positioned in the zone matrix that the level has.
		public var col:int; //an understanding of where this zone is positioned in the zone matrix that the level has.
		
		public var distanceDictionary:Dictionary; // how far away this zone is from other zones.  Entries in the dictionary are referenced by "[row-col]"
		
		public function Zone() 
		{
			isOccupied = false;
			distanceDictionary = new Dictionary();
		}
		
		public function toString():String {
			return "isOccupied: " + isOccupied + " center: " + center + " width: " + width + " height: " + height + " leftBoundary: " + leftBoundary + " topBoundary: " + topBoundary + " row: " + row + " col: " + col;
		}
		
		/**
		 * Returns a random x coordinate within the current zone, taking into account the avatars width, as well as a little bit of a buffer
		 * so that they try to not hang around on the edges of zones all the time!
		 * @param	a
		 * @param	xBufferLeft
		 * @param	xBufferRight
		 * @return
		 */
		public function getRandomXWithinZone(a:Avatar, xBufferLeft:int = 0, xBufferRight:int = 0):Number {
			
			//OH SNAP -- this is WAY better!
			
			//This is the largest X that we can possible get
			var maxX:Number = this.leftBoundary + (this.width - xBufferRight - (a.clip.width / 2));
			
			//This is the smallest X we can possible get
			var minX:Number = this.leftBoundary + xBufferLeft + (a.clip.width / 2);
			
			//Now I want a random number between these two values.
			var newX:Number = Utility.randRange(minX, maxX);
			
			/*
			Debug.debug(this, "GETTING RANDOM X:");
			Debug.debug(this, "this.width-a.clip.width /2 - xBufferRight: " + (this.width - a.clip.width / 2 - xBufferRight) + " (the width of the zone - character width - buffer)");
			var maxWidth:Number = this.width - a.clip.width / 2 - xBufferRight;
			
			var withRandom:Number = maxWidth * Math.random();
			
			Debug.debug(this, "previous width * random: " + withRandom + " (min: 0, max: previous width, generally: some number between 0 and width of zone");
			
			var offset:Number = this.leftBoundary + (a.clip.width / 2) + xBufferLeft;
			
			Debug.debug(this, "Offset = leftboundary " + (leftBoundary) + " + (a.clip.width / 2) " + (a.clip.width / 2) + " + xBufferLeft " + xBufferLeft + " = " + offset);
			//+ " (the 'far left' of the zone, plus half the character width, plus an extra buffer");
			
			Debug.debug(this, "FURTHEST LEFT POSSIBLE (not taking offsets into account same as left boundary): " + leftBoundary);
			offset = leftBoundary;
			
			var newX:Number = withRandom + offset;
			
			Debug.debug(this, "This is the final newX: " + newX);

			//var newX:Number = Math.random() * (this.width - a.clip.width / 2 - xBufferRight) + this.leftBoundary + (a.clip.width / 2) + xBufferLeft; WORKS!
			
			
			newX = a.adjustXBasedOnCharacter(newX, "left");
			*/
			return newX;
		}
		
		public function getRandomYWithinZone(a:Avatar):Number {
			//var newY:Number = Math.random() * this.height + this.topBoundary;
			
			var newY:Number = Utility.randRange(this.topBoundary, this.topBoundary + this.height);
			
			newY -= a.clip.height / 2;
			//Now, adjust the 'ideal' place for them to stand based on which character we are dealing with, since character's bounding boxes are all imperfect in different ways.
			//newY = a.adjustYBasedOnCharacter(newY);
			return newY;
		}
		
	}

}