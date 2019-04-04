package PromWeek 
{
	import CiF.Cast;
	import CiF.Character;
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.LineOfDialogue;
	import CiF.Predicate;
	import CiF.ProspectiveMemory;
	import CiF.RelationshipNetwork;
	import CiF.Status;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import mx.flash.UIMovieClip;
	import mx.graphics.SolidColorStroke;
	import spark.components.Group;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import spark.primitives.Rect;
	import mx.controls.Alert;
	import spark.utils.TextFlowUtil;
	import flashx.textLayout.elements.TextFlow;
	import mx.graphics.Stroke;
	
	import com.demonsters.debugger.MonsterDebugger;
	
	/**
	 * General documentation
	 * <p>
	 * more general documenation
	 * </p>
	 * 
	 * @see PromWeek.Avatar
	 * 
	 */
	public class Avatar extends Group
	{
		
		public static const HOW_LONG_TO_HOLD_FACE_STATE_AFTER_A_SOCIAL_GAME:int = 20000;
		
		public var showOutline:Boolean = false;
		public var showLocationDot:Boolean = false;
		
		private var IS_FADING_OUT:Boolean = false;
		private var SHOULD_BE_CHECKING_FOR_FADING:Boolean = false // an attempt at a performance increase.
		
		
		
		public static const LEFT:int = 0;
		public static const RIGHT:int = 1;
		
		public static const STANDING:int = 2;
		public static const WALKING:int = 3;
		public static const ACTING:int = 4;

		public static const BUMPING_DISTANCE:Number = 50; // how close two characters have to be for a standing character to react to being 'bumped' into by a walking character..
		public var recentlyBumped:Dictionary = new Dictionary();
		
		public static const DEFAULT_SUBJECTIVE_OPINION:int = -1000;
		
		public var closeEnough:Number = 6.0;
		
		public var characterName:String;

		public var clip:UIMovieClip;
		
		public var locX:Number;
		public var locY:Number;
	
		public var speed:Number; //pixels per second

		private var _state:int;

		
		public var lastTimeOfNetworkChange:Number = 0;
		
		
		public var currentAnimation:String;
		public var lookingAtTarget:String;
		
		public var lastTimeDanced:Number;
		public var timeTillNextDance:Number;
		
		public var destinationX:Number;
		public var destinationY:Number;

		public var homeLocX:Number;
		public var homeLocY:Number;
		public var homeTargetLookingDirection:String;
		
		//Used for determining where people stand/what zones they should be in.
		public var needsToBeAssignedANewZone:Boolean = true; // they haven't been assigned a zone yet for this current placement cycle.
		public var currentZone:Zone;
		
		public var facing:int; //left, or right
		
		//The little nameplate that appears when you hover your mouse over a character.
		public var namePlate:CharacterNameplate;
		
		
		/**
		 * The one action a character *really* wants to take
		 */
		public var pendingAutonomousAction:AutonomousAction;
		
		
		private var gameEngine:GameEngine;
		private var statisticsManager:StatisticsManager;
		
		
		public var movePath:Vector.<Point>;
		
		private var _listeners:Object = {};
 
		/**
		 * The arrays are to be indexed by the character's network id. The value is the 0-1 value corresponding to the
		 * mashup of intent scores.
		 */
		public var subjectiveGreenOpinions:Array;
		public var prevSubjectiveGreenOpinions:Array;
		public var subjectiveRedOpinions:Array;
		public var prevSubjectiveRedOpinions:Array;
		public var subjectiveBlueOpinions:Array;
		public var prevSubjectiveBlueOpinions:Array;

		public var cif:CiFSingleton;
		
		public var rect:Rect;
		public var zoneLocationRect:Rect;
		
		/**
		 * This is the time that the last face state was set. It gets set right after a social game.
		 */
		public var timeFaceStateWasSet:Number;
		public var hasNonIdleFaceState:Boolean = false;
		
		
		public function Avatar(mc:UIMovieClip) 
		{
			cif = CiFSingleton.getInstance();
			
			gameEngine = GameEngine.getInstance();
			
			
			
			statisticsManager = StatisticsManager.getInstance();
			
			this.subjectiveGreenOpinions = new Array(CiFSingleton.getInstance().cast.characters.length);
			this.prevSubjectiveGreenOpinions = new Array(CiFSingleton.getInstance().cast.characters.length);
			this.subjectiveRedOpinions = new Array(CiFSingleton.getInstance().cast.characters.length);
			this.prevSubjectiveRedOpinions = new Array(CiFSingleton.getInstance().cast.characters.length);
			this.subjectiveBlueOpinions = new Array(CiFSingleton.getInstance().cast.characters.length);
			this.prevSubjectiveBlueOpinions = new Array(CiFSingleton.getInstance().cast.characters.length);
			for (var i:int = 0 ; i <  this.subjectiveGreenOpinions.length; i++ )
			{
				this.subjectiveGreenOpinions[i] = DEFAULT_SUBJECTIVE_OPINION;
				this.prevSubjectiveGreenOpinions[i] = DEFAULT_SUBJECTIVE_OPINION;
				this.subjectiveRedOpinions[i] = DEFAULT_SUBJECTIVE_OPINION;
				this.prevSubjectiveRedOpinions[i] = DEFAULT_SUBJECTIVE_OPINION;
				this.subjectiveBlueOpinions[i] = DEFAULT_SUBJECTIVE_OPINION;
				this.prevSubjectiveBlueOpinions[i] = DEFAULT_SUBJECTIVE_OPINION;
			}
			
			this.clip = mc;
			this.addElement(this.clip);
			
			this.speed = 150;
			
			//var r:Rectangle = new Rectangle();
			//r.width = this.clip.width;
			//r.height = this.clip.height;
			//this.clip.mask = 
			
			//this.clip.addEventListener(MouseEvent.CLICK, this.onClick);
			
			this.clip.scaleX = 1//gameEngine.applicationScale;
			this.clip.scaleY = 1//gameEngine.applicationScale;
			
			movePath = new Vector.<Point>();
			
			rect = new Rect();
			rect.width = this.clip.width;
			rect.height = this.clip.height;
			var stroke:SolidColorStroke = new SolidColorStroke();
			stroke.color = 0x000000;
			rect.stroke = stroke;
			
			this.addElement(rect);
			
			if (this.showOutline)
			{
				rect.visible = true;
			}
			else
			{
				rect.visible = false;
			}
			
			//this.state = Avatar.STANDING;
		}
		private var test:Boolean = false;
		public function update(elapsedTime:Number):void
		{
			//Fading out experiment.
			var alphaDecrementRate:Number = .08;
			var alphaIncrementRate:Number = .08;
			
			if(SHOULD_BE_CHECKING_FOR_FADING){
				if (IS_FADING_OUT && this.clip.alpha > 0) {
					this.clip.alpha -= alphaDecrementRate;
					if (this.clip.alpha < 0) { this.clip.alpha = 0; SHOULD_BE_CHECKING_FOR_FADING = false; }
				}
				else if(!IS_FADING_OUT && this.clip.alpha < 1) {
					this.clip.alpha += alphaIncrementRate;
					if (this.clip.alpha > 1)  { this.clip.alpha = 1; SHOULD_BE_CHECKING_FOR_FADING = false; }
				}
			}
			
			
			if (hasNonIdleFaceState)
			{
				if (new Date().time - this.timeFaceStateWasSet > Avatar.HOW_LONG_TO_HOLD_FACE_STATE_AFTER_A_SOCIAL_GAME)
				{
					clip.faceMC.currentState = "idle";
					this.clip.faceMC.goToState();
					hasNonIdleFaceState = false;
				}
			}
			
/*			if (movePath.length == 0 && characterName == "jordan" && !test)
			{
				test = true;
				
				movePath.push(new Point(5, 2));
				movePath.push(new Point(5, 3));
				movePath.push(new Point(6,3));
			}*/
			
			this.updateLocation(elapsedTime);
			
			//Find out if someone is walking on top of the avatar (and if so, have them react).
			if(this.state == Avatar.STANDING){ // only get bumped if you are standing still.
				for each(var person:Avatar in gameEngine.worldGroup.avatars) {
					if(person && person.state == Avatar.WALKING && !person.IS_FADING_OUT){ // only walking people who aren't disappearing can bump you.
						this.avatarIsBeingWalkedOn(person); // plays an animation, if you are being walked on.
					}
				}
			}
			this.updateAnimation();
			
			//Update the nameplate, so that we make sure it is appearing in the right position if the avatar walks!
			if(this.namePlate != null)
				this.namePlate.update();
				
			//Let's try drawing a little rectangle on their 'locX and locY' -- which I believe
			//is what is used to determine where they are standing...
			//var tempRect:Rect = new Rect();
			if(showLocationDot){
				if (this.zoneLocationRect) {
					//Debug.debug(this, "Do I ever get in here?");
					this.zoneLocationRect.x = locX;
					this.zoneLocationRect.y = locY + this.clip.height / 2;
					var characterCentricYOffset:Number = this.adjustYBasedOnCharacter(this.zoneLocationRect.y);
					this.zoneLocationRect.y = characterCentricYOffset;
					this.zoneLocationRect.width = 1;
					this.zoneLocationRect.height = 1;
					this.zoneLocationRect.stroke = new Stroke(0x0000FF, 2);
				}
			}
			//this.addElement(tempRect);
		}
		
		
		
		public function createGreenValueTowards(towardChar:Character):Number
		{
			var primaryProsMem:ProspectiveMemory = CiFSingleton.getInstance().cast.getCharByName(this.characterName).prospectiveMemory;
			
			var posTotalWeight:Number = 0.0;
			var negTotalWeight:Number = 0.0;
			
			var pos:Number = 0.0;
			var neg:Number = 0.0;
			var curIntent:Number;
			
			var finalGreenValue:Number;
			
			//Positive Buddy
			
			//when merging pos and neg, do pos - neg.
			
			//determine which intent scores exist to get the basis for the weights we wish to use									
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_FRIENDS, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) posTotalWeight += PromWeek.CharacterInfoUI.BUDDY_FRIENDS_SIGNIFICANCE;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_BUDDY_UP, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) posTotalWeight += CharacterInfoUI.BUDDY_BUDDY_UP_SIGNIFICANCE;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_END_ENEMIES, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) posTotalWeight += CharacterInfoUI.BUDDY_END_ENEMIES_SIGNIFICANCE;

			//add them to the pos or neg total given their weight WRT the missing intents
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_FRIENDS, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) pos += curIntent * CharacterInfoUI.BUDDY_FRIENDS_SIGNIFICANCE / posTotalWeight;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_BUDDY_UP, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) pos += curIntent * CharacterInfoUI.BUDDY_BUDDY_UP_SIGNIFICANCE / posTotalWeight;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_END_ENEMIES, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) pos += curIntent * CharacterInfoUI.BUDDY_END_ENEMIES_SIGNIFICANCE / posTotalWeight

			
			//Negative Buddy
			//determine which intent scores exist to get the basis for the weights we wish to use									
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_END_FRIENDS, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) negTotalWeight += CharacterInfoUI.BUDDY_END_FRIENDS_SIGNIFICANCE;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_BUDDY_DOWN, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) negTotalWeight+= CharacterInfoUI.BUDDY_BUDDY_DOWN_SIGNIFICANCE;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_ENEMIES, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) negTotalWeight += CharacterInfoUI.BUDDY_ENEMIES_SIGNIFICANCE;

			//add them to the pos or neg total given their weight WRT the missing intents
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_END_FRIENDS, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) neg += curIntent * CharacterInfoUI.BUDDY_END_FRIENDS_SIGNIFICANCE/ negTotalWeight;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_BUDDY_DOWN, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) neg += curIntent * CharacterInfoUI.BUDDY_BUDDY_DOWN_SIGNIFICANCE / negTotalWeight;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_ENEMIES, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) neg += curIntent * CharacterInfoUI.BUDDY_ENEMIES_SIGNIFICANCE / negTotalWeight


			finalGreenValue = pos - neg;
			
			return CharacterInfoUI.getPortionOfLineToFill(finalGreenValue);
		}
		
		
		public function createRedValueTowards(towardChar:Character):Number
		{
			var primaryProsMem:ProspectiveMemory = CiFSingleton.getInstance().cast.getCharByName(this.characterName).prospectiveMemory;
			
			var posTotalWeight:Number = 0.0;
			var negTotalWeight:Number = 0.0;
			
			var pos:Number = 0.0;
			var neg:Number = 0.0;
			var curIntent:Number;
			
			var finalRedValue:Number;
			
			//determine which intent scores exist to get the basis for the weights we wish to use									
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_DATING, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) posTotalWeight += CharacterInfoUI.ROMANCE_DATING_SIGNIFICANCE;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_ROMANCE_UP, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) posTotalWeight += CharacterInfoUI.ROMANCE_ROMANCE_UP_SIGNIFICANCE;

			//add them to the pos or neg total given their weight WRT the missing intents
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_DATING, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) pos += curIntent * CharacterInfoUI.ROMANCE_DATING_SIGNIFICANCE / posTotalWeight;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_ROMANCE_UP, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) pos += curIntent * CharacterInfoUI.ROMANCE_ROMANCE_UP_SIGNIFICANCE/ posTotalWeight;
			
			//Negative Romance
			//determine which intent scores exist to get the basis for the weights we wish to use									
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_END_DATING, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) negTotalWeight += CharacterInfoUI.ROMANCE_END_DATING_SIGNIFICANCE;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_ROMANCE_DOWN, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) negTotalWeight+= CharacterInfoUI.ROMANCE_ROMANCE_DOWN_SIGNIFICANCE;

			//add them to the pos or neg total given their weight WRT the missing intents
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_END_DATING, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) neg += curIntent * CharacterInfoUI.ROMANCE_END_DATING_SIGNIFICANCE/ negTotalWeight;
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_ROMANCE_DOWN, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) neg += curIntent * CharacterInfoUI.ROMANCE_ROMANCE_DOWN_SIGNIFICANCE / negTotalWeight;

			finalRedValue = pos - neg;
			
			return CharacterInfoUI.getPortionOfLineToFill(finalRedValue);
		}
		
		public function createBlueValueTowards(towardChar:Character):Number
		{
			var primaryProsMem:ProspectiveMemory = CiFSingleton.getInstance().cast.getCharByName(this.characterName).prospectiveMemory;
			
			var posTotalWeight:Number = 0.0;
			var negTotalWeight:Number = 0.0;
			
			var pos:Number = 0.0;
			var neg:Number = 0.0;
			var curIntent:Number;
			
			if ((this.characterName.toLowerCase() == "kate" && towardChar.characterName.toLowerCase() == "doug")) {
				Debug.debug(this, "here");
			}
			
			var finalBlueValue:Number;
			
			//determine which intent scores exist to get the basis for the weights we wish to use									
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_COOL_UP, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) posTotalWeight += CharacterInfoUI.COOL_COOL_UP_SIGNIFICANCE;
			
			//add them to the pos or neg total given their weight WRT the missing intents
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_COOL_UP, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) pos += curIntent * CharacterInfoUI.COOL_COOL_UP_SIGNIFICANCE / posTotalWeight;
			
			//Negative Buddy
			//determine which intent scores exist to get the basis for the weights we wish to use									
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_COOL_DOWN, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) negTotalWeight += CharacterInfoUI.COOL_COOL_DOWN_SIGNIFICANCE;

			//add them to the pos or neg total given their weight WRT the missing intents
			curIntent = primaryProsMem.getIntentScore(Predicate.INTENT_COOL_DOWN, towardChar);
			if ( ProspectiveMemory.DEFAULT_INTENT_SCORE != curIntent) neg += curIntent * CharacterInfoUI.COOL_COOL_DOWN_SIGNIFICANCE/ negTotalWeight;

			finalBlueValue = pos - neg;
			
			
			
			return CharacterInfoUI.getPortionOfLineToFill(finalBlueValue);
		}
		
		
		public function updateFacing():void
		{
			if (this.lookingAtTarget == "left")
			{
				if (this.clip.scaleX > 0)
				{
					this.clip.scaleX *= -1;
					this.facing = Avatar.LEFT;
				}
			}
			else if (this.lookingAtTarget == "right")
			{
				if (this.clip.scaleX < 0)
				{
					this.clip.scaleX *= -1;
					this.facing = Avatar.RIGHT;
				}
			}
			else
			{
				//this means we're facing a character
				//check to see which side of the character we're on
				if ((this.locX - gameEngine.worldGroup.avatars[lookingAtTarget].locX) > 0)
				{
					//we're on the right so we should face left
					if (this.clip.scaleX > 0)
					{
						this.clip.scaleX *= -1;
						this.facing = Avatar.LEFT;
					}
				}
				else
				{
					//we're on the left so we should face right
					if (this.clip.scaleX < 0)
					{
						this.clip.scaleX *= -1;
						this.facing = Avatar.RIGHT;
					}
				}
			}
		}
		
		/**
		 * fehwklfejwklfjewlf
		 * <p>
		 * ewfjkwelfjkelwfjew
		 * </p>
		 * @see CiF.CiFSingleton
		 * 
		 * @example <listing version="3.0">
		 * //An in actionscript code example of how to use something
		 * var i:int = 5;
		 * </listing>
		 * 
		 * @param	timePassed description of the parameter
		 * 
		 */
		public function updateLocation(timePassed:Number):void 
		{	
			//is we are at the location and supposed to be moving
			if ((Math.abs(this.locX - this.destinationX) < closeEnough && Math.abs(this.locY - this.destinationY) < closeEnough))// && this.state == Avatar.WALKING)
			{	
				if (movePath.length > 0)
				{
					//this means that we are in an intermediate cell and should travel to the next
					moveToGridPoint(movePath.pop());
				}
				else
				{					
					//location reached!
					this.setLocation(this.destinationX, this.destinationY);
					
					this.state = Avatar.STANDING;
					
					//now that we're done walking update which way we're facing
					this.updateFacing();
					
					if (gameEngine.currentState == "Performance")
					{
						if (this.characterName == gameEngine.initiatorName && !gameEngine.socialGamePlaying)
						{
							if (!gameEngine.initiatorArrived)
							{
								gameEngine.initiatorArrived = true;
							}				
						}
						
						if (this.characterName == gameEngine.responderName && !gameEngine.socialGamePlaying)
						{
							if (!gameEngine.responderArrived)
							{
								gameEngine.responderArrived = true;
							}
						}
						
						//Deal with Other getting in place for performance up here maybe?
						if (gameEngine.otherDeparted) {
							if (gameEngine.otherDeparted && this.characterName.toLowerCase() == gameEngine.otherName.toLowerCase()) {
								if (!gameEngine.otherArrived) {
									gameEngine.otherArrived = true;
									gameEngine.otherDeparted = false;
									gameEngine.hudGroup.otherIsApproachingText.visible = false; // they have arrived!  You can click now!
								}
							}
						}
					}
					return;
				}
			}
			
			/*
			//DEAL WITH OTHER FINDING THEIR PERFORMING SPOT (only flags to true if we are looking at the other and they HAVE departed.
			if (gameEngine.otherDeparted) {
				//Debug.debug(this, "this.locX - this.destinationX " + Math.abs(this.locX - this.destinationX) + " this.locY - this.destinationY " + Math.abs(this.locY - this.destinationY));
				if (gameEngine.otherName && this.characterName.toLowerCase() == gameEngine.otherName.toLowerCase() && (Math.abs(this.locX - this.destinationX) < 15 && Math.abs(this.locY - this.destinationY) < 15))// && this.state == Avatar.WALKING)
				{	
					if (movePath.length > 0)
					{
						//this means that we are in an intermediate cell and should travel to the next
						moveToGridPoint(movePath.pop());
					}
					else
					{					
						//location reached!
						this.setLocation(this.destinationX, this.destinationY);
						
						this.state = Avatar.STANDING;
						
						//now that we're done walking update which way we're facing
						this.updateFacing();
						
						if (gameEngine.currentState == "Performance")
						{
							if (this.characterName.toLowerCase() == gameEngine.otherName.toLocaleLowerCase() && gameEngine.socialGamePlaying)
							{
								if (characterName.toLowerCase() == "zack") {
									Debug.debug(this, "our debug case");
								}
								if (!gameEngine.otherArrived)
								{
									gameEngine.otherArrived = true;
									gameEngine.otherDeparted = false;
									gameEngine.hudGroup.otherIsApproachingText.visible = false; // they have arrived!  You can click now!
								}
							}
						}
						return;
					}
				}
			}
			*/

			//figure out which way the character ought to be facing
			//this is pretty ugly, but sould account for bugs...
			if ((this.destinationX - this.locX) <= 0)
			{
				this.facing = LEFT;
				if (this.clip.scaleX > 0)
				{
					this.clip.scaleX *= -1;
				}
			}
			else
			{
				if (this.clip.scaleX <= 0)
				{
					this.clip.scaleX *= -1;
				}
				this.facing = RIGHT;
			}
			
			
			//move toward location as a function of how much time has passed and the speed.
			//the magic number (1000) is due the time passed being in ms while speed is in seconds.
			var length:Number = Math.sqrt(Math.pow((this.destinationX - this.locX), 2) + Math.pow((this.destinationY - this.locY), 2));
			var deltaX:Number = timePassed/1000.0*this.speed * ((this.destinationX - this.locX) / length);
			var deltaY:Number = timePassed/1000.0*this.speed * ((this.destinationY - this.locY) / length);
			
			if ((Math.abs(deltaX) + Math.abs(deltaY)) > 20)
			{
				return;
			}
			
			var newX:Number = this.locX + deltaX;
			var newY:Number = this.locY + deltaY;
			
			this.setLocation(newX, newY);
		}
		
		
		/**
		 * moveToLovation sets the destination for which the updatePosition function will
		 * begin moving the character towards x, y.
		 * @param	x
		 * @param	y
		 */
		public function moveToLocation(x:Number, y:Number):void 
		{
			this.state = Avatar.WALKING;
			
			//Lets do a little baby check to make sure that they aren't going to be standing on anybody
			//else -- if they are, adjust the numbers ever so slightly.
			for each (var person:Avatar in gameEngine.worldGroup.avatars) {
				if (person.characterName.toLowerCase() != this.characterName.toLowerCase() 
				&& x == person.destinationX && y == person.destinationY) {
					//Find out if I am headed left or right.
					//Debug.debug(this, "moveToLocation() I'm getting here, because i think that " + person.characterName + " is going to same spot as me?");
					//if left, now I want to go 'extra' left.
					//if right, extra right.
					//if neither, assume down, go 'extra down').
					if (x - this.locX > 0) // going right
						x += person.clip.width / 2 + this.clip.width / 2;
					else if (x - this.locX < 0 ) // going left
						x -= person.clip.width / 2 + this.clip.width / 2;
					else // assume going down
						y += person.clip.height / 2 + this.clip.height / 2;
				}
			}
			
			/*
			if (this.characterName.toLowerCase() == "monica") {
				Debug.debug(this, "moveToLocation() Monica is now moving to x: " + x + " and y: " + y);
			}

			
			if (this.characterName.toLowerCase() == "jordan") {
				Debug.debug(this, " moveToLocation() Jordan is now moving to x: " + x + " and y: " + y);
			}
			*/
			
			this.destinationX = x;
			this.destinationY = y;
		}
		
		public function moveToGridPoint(point:Point):void 
		{
			this.state = Avatar.WALKING;

			//translate the point locations to screen coordinates
			this.destinationX = point.x * gameEngine.worldGroup.currentSetting.cellWidth + gameEngine.worldGroup.currentSetting.cellWidth/2;
			this.destinationY = point.y * gameEngine.worldGroup.currentSetting.cellHeight + gameEngine.worldGroup.currentSetting.horizonHeight + gameEngine.worldGroup.currentSetting.cellHeight/2 - clip.height/2;
		}
		
		/**
		 * Builds a vector of points that get to the destination point without occupying the same cell as anytyhing else. The 
		 * movePath in the end will be sorted in the order that the cells should be traversed in order to get the avatar from 
		 * its current position to the destination position.
		 * 
		 * @param	point
		 */
		public function createPathToGridLocation(destPoint:Point):void
		{
			movePath = new Vector.<Point>();

			var grid:Array = gameEngine.worldGroup.currentSetting.collisionGrid;
			var currPoint:Point = getCurrGridLocation();
			var workingPoint:Point = getCurrGridLocation();
			
			//keep trying until you get there!
			//while (workingPoint.x != destPoint.x && workingPoint.y != destPoint.y)
			//{
				//if ()
			//}
			
			//reverse the vector so that I can just pop to get the next in the updatePosition function
			movePath.reverse();
		}

		public function getCurrGridLocation():Point
		{
			return new Point(Math.floor(this.locX / gameEngine.worldGroup.currentSetting.cellWidth), Math.floor((this.locY - gameEngine.worldGroup.currentSetting.horizonHeight + this.clip.height/2) / gameEngine.worldGroup.currentSetting.cellHeight));
		}
		
		/**
		 * setLocation 
		 * @param	x
		 * @param	y
		 */
		public function setLocation(x:Number, y:Number):void
		{			
			this.locX = x;
			this.locY = y;
			
			this.clip.x = x;
			this.clip.y = y;	

			
			this.rect.x = x - this.clip.width/2;
			this.rect.y = y - this.clip.height/2;	
		}
		
		public function gotoAndPlay(anim:String):void
		{
			this.clip.gotoAndPlay(anim);
		}

		public function updateAnimation():void
		{
			if (this.state == Avatar.WALKING && currentAnimation != "walking")
			{
				this.clip.gotoAndPlay("walking");
				currentAnimation = "walking";
			}
			else if (this.state == Avatar.STANDING && currentAnimation != "idle")
			{
				this.clip.gotoAndPlay("idle");
				currentAnimation = "idle";
			}
		}
		
		/**
		 * This function checks to see if a character who is walking (the 'walker' -- the
		 * parameter passed in) ends up standing on top of someone who is standing (the 'this'
		 * object). Returns false if not, true if their toes are being stepped on.
		 * @param	walker the avatar who is doing the walking.  By the time this function is
		 * called, we assume that we've already done a check that this avatar is in a walking state.
		 * @return True if there is overlap.  False if not.
		 */
		public function avatarIsBeingWalkedOn(walker:Avatar):Boolean {
			var distance:Number =  Math.sqrt(Math.pow(walker.locX - this.locX, 2) + Math.pow(walker.locY - this.locY, 2));
			
			// if walker and stander are close (within BUMPING_DISTANCE), AND the walker HASN'T bumped the stander recently.
			if (distance <= BUMPING_DISTANCE && recentlyBumped[walker.characterName.toLowerCase()] != "true") {

				//Play the reaction animation, and note that this walker has bumped into this stander.
				this.clip.gotoAndPlay("punchReaction");
				this.recentlyBumped[walker.characterName.toLowerCase()] = "true";
			}
			else if (distance > BUMPING_DISTANCE) {
				//The walker has gotten pretty far away -- make it so that they can bump again in the future.
				this.recentlyBumped[walker.characterName.toLowerCase()] = "false";
			}
			
			return true;
		}
		
		/**
		 * this function looks at the zone of the current avatar ('this'),
		 * and finds an acceptable place for them to move within it.  Once
		 * it finds it, it calls the 'move avatar to location' function to
		 * actually move the avatar to that spot.  This function was written
		 * with the intent for idle shuffling around behavior.
		 */
		public function findAndMoveAvatarToLocationWithinTheirZone():void {
			/*Debug.debug(this, "***************************************************");
			Debug.debug(this, "MOVING AVATAR TO NEW POSITION WITHIN THEIR ZONE");
			Debug.debug(this, "Character name: " + this.characterName);
			
			Debug.debug(this, "CURRENT ZONE left: " + currentZone.leftBoundary + " right: " + (currentZone.leftBoundary + currentZone.width));
			Debug.debug(this, "CURRENT ZONE top: " + currentZone.topBoundary + " bottom: " + (currentZone.topBoundary + currentZone.height));
			Debug.debug(this, "CURRENT ZONE WIDTH: " + currentZone.width + " HEIGHT " + currentZone.height);
			Debug.debug(this, "Character clip width: " + this.clip.width + " clip height: " + clip.height);
			Debug.debug(this, "Character clip width/2: " + (this.clip.width/2) + " clip height/2: " + (clip.height/2));*/
			var newX:Number;
			var newY:Number;
			var xBufferLeft:Number = 0; // should actually be based on the zone width probably
			var xBufferRight:Number = 0; // should actually be based on the zone width probably.
			
			
			//First, get the 'ideal' place for them to stand (this assumes that every bounding box is perfect
			//newX = Math.random() * (this.currentZone.width - clip.width/2 - xBufferRight) + this.currentZone.leftBoundary + (clip.width/2) + xBufferLeft;
			newX = this.currentZone.getRandomXWithinZone(this, xBufferLeft, xBufferRight);
			
			
			
			//newY = Math.random() * this.currentZone.height + this.currentZone.topBoundary;
			//newY -= this.clip.height / 2;
			newY = this.currentZone.getRandomYWithinZone(this);
			//Now, adjust the 'ideal' place for them to stand based on which character we are dealing with, since character's bounding boxes are all imperfect in different ways.
			newY = adjustYBasedOnCharacter(newY);
			
			/*
			if (Math.abs(newY - this.currentZone.topBoundary) < 20) { // they are too close to the top -- move them down a little.
				newY += 20;
			}
			else if (Math.abs(newY - (this.currentZone.topBoundary + this.currentZone.height)) < 20) {
				newY -= 20; // they are too close to the bottom -- move them up a little.
			}
			*/
			
			
			//Debug.debug(this, "findAndMoveAvatarToLocationWithinTheirZone() just as a sanity check, height of a zone is: " + this.currentZone.height);
			if (newX > locX) {
				this.facing = RIGHT; // they just walked to the right, have them face the right when they are done moving
				this.lookingAtTarget = "right";
				newX = adjustXBasedOnCharacter(newX, "right"); 
			}
			else {
				this.facing = LEFT; // otherwise, have them look to the left.
				this.lookingAtTarget = "left";
				newX = adjustXBasedOnCharacter(newX, "left"); 
			}
			
			
			//MASSIVE DEBUG TO SEE WHERE THEY ARE ABOUT TO WALK TO:
			
			//Debug.debug(this, "MOVING TO X: " + newX + " Y: " + newY);
			//Debug.debug(this, "***************************************************");
			
			this.moveToLocation(newX, newY);
		}
		
		public function onRollOver(e:MouseEvent):void {
			//Debug.debug(this, "you are hovering your mouse over an avatar who is named: " + this.characterName);
			//MonsterDebugger.trace(this, "Avatar onMouseOver");
			
			if (!this.visible) return;
			if (this.clip.alpha < 0.1) return;
			if (this.alpha < 0.1) return;
			
			gameEngine.hudGroup.characterNameplateGroup.removeAllElements();

			this.namePlate = null;
			
			//if (this.namePlate == null)
			//{			
				this.namePlate = new PromWeek.CharacterNameplate();
				this.namePlate.visible = false;
				this.namePlate.NameRichText.text = LineOfDialogue.toInitialCap(this.characterName);
				this.namePlate.x = this.clip.x;//this.locX;  // - this.clip.width / 2;
				this.namePlate.y = this.clip.y - this.clip.height / 2;
				
				
				
				//namePlate.width = 50;
				this.namePlate.figureWidth();
				this.namePlate.height = 100;
				this.namePlate.NamePlate.visible = true;
				this.namePlate.NameRichText.visible = true;
				
				//namePlate.y -= namePlate.height / 2; // let's try this out...
				
				var newNameplateLocBeforeTranslation:Point = new Point();
				newNameplateLocBeforeTranslation.x = this.namePlate.x
				newNameplateLocBeforeTranslation.y = this.namePlate.y;
				var newNameplateLoc:Point = Utility.translatePoint(newNameplateLocBeforeTranslation, gameEngine.worldGroup, gameEngine.hudGroup);
				
				//newNamePlate has the x and y of the nameplate based on the position of the avatar, but in hudGroup coordinates
				//instead of worldGroup coordinates.
				
				
				newNameplateLoc.x -= this.namePlate.width / 2;
				
				this.namePlate.x = newNameplateLoc.x;
				this.namePlate.y =  newNameplateLoc.y;
				this.namePlate.left = newNameplateLoc.x;
				this.namePlate.top = newNameplateLoc.y;
				
				
				
				//Debug.debug(this, "this is nameplayte x: " + namePlate.x + " and this is nameplate y: " + namePlate.y);
				
				//Debug.debug(this, "nameplate x: " + namePlate.x + " nameplate y: " + namePlate.y);
				
				gameEngine.hudGroup.characterNameplateGroup.addElement(namePlate);
				//this.namePlate.visible = false;
				//this.addElement(namePlate);	
			//}
			namePlate.fadeIn.play([namePlate]);
			//this.namePlate.visible = true;
		}
		
		public function onRollOut(e:MouseEvent):void {
			//Debug.debug(this, "onROLLOUT inside of AVATAR!!!!!!");
			//Debug.debug(this, "you are hovering your mouse over an avatar who is named: " + this.characterName);
			//MonsterDebugger.trace(this, "Avatar onMouseOver");
			
			if (this.namePlate == null) return;
			
			//gameEngine.hudGroup.characterNameplateGroup.removeAllElements();
			
			this.namePlate.visible = false;
			
			//this.namePlate = null;
		}
		
		public function onClick(e:MouseEvent = null, fromInitSelect:Boolean = false, fromRespSelect:Boolean = false, switchingChar:Boolean =false ):void
		{
			
			if (gameEngine.isFormingIntent) return;
			
			if (gameEngine.hudGroup.initSelectedCurrentlyFading) return;
			
			
			//Debug.debug(this, "you just clicked on: " + this.name);
			//MonsterDebugger.trace(this, "you just clicked on: " + this.name);
			
			//if (gameEngine.currentState == "Performance")
			//{
			//}
			
			//if (gameEngine.tutorialAvatarName != "")
			if (gameEngine.currentStory.istutorial)
			{
				if (!gameEngine.tutorialStopped)
				{
					if (gameEngine.tutorialAvatarName.toLowerCase() != this.characterName.toLowerCase())
					{
						return;
					}
				}
			}
			
			//want to bail if the avatar is fading.
			if (this.IS_FADING_OUT) return
			//bail if we are not in interaction mode
			if (this.gameEngine.currentState != "Interaction") return;
			
			
			
			if (gameEngine.hudGroup.postSGSFDBEntry.visible)
			{
				gameEngine.hudGroup.postSGSFDBEntry.xClickedOn();
			}
		
			
			if (!VisibilityManager.getInstance().useOldInterface)
			{
				if (!fromInitSelect && !fromRespSelect)
				{
					if (gameEngine.primaryAvatarSelection != null)
					{
						if (gameEngine.secondaryAvatarSelection != null)
						{
							if (this.characterName.toLowerCase() != gameEngine.primaryAvatarSelection.toLowerCase())
							{
								// a respnder had already been selected and now we are puicking a new one (from clicking on the actual avatar)
								gameEngine.secondaryAvatarSelection = null;
								
								// this means we want to update the NEW_responderCharFace
								gameEngine.hudGroup.initiatorSelectedComponent.respSelectGroup.selectCharFaceByName(this.characterName);
								//gameEngine.hudGroup.initiatorSelectedComponent.drawThoughtBubble(null, true, characterName);
								gameEngine.hudGroup.initiatorSelectedComponent.respCharFaceClickedEvent(null, characterName);
							}
						}
						else
						{
							if (this.characterName.toLowerCase() != gameEngine.primaryAvatarSelection.toLowerCase())
							{
								//we hadn't selected a responder yet, and now are by clicking on their avatar
								
								// this means we want to update the NEW_responderCharFace
								gameEngine.hudGroup.initiatorSelectedComponent.respSelectGroup.selectCharFaceByName(this.characterName);
								//gameEngine.hudGroup.initiatorSelectedComponent.drawThoughtBubble(null, true, characterName);
								gameEngine.hudGroup.initiatorSelectedComponent.respCharFaceClickedEvent(null, characterName);
							}
						}
					}
					else
					{
						// this means we want to update the NEW_initiatorCharFace
						gameEngine.hudGroup.initSelectGroup.selectCharFaceByName(this.characterName);
						
						gameEngine.hudGroup.initiatorSelectedComponent.populateInitiatorSelectedComponent(null, this.characterName,switchingChar);
						gameEngine.hudGroup.selectInitiatorGroup.visible = false;
						gameEngine.hudGroup.initiatorSelectedComponent.visible = true;
						
						gameEngine.primaryAvatarSelection = null;
						gameEngine.secondaryAvatarSelection = null;
					}
				}
				else
				{
					if (fromInitSelect)
					{
						//this means we have gotten this event from the new UI
						gameEngine.hudGroup.initiatorSelectedComponent.populateInitiatorSelectedComponent(null,this.characterName);
						
						if (gameEngine.hudGroup.initSelectGroup.currentlySelected != "")
						{
							if (gameEngine.secondaryAvatarSelection != null)
							{
								gameEngine.secondaryAvatarSelection = null;
								gameEngine.worldGroup.deslectSecondaryAvatar();
							}
							//this means we are switching our current initiator
							gameEngine.primaryAvatarSelection = null;
						}
						
						gameEngine.hudGroup.selectInitiatorGroup.visible = false;
						gameEngine.hudGroup.responderPreResponseThoughtBubble.visible = false;
						gameEngine.hudGroup.initiatorSelectedComponent.visible = true;
					}
					if (fromRespSelect)
					{
						//this means we have gotten this event from the new UI
						//gameEngine.hudGroup.initiatorSelectedComponent.populateInitiatorSelectedComponent(null,this.characterName);
						
						if (gameEngine.hudGroup.initiatorSelectedComponent.respSelectGroup.currentlySelected != "")
						{
							//this means we are switching our current initiator
							gameEngine.secondaryAvatarSelection = null;
						}
						
						//gameEngine.hudGroup.initiatorSelectedComponent.initiatorThoughtBubble.visible = true;
					}
				}
			}
			
			
			
			//var characterName:String = this.characterName;
			//Debug.debug(this, "clicked on avatar, coordinates in 'global' mode I guess?: " + e.stageX + " Y: " + e.stageY);
			//Debug.debug(this, "onClick() for avatar " + this.characterName + " " + this);

			
			//for pan dragging: set the worldGroup's last global click coordinates
			if (e != null)
			{
				gameEngine.worldGroup._lastGlobalCoords = new Point(e.stageX, e.stageY)
			}
		
			if (gameEngine.primaryAvatarSelection == null)
			{
				gameEngine.primaryAvatarSelection = characterName;

				gameEngine.hudGroup.megaUI.currentPrimaryCharacter = cif.cast.getCharByName(characterName);

				//gameEngine.hudGroup.initiatorSelectedComponent.populateInitiatorSelectedComponent(null,characterName,switchingChar);
				
				if (gameEngine.hudGroup.megaUI.megaUIExpanded)
				{
					gameEngine.hudGroup.megaUI.setToSingleCharacterView("initiator");
					gameEngine.hudGroup.megaUI.updateSingleCharacterToggleButtons();
					gameEngine.hudGroup.megaUI.characterFilterGroup.visible = true;
				}
				if (gameEngine.hudGroup.megaUI.megaUIExpanded)
				{
					gameEngine.hudGroup.megaUI.initiatorCharButton.selected = true;
				}
				else
				{
					gameEngine.hudGroup.megaUI.initiatorCharButton.selected = false;
				}
				gameEngine.hudGroup.megaUI.responderCharButton.selected = false;
				gameEngine.hudGroup.megaUI.initiatorCharButton.visible = true;
				gameEngine.hudGroup.megaUI.socialExchangeButton.selected = false;
				gameEngine.hudGroup.megaUI.setButtonsToAppropriateEnabledState();
				gameEngine.hudGroup.megaUI.populateFilterButtons();
				
				/*if (gameEngine.charInfoUIMode)
				{
					gameEngine.hudGroup.charInfoUI.currentPrimaryCharacter = CiFSingleton.getInstance().cast.getCharByName(this.characterName);
					
					gameEngine.hudGroup.charInfoUI.single = true;
					gameEngine.hudGroup.charInfoUI.visible = true;
				}*/
				gameEngine.currentNetworkSelection = "clear";
				
				gameEngine.worldGroup.primarySelectionCircle.botGradient.color = 0x00FF00;
				gameEngine.worldGroup.primarySelectionCircle.strokeColor.color = 0x02E302;
				gameEngine.worldGroup.primarySelectionCircle.strokeColor.weight = 5;
				gameEngine.worldGroup.primarySelectionCircle.fillColor.alpha = 0.9;
				gameEngine.worldGroup.primarySelectionCircle.visible = true;
				
			}
			else if ((gameEngine.secondaryAvatarSelection == null && gameEngine.primaryAvatarSelection != characterName) || 
					(gameEngine.secondaryAvatarSelection != null && gameEngine.secondaryAvatarSelection != characterName && gameEngine.secondaryAvatarSelection != null && gameEngine.primaryAvatarSelection != characterName))
			{
				
				//secondary avatar is selected and is neither the primary and the secondary is a new secondary selection
				gameEngine.secondaryAvatarSelection = characterName;
				gameEngine.hudGroup.megaUI.currentSecondaryCharacter = cif.cast.getCharByName(characterName);
				gameEngine.hudGroup.megaUI._setToRelationshipState = true;
				if (gameEngine.hudGroup.megaUI.megaUIExpanded)
				{
					gameEngine.hudGroup.megaUI.setToRelationshipState();
					gameEngine.hudGroup.megaUI.updateSingleCharacterToggleButtons();
				}
				
				if (gameEngine.hudGroup.megaUI.megaUIExpanded)
				{
					gameEngine.hudGroup.megaUI.responderCharButton.selected = true;
				}
				else
				{
					gameEngine.hudGroup.megaUI.responderCharButton.selected = false;
				}
				
				gameEngine.hudGroup.megaUI.initiatorCharButton.selected = false;
				gameEngine.hudGroup.megaUI.socialExchangeButton.selected = false;
				gameEngine.hudGroup.megaUI.responderCharButton.visible = true;
				gameEngine.hudGroup.megaUI.setButtonsToAppropriateEnabledState();
				gameEngine.hudGroup.megaUI.populateFilterButtons();
				
				gameEngine.resetSocialGameInfoWindowAndSelections();
				gameEngine.hudGroup.megaUI.socialGameButtonGroup.visible = false;
				
/*				if (gameEngine.charInfoUIMode)
				{
					gameEngine.hudGroup.charInfoUI.currentSecondaryCharacter = CiFSingleton.getInstance().cast.getCharByName(this.characterName);
					gameEngine.hudGroup.charInfoUI.double = true;
				}*/
				
				gameEngine.worldGroup.secondarySelectionCircle.botGradient.color = 0xFCFF00;
				gameEngine.worldGroup.secondarySelectionCircle.strokeColor.color = 0xD9DC00;
				gameEngine.worldGroup.secondarySelectionCircle.strokeColor.weight = 5;
				gameEngine.worldGroup.secondarySelectionCircle.fillColor.alpha = 0.9;
				gameEngine.worldGroup.secondarySelectionCircle.visible = true;
				
				if (VisibilityManager.getInstance().useOldInterface)
				{
					gameEngine.hudGroup.socialGameButtonRing.updateSocialGameButtonText();
				}
				
				
				gameEngine.hudGroup.socialGameButtonRing.clearGlow();
				gameEngine.hudGroup.socialGameButtonRing.visible = true;
				//var char1:Character = CiFSingleton.getInstance().cast.getCharByName(gameEngine.primaryAvatarSelection);
				//var total:Number = 0;
				//var counter:Number = 0;
				//for (var i:int = 0; i < char1.prospectiveMemory.intentScoreCache.length; i++)
				//{
					//for (var j:int = 0; j < char1.prospectiveMemory.intentScoreCache[i].length; j++)
					//{
						//if (char1.prospectiveMemory.intentScoreCache[i][j] != ProspectiveMemory.DEFAULT_INTENT_SCORE)
						//{
							//Debug.debug(this, char1.characterName + "'s intent to " + Predicate.getIntentNameByNumber(j) + " with " + CiFSingleton.getInstance().cast.getCharByID(i).characterName + ": " + char1.prospectiveMemory.intentScoreCache[i][j]);
							//total += char1.prospectiveMemory.intentScoreCache[i][j];
							//counter++;
						//}
					//}
				//}
				
				
				//gameEngine.hudGroup.createOpinionLines();
				//here is where we'd want to build a list of buttons and display them.
				//displaySocialGames(secondarySelection,topCharacterVolitions[primarySelection]);
			}else if (gameEngine.secondaryAvatarSelection && gameEngine.primaryAvatarSelection == characterName) {
				//the primary selection was selected again when two were selected
				gameEngine.hudGroup.megaUI.initiatorCharButton.selected = true;
				gameEngine.hudGroup.megaUI.responderCharButton.selected = false;
				gameEngine.hudGroup.megaUI.setButtonsToAppropriateEnabledState();
				gameEngine.hudGroup.megaUI.populateFilterButtons();
				gameEngine.resetSocialGameInfoWindowAndSelections();
				
				if(gameEngine.hudGroup.megaUI.relationshipToggleButton.selected)
					gameEngine.hudGroup.megaUI.setToRelationshipState();
				else
					gameEngine.hudGroup.megaUI.setToSingleCharacterView("initiator");
				
			}else if (gameEngine.secondaryAvatarSelection && gameEngine.secondaryAvatarSelection == characterName) {
				//the secondary avatar was reselected
				gameEngine.hudGroup.megaUI.initiatorCharButton.selected = false;
				gameEngine.hudGroup.megaUI.responderCharButton.selected = true;
				gameEngine.hudGroup.megaUI.setButtonsToAppropriateEnabledState();
				gameEngine.hudGroup.megaUI.populateFilterButtons();
				gameEngine.resetSocialGameInfoWindowAndSelections();
				
				if(gameEngine.hudGroup.megaUI.relationshipToggleButton.selected)
					gameEngine.hudGroup.megaUI.setToRelationshipState();
				else
					gameEngine.hudGroup.megaUI.setToSingleCharacterView("responder");
			}
			//Check to see if they have been playing a lot of games with the story lead character!  If they have been, bring up a
			//"Did You Know!" window!
			if (gameEngine.useUseDifferentCharacterWarning)
			{
				if (statisticsManager.playedSeveralGamesWithoutIndirection && this.characterName.toLowerCase() == gameEngine.currentStory.storyLeadCharacter.toLowerCase()) {
					var mainCharacter:String = gameEngine.currentStory.storyLeadCharacter;
					Alert.yesLabel = "Duly noted";
					var alertText:String = "Hey there! We notice that you're exclusively using " + mainCharacter + " to play social games. Remember, you can have any two characters in the level play social games with each other -- and sometimes you have to, to solve difficult goals.";
				
					//gameEngine.hudGroup.customAlert.visible = true;
					gameEngine.hudGroup.customAlert.message.text = alertText;
					gameEngine.hudGroup.customAlert.title.text = "Try using someone else!";
					//var alertText2:String = "test test one two three.";
					//Alert.show(alertText2, "A Quick Check In", Alert.YES, this, onlyLeadCharUsedAlertHandler); 
				}
			}
			
		}
		
		/**
		 * This is a function that flips the 'is fading out' flag
		 * to true.  A character that is fading out will have an alpha value
		 * that graduallly goes to zero.  This is an experiment to see what
		 * it looks like as a way to keep characters from cluttering up the screen!
		 */
		public function startDisappearing():void {
			if(!this.IS_FADING_OUT){
				this.IS_FADING_OUT = true;
				SHOULD_BE_CHECKING_FOR_FADING = true;
			}
		}
		
		/**
		 * This is a function that flips the 'is fading out' flag
		 * to false.  A character that is fading out will have an alpha value
		 * that graduallly goes to zero.  This is an experiment to see what
		 * it looks like as a way to keep characters from cluttering up the screen!
		 */
		public function startReappearing():void {
			if(this.IS_FADING_OUT){
				this.IS_FADING_OUT = false;
				SHOULD_BE_CHECKING_FOR_FADING = true;
			}
		}
		
		/**
		 * Because all of the character's bounding boxes are imperfect, this helps to make sure that 
		 * depending on which character we are dealing with, we move them up or down accordingly.
		 * @param	oldY The original coordinate that they WOULD have wantd to stand in, if the bounding box was perfect
		 * @return the actual value of the y coordinate they want to stand in.
		 */
		public function adjustYBasedOnCharacter(oldY:Number):Number {
			switch(this.characterName.toLowerCase()) {
				case "edward":  return oldY + 27.3; break; // ugh, we need to check all of this garbage I guess.
				case "mave":  return oldY; break;
				case "doug":  return oldY + 11.7; break;
				case "jordan":  return oldY + 10.25; break;
				case "buzz":  return oldY; break;
				case "naomi":  return oldY + 2.55; break;
				case "lil":  return oldY + 15.15; break;
				case "nicholas":  return oldY; break;
				case "zack":  return oldY + 24.15; break;
				case "chloe":  return oldY; break;
				case "simon":  return oldY - 3.25; break;
				case "oswald":  return oldY; break;
				case "monica":  return oldY - 2; break;
				case "cassandra":  return oldY - 3.5; break;
				case "gunter":  return oldY + 15.2; break;
				case "lucas":  return oldY; break;
				case "kate":  return oldY - 4.25; break;
				case "phoebe":  return oldY - 1.1; break;
				default: 
					Debug.debug(this, "adjustYBasedOnCharacter() Unrecognized character name when computing a new Y!");
					return oldY; // just return what the old value of y was...
			}
		}
		
		/**
		 * Because all of the character's bounding boxes are imperfect, this helps to make sure that 
		 * depending on which character we are dealing with, we move them to the left or right accordingly
		 * We also must take into account the fact that they have weird bounding boxes that are uneven on the
		 * left and the right.  Unlike with the Y, where all we ever care about is the position of their feet,
		 * here we need to take both the left and right directions into account
		 * @param	oldX The original coordinate that they WOULD have wantd to stand in, if the bounding box was perfect
		 * @param direction either 'left' or 'right'; the direction that they are moving in.
		 * @return the actual value of the x coordinate they want to stand in.
		 */
		public function adjustXBasedOnCharacter(oldX:Number, direction:String):Number {
			var isLeft:Boolean = false;
			if (direction == "left") isLeft = true; // if ture they are walking to the left, else walking to the right.
			switch(this.characterName.toLowerCase()) {
				case "edward":  return (isLeft ? oldX - 4.95 : oldX); break;
				case "mave":  return (isLeft ? oldX + 6.85 : oldX + 4.3); break;
				case "doug":  return (isLeft ? oldX + 6.4 : oldX + 8.55); break;
				case "jordan":  return (isLeft ? oldX + 7.3 : oldX + 6.4); break;
				case "buzz":  return (isLeft ? oldX - 1.5 : oldX); break;
				case "naomi":  return (isLeft ? oldX - 1.5 : oldX); break;
				case "lil":  return (isLeft ? oldX + 5.05 : oldX + 11.4); break;
				case "nicholas":  return (isLeft ? oldX - 5.55 : oldX + 4.15); break;
				case "zack":  return (isLeft ? oldX + 3.25 : oldX + 3.35); break;
				case "chloe":  return (isLeft ? oldX + 6.3 : oldX + 5); break;
				case "simon":  return (isLeft ? oldX : oldX ); break;
				case "oswald":  return (isLeft ? oldX : oldX); break;
				case "monica":  return (isLeft ? oldX : oldX); break;
				case "cassandra":  return (isLeft ? oldX + 2.75 : oldX + 2.7); break;
				
				case "gunter":  return (isLeft ? oldX + 1: oldX + + 1); break;
				case "lucas":  return (isLeft ? oldX + 5 : oldX + 7); break;
				case "kate":  return (isLeft ? oldX - 3.15: oldX - 4.1); break;
				case "phoebe":  return (isLeft ? oldX + 0.8 : oldX); break;
				default: 
					Debug.debug(this, "adjustXBasedOnCharacter() Unrecognized character name when computing a new X!");
					return oldX;
			}
		}
		
		/**
		 * Simply turns the appropriate flag off so that the alert doesn't show up again.
		 */
		public function onlyLeadCharUsedAlertHandler():void {
			statisticsManager.playedSeveralGamesWithoutIndirection = false;
		}
		
		/**
		 * This function handles the teleportation of an avatar.
		 * It checks to see where the camera is currently looking, and checks to see if the avatar
		 * is standing to the left or to the right (it does not care about y values...) of the camera.
		 * It will then attempt to teleport them just to the edge of the camera's viewport, so that they will
		 * be able to walk 'on screen' in the blink of an eye!
		 * 
		 * This is meant to be called before a performance begins, and assumes that we have already verified that
		 * we DO in fact want to do a teleport.
		 */
		public function handleTeleport(camera:Camera, cameraX:Number, cameraY:Number):void {
			//Maybe now I am thinking I am giving too much power to the width of the viewable world.
			//I.E. maybe I want to cut the width of the viewable world in HALF for my calculations.
			var halfOfViewableWorld:Number = camera.getWidthOfViewableWorld() / 2;
			
			
			if (this.locX > (cameraX + halfOfViewableWorld)) { // avatar is too far to the right
				//Make the avatar be just on the very edge of the camera, maybe?
				//Debug.debug(this, "Attempting to make avatar appear on the right side of the camera");
				//Debug.debug(this, "avatar x is: " + locX + " camera x is: " + cameraX + "cameraX plus 1/2 viewable world is: " + (cameraX + halfOfViewableWorld));
				//this.locX = cameraX + camera.getWidthOfViewableWorld();
				this.locX = cameraX + halfOfViewableWorld;
			}
			else if (this.locX < (cameraX - halfOfViewableWorld)) { // avatar is too far to the left.
				//Debug.debug(this, "Attempting to make avatar appear on the left side of the camera");
				//Debug.debug(this, "avatar x is: " + locX + " camera x is: " + cameraX + " cameraX inus 1/2 viewable worldis: " + (cameraX - halfOfViewableWorld));
				
				
				this.locX = cameraX - halfOfViewableWorld;
				//this.locX = cameraX;
			}
		}
		
		/**
		 * Returns true if the input string belongs to a character in the cif cast.  False if otherwise.
		 * @param	potentialCharacterName the string that we are checking to see if it belongs to a character or not.
		 */
		public static function isStringACharacterName(potentialCharacterName:String):Boolean {
			potentialCharacterName = potentialCharacterName.toLowerCase();
			switch (potentialCharacterName) {
				case "chloe":
				case "zack":							
				case "doug":
				case "oswald":
				case "simon":
				case "monica":
				case "edward":
				case "lil":
				case "naomi":
				case "kate":
				case "nicholas":
				case "lucas":
				case "phoebe":
				case "cassandra":
				case "mave":
				case "gunter":
				case "buzz":
				case "jordan": return true;
				default: return false;
			}
		}
		
		public function get state():int {
			return _state;
		}
		
		public function set state(val:int):void {
			if (this.characterName.toLowerCase() == "buzz") {
				if (_state == 2 && val == 3) {
					Debug.debug(this, "changing buzz's animation state from standing to walking...");
				}
				if (_state == 3 && val == 2) {
					Debug.debug(this, "changing buzz's animation state from walking to standing");
				}
				
			}
			_state = val;
		}
		
	}

}