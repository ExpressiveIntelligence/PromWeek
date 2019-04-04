package eis 
{
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import mx.flash.UIMovieClip;
	import spark.components.Group;

	/**
	 * ...
	 * @author Josh
	 */
	public class Character
	{
		//CONSTANTS
		public const FRONT:int = 0;
		public const LEFT:int = 1;
		public const RIGHT:int = 2;
		
		public const IDLE:int = 0;
		public const WALKING:int = 1;
		public const ACTING:int = 2;
		public const TRANSIT:int = 3;
		
		public const LEFTBOUND:int = 200;
		public const RIGHTBOUND:int = 1080;
		public const BOTTOMBOUND:int = 550;
		public const TOPBOUND:int = 250;
		//----------------------
		
		public var characterName:String;
		
		public var stagingSpace:Number = 175;
		public var maxPaceDistanceX:Number = 100;
		public var maxPaceDistanceY:Number = 100;
		public var minPaceDistanceX:Number = 40;
		public var minPaceDistanceY:Number = 30;
		
		
		public var clip:UIMovieClip;
		public var locX:Number;
		public var locY:Number;
		public var depth:Number;
	
		public var speed:Number; //pixels per second
		
		public var destinationX:Number;
		public var destinationY:Number;
		
		public var facing:int; //front, left, or right
		public var currentAction:int; //walking, idle, performing script
		private var currentAnimation:String;
		
		private var storedMouseHandler:Function;
		
		//used for idle behavior
		private var lastPaceTime:Number;
		public var nextPaceTime:Number;
		
		public var justArrived:Boolean;
		
		//Social information
		public var traits:Vector.<int>;
		//the character's index into the social network data structure.
		public var networkID:int;
		
		public function Character() 
		{
			this.facing = LEFT;
			this.currentAnimation = "idle";
			this.currentAction = IDLE;
			nextPaceTime = randRange(3000, 15000);
			lastPaceTime = 0;
			this.traits = new Vector.<int>();
			justArrived = false;
		}
		
		public function onClick(e:MouseEvent):void {
			storedMouseHandler(this.characterName, e);
		}
		
		public function setClickHandler(handler:Function):void {
			storedMouseHandler = handler;
			
			this.clip.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function setMovieClip(mc:UIMovieClip):void {
			this.clip = mc;
		}
		
		public function getMovieClip():UIMovieClip {
			return this.clip;
		}
		
		public function addCharacter(g:Group):void {
			if(this.clip)
				g.addElement(this.clip);
			else
				trace("Tried to add a character's movie clip to the scene before the clip was initialized.");
		}
		
		public function setLocation(x:Number, y:Number, depth:Number=0.0):void {
			this.locX = x;
			this.locY = y;
			this.depth = depth;
			this.clip.x = x;
			this.clip.y = y;
			this.clip.depth = depth;
		}
		
		public function moveToLocation(x:Number, y:Number):void {
			//trace("Setting move location: " + x + ", " + y);
			this.destinationX = x;
			this.destinationY = y;
			
			//this.currentAction = WALKING;
			this.setAnimation("walking");
		}

		public function randRange(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		public function update(timePassed:Number, currentTime:Number):void {
			
			//trace(this.characterName + ": "+this.currentAction);
			
			//deal with idle behavior as long as we aren't acting
			if (this.currentAction != ACTING)
			{
				if (lastPaceTime == 0)
				{
					//this will only happen once at the beginning
					lastPaceTime = currentTime;
				}
				if (this.currentAction == IDLE)
				{
					//check is we haven't paced in a while and if not set a move location
					if (currentTime >= lastPaceTime + nextPaceTime)
					{
						this.speed = 30;
						var wanderDeltaX:Number = randRange( -1 * maxPaceDistanceX, maxPaceDistanceX);
						if (Math.abs(wanderDeltaX) < minPaceDistanceX)
						{
							if (wanderDeltaX < 0)
								wanderDeltaX = minPaceDistanceX * -1;
							else
								wanderDeltaX = minPaceDistanceX;
						}
						var wanderDeltaY:Number = randRange( -1 * maxPaceDistanceY, maxPaceDistanceY);
						if (Math.abs(wanderDeltaY) < minPaceDistanceY)
						{
							if (wanderDeltaY < 0)
								wanderDeltaY = minPaceDistanceY * -1;
							else
								wanderDeltaY = minPaceDistanceY;
						}
						
						//check to make sure we don't wander off the screen
						if (this.locX + wanderDeltaX < LEFTBOUND) wanderDeltaX = LEFTBOUND - this.locX + 5;
						if (this.locX + wanderDeltaX > RIGHTBOUND) wanderDeltaX = RIGHTBOUND - this.locX - 5;
						if (this.locY + wanderDeltaY > BOTTOMBOUND) wanderDeltaY = BOTTOMBOUND - this.locY - 5;
						if (this.locY + wanderDeltaY < TOPBOUND) wanderDeltaY = TOPBOUND - this.locY + 5;
						
						this.moveToLocation(this.locX + wanderDeltaX,this.locY + wanderDeltaY);
						//do a pace
						nextPaceTime = randRange(3000, 15000);
						lastPaceTime = currentTime + nextPaceTime;
					}
				}
			}
			if (this.currentAction != ACTING)
			{
				this.updateLocation(timePassed);
			}
			
		}
		
		public function updateLocation(timePassed:Number):void {
			//is we are at the location and supposed to be moving
			if ((Math.abs(this.locX - this.destinationX) < 2.0 && Math.abs(this.locY - this.destinationY) < 2.0))
			{
				//location reached!
				//if (this.destinationX != this.locX || this.destinationY != this.locY)
				//{
				if (this.currentAction == TRANSIT || this.currentAction == WALKING)
				{
					this.currentAction = ACTING;
					this.justArrived = true;
				}
				else
				{
					this.currentAction = IDLE;
				}
				
				
				
				this.setLocation(this.destinationX, this.destinationY);
				this.speed = 0;
				this.setAnimation("idle");
				//}
				return;
			}
			/*
			else if (this.locX < LEFTBOUND ||
				this.locX > RIGHTBOUND ||
				this.locY > BOTTOMBOUND ||
				this.locY < TOPBOUND)
			{
				//this means we are out of bounds and just tell it not to move anymore
				if (this.locX < LEFTBOUND) this.setLocation(LEFTBOUND + 5, this.locY);
				if (this.locX > RIGHTBOUND) this.setLocation(RIGHTBOUND - 5,this.locY);
				if (this.locY > BOTTOMBOUND) this.setLocation(this.locX,BOTTOMBOUND - 5);
				if (this.locY < TOPBOUND) this.setLocation(this.locX, TOPBOUND + 5);
				
				

			}
			*/
			//figure out which way the character ought to be facing
			//this is pretty ugly, but sould account for bugs...
			if ((this.destinationX - this.locX) <= 0)
			{
				this.facing = LEFT;
				if (this.clip.scaleX > 0)
					this.clip.scaleX *= -1;
			}
			else
			{
				if (this.clip.scaleX <= 0)
					this.clip.scaleX *= -1;
				this.facing = RIGHT;
				//this.clip.scaleX *= -1;
			}
			
			
			//move toward location as a function of how much time has passed and the speed.
			//the magic number (1000) is due the time passed being in ms while speed is in seconds.
			var length:Number = Math.sqrt(Math.pow((this.destinationX - this.locX), 2) + Math.pow((this.destinationY - this.locY), 2));
			var deltaX:Number = timePassed/1000.0*this.speed * ((this.destinationX - this.locX) / length);
			var deltaY:Number = timePassed/1000.0*this.speed * ((this.destinationY - this.locY) / length);
			
			var newX:Number = this.locX + deltaX;
			var newY:Number = this.locY + deltaY;
			
			//if we are not out of bounds
			
			//if (newX > LEFTBOUND &&
			//	newX < RIGHTBOUND &&
			//	newY < BOTTOMBOUND &&
			//	newY > TOPBOUND)
			//{			
			this.setLocation(newX, newY);	
			//}
			/*
			else
			{
				trace("BUG FOUND!?!?!");
				
				this.destinationX = this.locX;
				this.destinationY = this.locY;
				this.speed = 0;
				this.setAnimation("idle");
				
				//if we just walked out of bounds, but were in transit, just assume we are close enough to where we want to go...
				if (this.currentAction == TRANSIT)
				{
					this.currentAction = ACTING;
				}
				else
				{
					this.currentAction = IDLE;
				}				
			}
			*/
		}
		
		public function setAnimation(animName:String):void {			
			if (this.currentAnimation != animName)
			{
				//below are the automated actions, we don't want these to happen is we are "acting"
				if (animName == "walking")
				{
					//figure out which way the character ought to be facing
					//this is pretty ugly, but sould account for bugs...
					if ((this.destinationX - this.locX) <= 0)
					{
						this.facing = LEFT;
						if (this.clip.scaleX > 0)
							this.clip.scaleX *= -1;
					}
					else
					{
						if (this.clip.scaleX <= 0)
							this.clip.scaleX *= -1;
						this.facing = RIGHT;
						//this.clip.scaleX *= -1;
					}
				}
				this.clip.gotoAndPlay(animName);
				currentAnimation = animName;
			}
		}
		
		public function setTrait(t:int):void {
			this.traits.push(t);
		}
		
		/**
		 * Returns true if the character has the specified trait. It matches 
		 * the int in traits vector with the const indentifiers in the Trait
		 * class.
		 */
		public function hasTrait(t:int):Boolean {
			var i:int = 0;
			for (i = 0; i < this.traits.length; ++i) {
				if (this.traits[i] == t) return true;
			}
			return false
		}
		
		public function setNetworkID(nid:int):void {
			this.networkID = nid;
		}
	}
}