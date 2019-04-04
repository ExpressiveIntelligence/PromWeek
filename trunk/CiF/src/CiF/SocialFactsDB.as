package CiF 
{
	import flash.geom.Vector3D;
	import flashx.textLayout.utils.CharacterUtil;
	import mx.controls.ProgressBarDirection;
	/**
	 * General Documentation!
	 * 
	 * TODO: run triggers functionality
	 * TODO: lookup functions for all context types
	 * TODO: clean up functions from old SFDB conception
	 * TODO: general documentation
	 */
	public final class SocialFactsDB
	{	
		public static const CAT_NEGATIVE:Number = 0
		public static const CAT_POSITIVE:Number = 1
		public static const CAT_LAME:Number = 2;
		
		
		public static const CAT_FLIRT:Number = 3 //this category is for romantic acts where whether it was accepted or rejected doesn't matter
		
		public static const LAST_CATEGORY_COUNT:Number = 3
		public static const FIRST_DIRECTED_LABEL:Number = 4
		
		public static const COOL:Number = 4
		public static const LAME:Number = 5 //!
		public static const ROMANTIC:Number = 6 //!
		public static const FAILED_ROMANCE:Number = 7 //!
		public static const GROSS:Number = 8
		public static const FUNNY:Number = 9
		public static const BAD_ASS:Number = 10
		public static const MEAN:Number = 11 //!
		public static const NICE:Number = 12 //!
		public static const TABOO:Number = 13
		public static const RUDE:Number = 14
		public static const EMBARRASSING:Number = 15
		public static const MISUNDERSTOOD:Number = 16
		
		public static const FIRST_STORY_SEQUENCE:Number = 17
		
		public static const SS1_ACT1:Number = 17
		public static const SS1_ACT2:Number = 18
		public static const SS1_ACT3:Number = 19
		public static const SS1_ACT4:Number = 20
		
		public static const SS2_ACT1:Number = 21
		public static const SS2_ACT2:Number = 22
		public static const SS2_ACT3:Number = 23
		public static const SS2_ACT4:Number = 24

		public static const SS3_ACT1:Number = 25
		public static const SS3_ACT2:Number = 26
		public static const SS3_ACT3:Number = 27
		public static const SS3_ACT4:Number = 28
		
		public static const SS4_ACT1:Number = 29
		public static const SS4_ACT2:Number = 30
		public static const SS4_ACT3:Number = 31
		public static const SS4_ACT4:Number = 32
		
		public static const SS5_ACT1:Number = 33
		public static const SS5_ACT2:Number = 34
		public static const SS5_ACT3:Number = 35
		public static const SS5_ACT4:Number = 36
		
		public static const SS6_ACT1:Number = 37
		public static const SS6_ACT2:Number = 38
		public static const SS6_ACT3:Number = 39
		public static const SS6_ACT4:Number = 40
		
		public static const SS7_ACT1:Number = 41
		public static const SS7_ACT2:Number = 42
		public static const SS7_ACT3:Number = 43
		public static const SS7_ACT4:Number = 44
		
		public static const SS8_ACT1:Number = 45
		public static const SS8_ACT2:Number = 46
		public static const SS8_ACT3:Number = 47
		public static const SS8_ACT4:Number = 48
		public static const SS8_ACT5:Number = 49
		
		public static const SS9_ACT1:Number = 50
		public static const SS9_ACT2:Number = 51
		public static const SS9_ACT3:Number = 52
		public static const SS9_ACT4:Number = 53
		
		public static const SS10_ACT1:Number = 54
		public static const SS10_ACT2:Number = 55
		public static const SS10_ACT3:Number = 56
		public static const SS10_ACT4:Number = 57
		
		public static const LABEL_COUNT:Number = 58
		
		//the value of a predicate not being found in a change rule search
		public static const PREDICATE_NOT_FOUND:int = -99999;
		
        public static const CATEGORIES:Object = new Object()
        // This block is run once when the class is first accessed
        {
            CATEGORIES[SocialFactsDB.CAT_POSITIVE] = new Array(SocialFactsDB.COOL, SocialFactsDB.ROMANTIC, SocialFactsDB.FUNNY, SocialFactsDB.BAD_ASS, SocialFactsDB.NICE);
            CATEGORIES[SocialFactsDB.CAT_NEGATIVE] = new Array(SocialFactsDB.MEAN, SocialFactsDB.TABOO, SocialFactsDB.RUDE); // Note: Aaron removed gross from this list since well-meaning characters often do gross things unintentionally, so it's not always fair to tar them with a cat: negative action.
            CATEGORIES[SocialFactsDB.CAT_LAME] = new Array(SocialFactsDB.EMBARRASSING, SocialFactsDB.LAME);
            CATEGORIES[SocialFactsDB.CAT_FLIRT] = new Array(SocialFactsDB.ROMANTIC,SocialFactsDB.FAILED_ROMANCE);
        }
		
		
/*		public static const DISAGREEMENT:Number = 14;
		public static const HARASSMENT:Number = 15;*/
		
		
		private static var _instance:SocialFactsDB = new SocialFactsDB();
		
		/**
		 * Contexts of SFDB entries. Can be SocialGameContext, TriggerContext
		 * or StatusContext.
		 */
		public var contexts:Vector.<SFDBContext>;
		/**
		 * Triggers to run over the SFDB after every social game is played.
		 */
		public var triggers:Vector.<Trigger>;
		public var triggersAllChars:Vector.<Trigger>;
		public var storyTriggers:Vector.<Trigger>;

		public static function getInstance():SocialFactsDB {
			return _instance;
		}
		
		public function SocialFactsDB() {
			if (_instance != null) {
				throw new Error("SocialFactsDB can only be accessed through SocialFactsDB.getInstance()");
			}
			this.contexts = new Vector.<SFDBContext>();
			this.triggers = new Vector.<Trigger>();
			this.triggersAllChars = new Vector.<Trigger>();
			this.storyTriggers = new Vector.<Trigger>();
		}
		
		
		public function getContextsAtTime(time:Number):Vector.<SFDBContext> {
			var contextsToReturn:Vector.<SFDBContext> = new Vector.<SFDBContext>();
			var context:SFDBContext
			for (var i:int = 0; i < this.contexts.length; i++ )
			{
				context = this.contexts[i];
				if (context.getTime() == time)
				{
					contextsToReturn.push(context);
				}
				else if (context.getTime() < time)
				{
					return contextsToReturn
				}
			}
			return contextsToReturn;
		}	
		
		
		
		public function getTriggerContextsAtTime(time:Number):Vector.<TriggerContext>
		{
			var triggersToReturn:Vector.<TriggerContext> = new Vector.<TriggerContext>();
			var context:SFDBContext
			for (var i:int = 0; i < this.contexts.length; i++ )
			{
				context = this.contexts[i];
				if (context.getTime() == time)
				{
					if (context.isTrigger())
					{
						triggersToReturn.push(context as TriggerContext);
					}
				}
				else if (context.getTime() < time)
				{
					return triggersToReturn;
				}
			}
			return triggersToReturn;
		}
		
		
		public function getStatusContextsAtTime(time:Number):Vector.<StatusContext>
		{
			var statussToReturn:Vector.<StatusContext> = new Vector.<StatusContext>();
			var context:SFDBContext
			for (var i:int = 0; i < this.contexts.length; i++ )
			{
				context = this.contexts[i];
				if (context.getTime() == time)
				{
					if (context.isStatus())
					{
						statussToReturn.push(context as StatusContext);
					}
				}
				else if (context.getTime() < time)
				{
					return statussToReturn;
				}
			}
			return statussToReturn;
		}
		
		public function getSocialGameContextsAtTime(time:Number):Vector.<SocialGameContext>
		{
			var sgcsToReturn:Vector.<SocialGameContext> = new Vector.<SocialGameContext>();
			var context:SFDBContext
			for (var i:int = 0; i < this.contexts.length; i++ )
			{
				context = this.contexts[i];
				if (context.getTime() == time)
				{
					if (context.isSocialGame())
					{
						sgcsToReturn.push(context as SocialGameContext);
					}
				}
				else if (context.getTime() < time)
				{
					return sgcsToReturn;
				}
			}
			return sgcsToReturn;
		}
		
		public function getTriggerByID(id:int):Trigger
		{
			for each (var trigger:Trigger in this.triggers)
			{
				if (trigger.id == id)
				{
					return trigger;
				}
			}
			return null;
		}
		
		public static function getLabelByName(name:String):Number 
		{
			if (name)
			{
				switch(name.toLowerCase()) 
				{
					case "cool":
						return SocialFactsDB.COOL;
					case "lame":
						return SocialFactsDB.LAME;
					case "romantic":
						return SocialFactsDB.ROMANTIC;
					case "failed romance":
						return SocialFactsDB.FAILED_ROMANCE;
					case "gross":
						return SocialFactsDB.GROSS;
					case "funny":
						return SocialFactsDB.FUNNY;					
					case "bad ass":
						return SocialFactsDB.BAD_ASS;
					case "mean":
						return SocialFactsDB.MEAN;
					case "nice":
						return SocialFactsDB.NICE;
					case "taboo":
						return SocialFactsDB.TABOO;
					case "rude":
						return SocialFactsDB.RUDE;
					case "embarrassing":
						return SocialFactsDB.EMBARRASSING;
					case "misunderstood":
						return SocialFactsDB.MISUNDERSTOOD;
					case "cat: negative":
						return SocialFactsDB.CAT_NEGATIVE;
					case "cat: positive":
						return SocialFactsDB.CAT_POSITIVE; 
					case "cat: lame":
						return SocialFactsDB.CAT_LAME; 
					case "cat: flirt":
						return SocialFactsDB.CAT_FLIRT; 
					case "ss1_act1":
						return SocialFactsDB.SS1_ACT1;
					case "ss1_act2":
						return SocialFactsDB.SS1_ACT2;
					case "ss1_act3":
						return SocialFactsDB.SS1_ACT3;
					case "ss1_act4":
						return SocialFactsDB.SS1_ACT4;
						
					case "ss2_act1":
						return SocialFactsDB.SS2_ACT1;
					case "ss2_act2":
						return SocialFactsDB.SS2_ACT2;
					case "ss2_act3":
						return SocialFactsDB.SS2_ACT3;
					case "ss2_act4":
						return SocialFactsDB.SS2_ACT4;
						
					case "ss3_act1":
						return SocialFactsDB.SS3_ACT1;
					case "ss3_act2":
						return SocialFactsDB.SS3_ACT2;
					case "ss3_act3":
						return SocialFactsDB.SS3_ACT3;
					case "ss3_act4":
						return SocialFactsDB.SS3_ACT4;
						
					case "ss4_act1":
						return SocialFactsDB.SS4_ACT1;
					case "ss4_act2":
						return SocialFactsDB.SS4_ACT2;
					case "ss4_act3":
						return SocialFactsDB.SS4_ACT3;
					case "ss4_act4":
						return SocialFactsDB.SS4_ACT4;
						
					case "ss5_act1":
						return SocialFactsDB.SS5_ACT1;
					case "ss5_act2":
						return SocialFactsDB.SS5_ACT2;
					case "ss5_act3":
						return SocialFactsDB.SS5_ACT3;
					case "ss5_act4":
						return SocialFactsDB.SS5_ACT4;
						
					case "ss6_act1":
						return SocialFactsDB.SS6_ACT1;
					case "ss6_act2":
						return SocialFactsDB.SS6_ACT2;
					case "ss6_act3":
						return SocialFactsDB.SS6_ACT3;
					case "ss6_act4":
						return SocialFactsDB.SS6_ACT4;
						
					case "ss7_act1":
						return SocialFactsDB.SS7_ACT1;
					case "ss7_act2":
						return SocialFactsDB.SS7_ACT2;
					case "ss7_act3":
						return SocialFactsDB.SS7_ACT3;
					case "ss7_act4":
						return SocialFactsDB.SS7_ACT4;
						
					case "ss8_act1":
						return SocialFactsDB.SS8_ACT1;
					case "ss8_act2":
						return SocialFactsDB.SS8_ACT2;
					case "ss8_act3":
						return SocialFactsDB.SS8_ACT3;
					case "ss8_act4":
						return SocialFactsDB.SS8_ACT4;
					case "ss8_act5":
						return SocialFactsDB.SS8_ACT5;
						
					case "ss9_act1":
						return SocialFactsDB.SS9_ACT1;
					case "ss9_act2":
						return SocialFactsDB.SS9_ACT2;
					case "ss9_act3":
						return SocialFactsDB.SS9_ACT3;
					case "ss9_act4":
						return SocialFactsDB.SS9_ACT4;
						
					case "ss10_act1":
						return SocialFactsDB.SS10_ACT1;
					case "ss10_act2":
						return SocialFactsDB.SS10_ACT2;
					case "ss10_act3":
						return SocialFactsDB.SS10_ACT3;
					case "ss10_act4":
						return SocialFactsDB.SS10_ACT4;
					default:
						return -1;
				}
			}
			return -1;
		}
		
		public static function getLabelByNumber(n:Number):String {
			switch (n) {
				case SocialFactsDB.COOL:
					return "cool";
				case SocialFactsDB.LAME:
					return "lame";
				case SocialFactsDB.ROMANTIC:
					return "romantic";
				case SocialFactsDB.FAILED_ROMANCE:
					return "failed romance";
				case SocialFactsDB.GROSS:
					return "gross";
				case SocialFactsDB.FUNNY:
					return "funny";					
				case SocialFactsDB.BAD_ASS:
					return "bad ass";				
				case SocialFactsDB.MEAN:
					return "mean";
				case SocialFactsDB.NICE:
					return "nice";					
				case SocialFactsDB.TABOO:
					return "taboo";
				case SocialFactsDB.RUDE:
					return "rude";		
				case SocialFactsDB.EMBARRASSING:
					return "embarrassing";
				case SocialFactsDB.MISUNDERSTOOD:
					return "misunderstood";
				case SocialFactsDB.CAT_NEGATIVE:
					return "cat: negative";
				case SocialFactsDB.CAT_POSITIVE:
					return "cat: positive";
				case SocialFactsDB.CAT_FLIRT:
					return "cat: flirt";
				case SocialFactsDB.CAT_LAME:
					return "cat: lame";

				case SocialFactsDB.SS1_ACT1:
					return "ss1_act1";
				case SocialFactsDB.SS1_ACT2:
					return "ss1_act2";
				case SocialFactsDB.SS1_ACT3:
					return "ss1_act3";
				case SocialFactsDB.SS1_ACT4:
					return "ss1_act4";
					
				case SocialFactsDB.SS2_ACT1:
					return "ss2_act1";
				case SocialFactsDB.SS2_ACT2:
					return "ss2_act2";
				case SocialFactsDB.SS2_ACT3:
					return "ss2_act3";
				case SocialFactsDB.SS2_ACT4:
					return "ss2_act4";
					
				case SocialFactsDB.SS3_ACT1:
					return "ss3_act1";
				case SocialFactsDB.SS3_ACT2:
					return "ss3_act2";
				case SocialFactsDB.SS3_ACT3:
					return "ss3_act3";
				case SocialFactsDB.SS3_ACT4:
					return "ss3_act4";
					
				case SocialFactsDB.SS4_ACT1:
					return "ss4_act1";
				case SocialFactsDB.SS4_ACT2:
					return "ss4_act2";
				case SocialFactsDB.SS4_ACT3:
					return "ss4_act3";
				case SocialFactsDB.SS4_ACT4:
					return "ss4_act4";
					
				case SocialFactsDB.SS5_ACT1:
					return "ss5_act1";
				case SocialFactsDB.SS5_ACT2:
					return "ss5_act2";
				case SocialFactsDB.SS5_ACT3:
					return "ss5_act3";
				case SocialFactsDB.SS5_ACT4:
					return "ss5_act4";
					
				case SocialFactsDB.SS6_ACT1:
					return "ss6_act1";
				case SocialFactsDB.SS6_ACT2:
					return "ss6_act2";
				case SocialFactsDB.SS6_ACT3:
					return "ss6_act3";
				case SocialFactsDB.SS6_ACT4:
					return "ss6_act4";
					
				case SocialFactsDB.SS7_ACT1:
					return "ss7_act1";
				case SocialFactsDB.SS7_ACT2:
					return "ss7_act2";
				case SocialFactsDB.SS7_ACT3:
					return "ss7_act3";
				case SocialFactsDB.SS7_ACT4:
					return "ss7_act4";
					
				case SocialFactsDB.SS8_ACT1:
					return "ss8_act1";
				case SocialFactsDB.SS8_ACT2:
					return "ss8_act2";
				case SocialFactsDB.SS8_ACT3:
					return "ss8_act3";
				case SocialFactsDB.SS8_ACT4:
					return "ss8_act4";
				case SocialFactsDB.SS8_ACT5:
					return "ss8_act5";
					
				case SocialFactsDB.SS9_ACT1:
					return "ss9_act1";
				case SocialFactsDB.SS9_ACT2:
					return "ss9_act2";
				case SocialFactsDB.SS9_ACT3:
					return "ss9_act3";
				case SocialFactsDB.SS9_ACT4:
					return "ss9_act4";
					
				case SocialFactsDB.SS10_ACT1:
					return "ss10_act1";
				case SocialFactsDB.SS10_ACT2:
					return "ss10_act2";
				case SocialFactsDB.SS10_ACT3:
					return "ss10_act3";
				case SocialFactsDB.SS10_ACT4:
					return "ss10_act4";
				default:
					return "";
			}
		}
		
		
		/**
		 * Determines the predicate was true in any change in any SFDBContext within
		 * the time window specified in the predicate p.
		 * 
		 * @param	p	Predicate to check for.
		 * @param	x	Primary character.
		 * @param	y	Secondary character.
		 * @param	z	Tertiary character.
		 * @return	True if the predicate was found, false if not.
		 */
		public function isPredicateInHistory(p:Predicate, x:Character, y:Character, z:Character=null):Boolean {
			return (timeOfPredicateInHistory(p, x, y, z) != SocialFactsDB.PREDICATE_NOT_FOUND);
		}
		
		/**
		 * Returns the most recent time a predciate was true in social change associated with
		 * a SFDBContext.
		 * 
		 * @param	p	Predicate to check for.
		 * @param	x	Primary character.
		 * @param	y	Secondary character.
		 * @param	z	Tertiary character.
		 * @return	The time when the predciate was true if found. SocialFactsDB.PREDICATE_NOT_FOUND if not found.
		 */
		public function timeOfPredicateInHistory(p:Predicate, x:Character, y:Character, z:Character=null):int {
			var latestTimeInSFDB:int = this.getLatestContextTime();
			var window:int = (p.window > 0 && p.isSFDB && p.sfdbOrder < 1) ?  p.window : latestTimeInSFDB + 1;
			//time iterator
			var t:int = latestTimeInSFDB;
			var i:int = 0; //context vector iterator
			
			/*
			if(x && y && z){
				if (x.characterName.toLowerCase() == "buzz" && y.characterName.toLowerCase() == "nicholas" && z.characterName.toLowerCase() == "kate") {
					Debug.debug(this, "timeOfPredicateInHistory() Doin' my SFDB(0) tests some more -- Ben");
				}
			}
			*/
			
			//the context vector is sorted going in to this function
			for (; this.contexts[i].getTime() > latestTimeInSFDB - window; ++i) {
				if (this.contexts[i].isPredicateInChange(p, x, y, z))
					return this.contexts[i].getTime();
			}
			
			//if (p.evaluate(x, y, z))
			//{
				//if the predicate is true as far back as we wanna go, say it happened at that time
				//TODO: confirm that this isn't a horrible idea.
				//return (latestTimeInSFDB - window);
			//}
			
			if (p.sfdbOrder != 0)
			{
				if ((latestTimeInSFDB - window) <= 0)
				{
					var predForTest:Predicate = p.clone();
					predForTest.sfdbOrder = 0;
					//if we've run out of history to check, treat it like it was true at time 0.
					if (predForTest.evaluate(x, y, z))
					{
						return 0;
					}
				}
			}
			return SocialFactsDB.PREDICATE_NOT_FOUND; //predicate was not found in the window
		}
		
		public function sortDescendingTime(x:SFDBContext, y:SFDBContext):Number {
			return (y.getTime() - x.getTime());
		}
		
		/**
		 * Determines if the change denoted by a predicate is in an SFDB's
		 * social change in a time window that starts at current time and ends
		 * at current time - p.window.
		 * @param	p	The predicate denoted the social change to find.
		 * @return	The index of the first found SFDBContext with the matching 
		 * social state change or -1 if change was not found in the window.
		 */
		public function findPredicateInChange(p:Predicate):int {
			var lastContextTime:Number = this.contexts[this.contexts.length - 1].getTime();
			var i:int;
			var j:int;
			var r:Rule;
			var window:int = (p.window <= 0) ? lastContextTime : p.window;
			//trace( "findPredicateInChange(): window: " + window);
			//trace("predicate to find: " + p);
			for (i = this.contexts.length-1; i > -1 && lastContextTime - window <= this.contexts[i].getTime(); --i) {
				r = this.contexts[i].getChange();
				Debug.debug(this, "findPredicateInChange() context change: " + r.toString());
				for (j = r.predicates.length - 1; j >= 0; --j) {
					
					if (Predicate.equals(p, r.predicates[j])) {
						return i;
					}
					//trace("fail #" + i);
				}
			}
			return -1;
		}
		
		
		
		/**
		 * findLabelFromValues returns a vector of ints, i.e. matchingIndices by
		 * looking at all the socialgame or trigger contexts in the window, and returns the 
		 * indices of contexts that match the arguments label, firstCharacter, secondCharater.
		 * 
		 * @param	label			The SFDB label to locate.
		 * @param	firstCharacter	First character (from) slot.
		 * @param	secondCharacter	Second character (to) slot.
		 * @param	w				The window in SFDB time to look back for matches. A window 
		 * of 0 means the entire history is checked.
		 * @return	A vector containing the timestamp of the matching social 
		 * facts database context entries.
		 */
		public function findLabelFromValues(label:int, firstCharacter:Character=null, secondCharacter:Character = null, thirdCharacter:Character = null,  w:int = 0, pred:Predicate = null):Vector.<int> 
		{
			//Debug.debug(this, "findLabelFromValues: entering!");
			if (this.contexts.length < 1)
			{
				Debug.debug(this, "findLabelFromValues: exiting early!");
				return new Vector.<int>();
			}
			
			var lastContextTime:Number = this.getLatestContextTime();
			var i:int;
			var sgc:SocialGameContext;
			var sc:StatusContext;
			var tc:TriggerContext;
			var matchingIndexes:Vector.<int> = new Vector.<int>();
			var window:int = (w <= 0) ? lastContextTime : w;
			var labelMatches:Boolean = false;
			var firstMatches:Boolean = false;
			var secondMatches:Boolean = false;
			var thirdMatches:Boolean = false;
			
			var timeToHaltSearch:int;
			if (w <= 0) {
				timeToHaltSearch = this.getLowestContextTime()-1;
			}else {
				timeToHaltSearch = lastContextTime - window;
			}
			
			//Debug.debug(this, "findLabelFromValues() last context time: " + lastContextTime + " first context time: " + this.getLowestContextTime() + " timeToHaltSearch: " + timeToHaltSearch);
			
			
			//NOTE: this assumes that all entries are in order such that the most recent action is last in contexts
			//Debug.debug(this, "findLabelFromValue() incoming values: label: " + getLabelByNumber(label) + " first: " + ((firstCharacter)?firstCharacter.characterName:"null") + " second: " + ((secondCharacter)?secondCharacter.characterName:"null"));
			//for (i = this.contexts.length - 1; i > -1; --i) 
			//NOTE: the following for case assumes the contexts are in descending order by time
			for (i = 0; i < this.contexts.length; ++i) 
			{
				if ( (this.contexts[i].isSocialGame() || this.contexts[i].isTrigger()) && (timeToHaltSearch < this.contexts[i].getTime())) 
				{
					//Debug.debug(this, "findLabelFromValues() current context time: " + this.contexts[i].getTime());
					if(this.contexts[i].isSocialGame()) {
						sgc = this.contexts[i] as SocialGameContext;
						/*
						if (sgc.time == -51 && sgc.initiator.toLowerCase() == "nicholas" && sgc.responder.toLowerCase() == "kate") {
							Debug.debug(this, "testing SFDBwindow(0) for SFDBLabel predicates");
						}
						*/
						if(pred && pred.numTimesUniquelyTrueFlag)
						{
							//Call a strict version of this. Which requires a from because it is numTimesUniquelyTrue
							if (sgc.doesSFDBLabelMatchStrict(label, firstCharacter, secondCharacter, thirdCharacter, pred)) {
								matchingIndexes.push(sgc.getTime());
								//Debug.debug(this, "findLabelFromValues() pushing a context index on the matching indexes. sgc: " + sgc.toXMLString());
							}							
						}
						else if (!this.contexts[i].isJuice())
						{
							//The normal case
							if (sgc.doesSFDBLabelMatch(label, firstCharacter, secondCharacter, thirdCharacter, pred)) {
								matchingIndexes.push(sgc.getTime());
								//Debug.debug(this, "findLabelFromValues() pushing a context index on the matching indexes. sgc: " + sgc.toXMLString());
							}
						}
					}else if (this.contexts[i].isTrigger()) {
						tc = this.contexts[i] as TriggerContext;
						if (pred && pred.numTimesUniquelyTrueFlag)
						{
							if (tc.doesSFDBLabelMatchStrict(label, firstCharacter, secondCharacter, thirdCharacter, pred)) 
							{
								matchingIndexes.push(sgc.getTime());
							}
						}
						else
						{
							if (tc.doesSFDBLabelMatch(label, firstCharacter, secondCharacter, thirdCharacter, pred)) 
							{
								matchingIndexes.push(sgc.getTime());
							}							
						}
					}
				}
			}
			
			return matchingIndexes;
		}
		
		
		/**
		 * This function is used to deal with when we are seeing is a label is in a category.
		 * If predicateLabel is not a category, returns false if it doesn't match contextLabel: true otherwise.
		 * If predicateLabel is a category, it will loop through that category to see if contextLabel matches any in the category.
		 * 
		 * @param	contextLabel
		 * @param	predicateLabel
		 * @return
		 */
		public static function doesMatchLabelOrCategory(contextLabel:int, predicateLabel:int):Boolean
		{
			if (predicateLabel <= SocialFactsDB.LAST_CATEGORY_COUNT)
			{
				for each (var cat_label:Number in SocialFactsDB.CATEGORIES[predicateLabel])
				{
					if (cat_label == contextLabel)
					{
						return true;
					}
				}
				return false;
			}
			else if (contextLabel != predicateLabel)
			{
				return false;
			}
			return true;
		}
		
		
		public function getLatestSocialGameContext():SocialGameContext
		{
			var latestContextTime:int = -1000;// this.getLatestContextTime();
			
			//Debug.debug(this, "getLatestSocialGameContext() LatestContextTime: " + latestContextTime);
			
			var contextWithHighestTime:SocialGameContext;

			for each (var context:SFDBContext in this.contexts)
			{
				if (context.getTime() > latestContextTime && context.isSocialGame())
				{
					latestContextTime = context.getTime();
					contextWithHighestTime = context as SocialGameContext;
					//return context as SocialGameContext;
				}
			}
			
			return contextWithHighestTime;
		}
	
		public function getLatestTriggerContexts():Vector.<TriggerContext>
		{
			var latestContextTime:int = this.getLatestContextTime();
			
			var triggerContexts:Vector.<TriggerContext> = new Vector.<TriggerContext>;
			
			for each (var context:SFDBContext in this.contexts)
			{
				//Debug.debug(this, "Latest Context Time: " + latestContextTime + " ||||| This Context's Time: " + context.getTime() + " isTrigger: " + context.isTrigger() + " context: " + context.toXMLString());
				//Debug.debug(this,"FJKSLJVKLS");
				if (context.getTime() == latestContextTime && context.isTrigger())
				{
					triggerContexts.push(context as TriggerContext);
				}
			}
			
			return triggerContexts;
		}
		
		/**
		 * Returns the timestamp of the latest SFDB comtext in game time.
		 * 
		 * @return the time of the latest context time
		 */
		public function getLatestContextTime():Number
		{
			//since we sort after the initial SFDB loading process and after each context is added,
			//the highest context time will always be at the beginning of the vector.
			return this.contexts[0].getTime();
		}
		
		/**
		 * Returns the timestamp of the first context relative to game time. This value is
		 * likely to be negative due to authored backstory.
		 * 
		 * @return the time of the first context time
		 */
		public function getLowestContextTime():Number
		{
			//since we sort after the initial SFDB loading process and after each context is added,
			//the lowest context time will always be at the end of the vector.
			return this.contexts[this.contexts.length-1].getTime();
		}
		
		/**
		 * Returns the timestamp of the first context relative to game time. This value is
		 * likely to be negative due to authored backstory.
		 * 
		 * @return the time of the first context time
		 */
		public function getEarliestContextTime():Number {
			return this.getLowestContextTime();
		}
		
		/**
		 * findLabelFromPredicate takes in a predicate, and returns a vector of ints
		 * Makes use of findLabelFromValues to assign appropriate labels and values to predicate
		 * 
		 * @see findLabelFromValues
		 * @param	p
		 * @return
		 */
		public function findLabelFromPredicate(p:Predicate):Vector.<int> {
			var cast:Cast = Cast.getInstance();
			return this.findLabelFromValues(p.sfdbLabel, cast.getCharByName(p.primary), cast.getCharByName(p.secondary), cast.getCharByName(p.tertiary), p.window, p);
		}
		
		
		/**
		 * Returns the first social game context from this.contexts that occurred at time time.
		 * 
		 * @param	time
		 * @return
		 */
		public function getSocialGameContextAtTime(time:Number):SocialGameContext
		{
			for each (var context:SFDBContext in this.contexts)
			{
				if (context.isSocialGame())
				{
					if (context.getTime() == time)
					{
						return context as SocialGameContext;
					}
				}
			}
			return null
		}
		
		/**
		 * Runs all the triggers over the social facts database for each
		 * character. Meant to be called after platGame.
		 */
		public function runTriggers(cast:Vector.<Character> = null):void 
		{
			var cif:CiFSingleton = CiFSingleton.getInstance();
			var potentialCharacters:Vector.<Character> = (cast)?cast:cif.cast.characters;
			
			var firstChar:Character;
			var secondChar:Character;
			var thirdChar:Character;
			var trigger:Trigger;
			
			
			var changePred:Predicate;
			
			var towardChar:Character;
			var fromChar:Character;
			
			//Debug.debug(this, "runTriggers() about to run triggers.");
			//Debug.debug(this, "runTriggers() number of triggers is " + this.triggers.length);
			
			var triggersToApply:Vector.<Trigger> = new Vector.<Trigger>();
			var firstRoles:Vector.<Character> = new Vector.<Character>();
			var secondRoles:Vector.<Character> = new Vector.<Character>();
			var thirdRoles:Vector.<Character> = new Vector.<Character>();
			
			//run each trigger on every duple of characters or triple where needed by the trigger.
			for each (trigger in this.triggers) {
				if (trigger.useAllChars)
				{
					potentialCharacters = cif.cast.characters;
				}
				else
				{
					potentialCharacters = (cast)?cast:cif.cast.characters;
				}
				
				for each (firstChar in potentialCharacters) {
					for each(secondChar in potentialCharacters) {
						//don't evaluate a trigger with the same character in both roles
						if(firstChar.characterName != secondChar.characterName) {
							//run the trigger for each character triple if a third character is needed by the trigger.
							if (trigger.requiresThirdCharacter()) 
							{
								//Debug.debug(this, "runTriggers() trigger for 3 characters is being evaluated: " + firstChar.characterName + " " + secondChar.characterName + " with third to be determined"  );
								for each(thirdChar in potentialCharacters) 
								{
									//make sure that each role has a unique character
									//aleady checked that the first two characters were unique so check for third
									if (thirdChar != firstChar && thirdChar != secondChar) 
									{
										
										//if (trigger.referenceAsNaturalLanguage == "If someone is romantic to your date more than once, you are angry at them" && firstChar.characterName == "Zack" && secondChar.characterName == "Simon" && thirdChar.characterName == "Monica")
										//{
											//Debug.debug(this,"BREAK!");
										//}
										
										if (trigger.evaluateCondition(firstChar, secondChar, thirdChar)) 
										{
											//if (trigger.id == 10 && !trigger.useAllChars)
											//{
												//trace("------");
											//}
											
											
											//Debug.debug(this, "runTriggers() Trigger True: " + trigger.toString());
											//Debug.debug(this, "runTriggers() trigger for 3 characters was true and is being valuated: " + firstChar.characterName + " " + secondChar.characterName + " " + thirdChar.characterName + " " );
											//valuate the trigger

											triggersToApply.push(trigger);
											firstRoles.push(firstChar);
											secondRoles.push(secondChar);
											thirdRoles.push(thirdChar);
											
										}
									}
								}
							}
							else 
							{
								
								//only two characters are required
								//see if trigger's condition is true
								//Debug.debug(this, "runTriggers() Trigger True: " + trigger.toString());
								//Debug.debug(this, "runTriggers() trigger for 2 characters was true and is being valuated: " + firstChar.characterName + " " + secondChar.characterName + " " );
								if (trigger.evaluateCondition(firstChar, secondChar)) 
								{	
									//if (trigger.id == 10 && !trigger.useAllChars)
									//{
										//trace("------");
									//}
									
									
									                   
									triggersToApply.push(trigger);
									firstRoles.push(firstChar);
									secondRoles.push(secondChar);
									thirdRoles.push(null);
								}
							}
						}
					}
				}
			}
			
			//now that we have collected all the the triggers and characters involved, valuate them all
			
			// aPredHasValuated will be used to keep track of whether or not a triggerContext should be created
			// because it may be the case that the status was already the case, and thus a trigger context should not be created
			var aPredHasValuated:Boolean;
			for (var i:int = 0; i < triggersToApply.length; i++ )
			{
				trigger = triggersToApply[i];
				firstChar = firstRoles[i];
				secondChar = secondRoles[i];
				thirdChar = thirdRoles[i];
				
				
				aPredHasValuated = false;				
				// go through each change predicate and treat status that are already the case different than those that aren't
				//this is all part of making sure that we don't contantly display "cheating" every turn while someone is dating two characters
				for each (changePred in trigger.change.predicates)
				{
					
					//Debug.debug(this, cif.time + ": Trigger Change Pred: " + changePred.toString()+ " first: " + firstChar.characterName + " second: " + secondChar.characterName + " third: " + thirdChar.characterName);
					
					//figure out who the predicate should be applied to
					var primaryValue:String = changePred.getPrimaryValue();
					switch (primaryValue)
					{
						case "initiator":
							fromChar = firstChar;
							break;
						case "responder":
							fromChar = secondChar;
							break;
						case "other":
							fromChar = thirdChar;
							break;
						default:
							fromChar = cif.cast.getCharByName(primaryValue);
					}
					
					if (changePred.type == Predicate.STATUS)
					{
						towardChar = null;
						if (changePred.status >= Status.FIRST_DIRECTED_STATUS)
						{
							//figure out who the status should be direct towards
							var secondaryValue:String = changePred.getSecondaryValue();
							switch (secondaryValue)
							{
								case "initiator":
									towardChar = firstChar;
									break;
								case "responder":
									towardChar = secondChar;
									break;
								case "other":
									towardChar = thirdChar;
									break;
								default:
									towardChar = cif.cast.getCharByName(secondaryValue);
							}
						}

						
						if (fromChar.getStatus(changePred.status,towardChar))
						{
							//if we are here, then we know that the fromChar has the status
							if (changePred.negated)
							{
								//this deals with removing status, which warrants a new trigger context
								aPredHasValuated = true;
								//Debug.debug(this, cif.time + ": Negated Valuation: " + changePred.toString()+ " first: " + firstChar.characterName + " second: " + secondChar.characterName + " third: " + thirdChar.characterName);
								changePred.valuation(firstChar, secondChar, thirdChar);
							}
							else
							{
								//this is the case where rather than apply the status, we only reset its remaining duration. This is the
								//case that we do not want to create a new trigger context for.
								//Debug.debug(this, "Reset the duration of: " + Status.getStatusNameByNumber(changePred.status) + " for " + firstChar.characterName + " at time " + cif.time+ " first: " + firstChar.characterName + " second: " + secondChar.characterName + " third: " + thirdChar.characterName);
								fromChar.getStatus(changePred.status, towardChar).remainingDuration = Status.DEFAULT_INITIAL_DURATION;
							}
						}
						else if (!changePred.negated)
						{
							//this is the "normal case" where we simple apply the change predicate
							aPredHasValuated = true;
							//Debug.debug(this, cif.time + ": Normal Valuation: " + changePred.toString() + " first: " + firstChar.characterName + " second: " + secondChar.characterName + " third: " + thirdChar.characterName);
							changePred.valuation(firstChar, secondChar, thirdChar);
						}
						else
						{
							//Debug.debug(this, cif.time + ": Nothing Done with this: " + changePred.toString()+ " first: " + firstChar.characterName + " second: " + secondChar.characterName + " third: " + thirdChar.characterName);
						}
					}
					else
					{
						//this is the normal, non-status case
						aPredHasValuated = true;
						//Debug.debug(this, cif.time + ": Normal Valuation: " + changePred.toString()+ " first: " + firstChar.characterName + " second: " + secondChar.characterName + " third: " + thirdChar.characterName);
						changePred.valuation(firstChar, secondChar, thirdChar);
					}
				}
				//make a trigger context and put it in the SFDB 
				if (aPredHasValuated)
				{
					var tc1:TriggerContext = trigger.makeTriggerContext(cif.time, firstChar, secondChar,thirdChar);
					//Debug.debug(this, "runTriggers() Trigger: " + trigger.toString())
					//Debug.debug(this, "runTriggers() Context: " + tc1.toXML())
					this.addContext(tc1);
				}
			}
			//this.contexts.sort(sortDescendingTime);
			//Debug.debug(this, "runTriggers() finished running triggers.");
		}
		
		/**
		 * Adds a context to the SFDB then sorts the SFDB by descending time.
		 * @param	context	The SFDB context to be added to the SFDB.
		 */
		public function addContext(context:SFDBContext):void {
			this.contexts.push(context);
			this.contexts.sort(this.sortDescendingTime);
		}
		
		/**
		 * 
		 * @return boolean
		 */
		public function isEmpty():Boolean {
			return (this.contexts.length == 0);
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		
		/**
		 * 
		 * @return
		 */
/*		public function toString():String {
			var result:String = "";
			for (var i:int = 0; i < contexts.length; ++i) {
				result += contexts[i].toString();
				if (i != contexts.length - 1) result += "\n";
			}
			if (result.length == 0) {
				trace("Empty list");
			}
			return result;
		}*/
		
		
		/*public function clone(): SocialFactsDB {
			var sfdb:SocialFactsDB = new SocialFactsDB();
			for each(var sc:SFDBContext in this.contexts) {
				sfdb.contexts.push(sc.clone());
			}
			return sfdb;
		}*/
		
		public function toXMLString():String {
			var result:String = "<SFDB>\n";
			for (var i:int = 0; i < contexts.length; ++i) {
				
				if(contexts[i].isSocialGame() || contexts[i].isStatus() || contexts[i].isTrigger()) {
					result += contexts[i].toXMLString();
					result += "\n";
				}
			}
			result += "</SFDB>";
			//result += "<Triggers>";
			//for each( var t:Trigger in this.triggers) 
				//result += t.toXML().toXMLString();
			//result += "</Triggers>";
			return result;
		}
		
		public static function equals(x:SocialFactsDB, y:SocialFactsDB): Boolean {
			if (x.contexts.length != y.contexts.length) return false;
			for (var i:Number = 0; i < x.contexts.length; ++i) {
				if ((x.contexts[i], y.contexts[i])) return false;
			}
			return true;
		}
		
	}

}