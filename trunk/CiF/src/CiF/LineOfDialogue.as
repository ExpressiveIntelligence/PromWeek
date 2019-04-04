package CiF 
{
	/**
	 * 
	 * TODO: fill out header documentation
	 * TODO: make toString make sense
	 * TODO: SFDB locutions in createLocutionVectors().
	 */
	public class LineOfDialogue
	{
		
		/**
		 * The number in sequence this line of dialog is in it's instantition.
		 */
		public var lineNumber:Number = -1;
		/**
		 * The initiator's dialogue.
		 */
		public var initiatorLine:String = "";
		/**
		 * The responders's dialogue.
		 */
		public var responderLine:String = "";
		/**
		 * Other's dialogue.
		 */
		public var otherLine:String = "";
		/**
		 *  Though multiple people might talk at the same time, (e.g. initiator: "I love you" responder="gasp!" simultaneously)
		 *  it might be useful to keep track of the 'important' speaker at any given time stamp (in the example above, "I Love you"
		 *  is a more important line to the narrative of the exchange than the gasp, for example)
		 */
		public var primarySpeaker:String = "";
		/**
		 *  Initiator's body animation.
		 */
		public var initiatorBodyAnimation:String = "";
		/**
		 * Initiator's face animation.
		 */
		public var initiatorFaceAnimation:String = "";
		public var initiatorFaceState:String = "";
		/**
		 * Responders's body animation.
		 */
		public var responderBodyAnimation:String = "";
		/**
		 * Initiator's face animation.
		 */
		public var responderFaceAnimation:String = "";
		public var responderFaceState:String = "";
		/**
		 * Other's body animation.
		 */
		public var otherBodyAnimation:String = "";
		/**
		 * Other's face animation.
		 */
		public var otherFaceAnimation:String = "";
		public var otherFaceState:String = "";
		/**
		 * The performance time of the line of dialogue.
		 */
		public var time:Number = 0;
		/**
		 * A flag to mark whether the initiator's line of dialog is spoken aloud
		 * (isThought=false) or meant to be a thought bubble (isThought=true)
		 */
		public var initiatorIsThought:Boolean = false;
		/**
		 * A flag to mark whether the responder's line of dialog is spoken aloud
		 * (isThought=false) or meant to be a thought bubble (isThought=true)
		 */
		public var responderIsThought:Boolean = false;
		/**
		 * A flag to mark whether the other's line of dialog is spoken aloud
		 * (isThought=false) or meant to be a thought bubble (isThought=true)
		 */
		public var otherIsThought:Boolean = false;
		/**
		 * A flag to mark whether any CKB references in the initiator's line of
		 * dialogue should be referenced textually (isPicture=false) or
		 * pictorally (isPicture=true)
		 */
		public var initiatorIsPicture:Boolean = false;
		/**
		 * A flag to mark whether any CKB references in the responder's line of
		 * dialogue should be referenced textually (isPicture=false) or
		 * pictorally (isPicture=true)
		 */
		public var responderIsPicture:Boolean = false;
		/**
		 * A flag to mark whether any CKB references in the other's line of
		 * dialogue should be referenced textually (isPicture=false) or
		 * pictorally (isPicture=true)
		 */
		public var otherIsPicture:Boolean = false;
		
		
		public var initiatorIsDelayed:Boolean = false;
		public var responderIsDelayed:Boolean = false;
		public var otherIsDelayed:Boolean = false;
		
		
		
		/**
		 * A String to represent who the initiator is speaking to
		 * (Likely values should be 'responder' or 'other'
		 */
		public var initiatorAddressing:String = "";
		/**
		 * A String to represent who the responder is speaking to
		 * (Likely values should be 'initiator' or 'other'
		 */
		public var responderAddressing:String = "";
		/**
		 * A String to represent who the other is speaking to
		 * (Likely values should be 'initiator' or 'responder'
		 */
		public var otherAddressing:String = "";
		/**
		 * A flag marking whether this other utterance
		 * is indeed spoken by the other (otherIsChorus=false)
		 * or is instead spoken by a Greek Chorus of the rest
		 * of the student body (otherIsChorus=true)
		 */
		public var isOtherChorus:Boolean = false;
		
		
		/**
		 * Variables used for staging in Prom Week
		 */
		public var otherApproach:Boolean = false;
		public var otherExit:Boolean = false;
		
		
		
		
		/**
		 * Locution Vector for the initiator.
		 */
		
		public var initiatorLocutions:Vector.<Locution>;
		/**
		 * Locution Vector for the responder.
		 */
		public var responderLocutions:Vector.<Locution>;
		/**
		 * Locution Vector for other.
		 */
		public var otherLocutions:Vector.<Locution>;
		/**
		 * The rule that stores the Predicates that represent the partial state
		 * change associated with this line of dialog. These are not to be
		 * evaluated are are present for authoring and display purposes only.
		 */
		public var partialChange:Rule;
		
		public var chorusRule:Rule;
		
		public function LineOfDialogue() {
			this.partialChange = new Rule();
			this.chorusRule = new Rule();
			this.initiatorLocutions = new Vector.<Locution>();
			this.responderLocutions = new Vector.<Locution>();
			this.otherLocutions = new Vector.<Locution>();
		}
		
		/**
		 * This function will capitalize character names, and the first letts of sentences
		 * 
		 * @return
		 */
		public static function preprocessLine(theLine:String):String
		{
			var arrayOfWords:Array = theLine.split(" ");
			var withRightNames:String = "";
			var str:String;
			for (var i:int = 0; i < arrayOfWords.length; i++ )
			{
				str = arrayOfWords[i];
				var isCharNameType:String = LineOfDialogue.isCharName(str);
				if (isCharNameType == "first")
				{
					withRightNames += toInitialCap(str);
				}
				else if (isCharNameType == "second")
				{
					withRightNames += str.charAt(0) + str.charAt(1).toUpperCase() + str.substr(2);
				}
				else if (str == "i") {
					withRightNames += "I";
				}
				else
				{
					withRightNames += str;
				}
				if (i != arrayOfWords.length - 1)
				{
					withRightNames += " ";
				}
			}
			
			return capFirstAfterPunctuationAndSpace(withRightNames);
		}

		public static function isCharName(str:String):String
		{
			for each (var char:Character in CiFSingleton.getInstance().cast.characters)
			{
				if (str == char.characterName.toLowerCase())
				{
					return "first";
				}
				else if (str == (char.characterName.toLowerCase() + "'s"))
				{
					return "first";
				}
				else if (str == "(" + (char.characterName.toLowerCase()))
				{
					return "second";
				}
				else if (str == (char.characterName.toLowerCase() + ")"))
				{
					return "first";
				}
				else if (str == (char.characterName.toLowerCase() + ","))
				{
					return "first";
				}
				else if (str == (char.characterName.toLowerCase() + "."))
				{
					return "first";
				}
			}
			return "";
		}
		public static function capFirstAfterPunctuationAndSpace( original:String ):String 
		{
		  var words:Array = original.split( ". " );
		  for (var i:int = 0; i < words.length; i++) 
		  {
			words[i] = toInitialCap(words[i]);
		  }
		  original = words.join(". ");
		  
		  words = original.split( "! " );
		  for (i = 0; i < words.length; i++) 
		  {
			words[i] = toInitialCap(words[i]);
		  }
		  original = words.join("! ");
		  
		  words = original.split( "? " );
		  for (i = 0; i < words.length; i++) 
		  {
			words[i] = toInitialCap(words[i]);
		  }
		  original = words.join("? ");
		  /*
		  words = original.split( "... " );
		  for (i = 0; i < words.length; i++) 
		  {
			words[i] = toInitialLower(words[i]);
		  }
		  original = words.join("... ");
		  */
		  return toInitialCap(original);
		}
		public static function toInitialCap( original:String ):String 
		{
		  return original.charAt(0).toUpperCase() + original.substr(1);
		}   
		public static function toInitialLower( original:String ):String 
		{
		  return original.charAt(0).toLowerCase() + original.substr(1);
		}   
		
		
		
		
		/**
		 * Parses the String representations of the role-specific lines of
		 * dialogue and creates a synonmous Vector of classes that implement
		 * the Locution interface. Explicitly, the three role dialogue strings
		 * are parsed with respect to their literal string and tag components
		 * and placed into Locutions that make performance realization a bit
		 * easier.
		 */
		public function createLocutionVectors():void {
			var parsedLine:Array;
			var tagRegEx:RegExp = /%/; 
			var piece:String;
			var responderRef:CharacterReferenceLocution;
			var responderPossessiveRef:CharacterReferenceLocution;
			var initiatorRef:CharacterReferenceLocution;
			var initiatorPossessiveRef:CharacterReferenceLocution;
			var mixInLocution:MixInLocution;
			var ckbRef:CKBLocution = new CKBLocution();
			var parsedCKB:Array;
			//var ckbRegEx:RegExp = /,/; // split by commas
			var ckbRegEx:RegExp = /(\([^)(]+\))+/g; // split by commas
			var ckbPiece:String;
			var i:int; // my loop iterator!
			var pred:String = "";
			var currentTruthLabel:String;
			var parsedLabel:Array;
			var labelRegEx:RegExp = /,/; 
			var player:String;
			var tempInt:int;
			var mySFDBLocution:SFDBLabelLocution = new SFDBLabelLocution();
			var template:String = "";
			var labelType:String = "";
			var window:int = -999; 
			var openParenIndex:int ;
			var tupleArray:Array;
			var tupleRegEx:RegExp = /,/; // split by comma
			var parsedUndirectedTag:Array;
			var undirectedTagRegEx:RegExp = /,/;
			var currentTuple:String;
			var myLiteralLocution:LiteralLocution;
			var tocLocution:ToCLocution;

			
			//initiator dialogue
			parsedLine = this.initiatorLine.split(tagRegEx);
			for each(piece in parsedLine) {
				//Debug.debug(this, "createLocutionVectors(): " + piece);
				if (piece == "r") {
					responderRef= new CharacterReferenceLocution();
					responderRef.type = "R";
					this.initiatorLocutions.push(responderRef);
				}
				else if (piece == "rp") {
					responderPossessiveRef = new CharacterReferenceLocution();
					responderPossessiveRef.type = "RP";
					this.initiatorLocutions.push(responderPossessiveRef);
				}
				else if (piece == "i") {
					initiatorRef= new CharacterReferenceLocution();
					initiatorRef.type = "I";
					this.initiatorLocutions.push(initiatorRef);
				}
				else if (piece == "ip") {
					initiatorPossessiveRef = new CharacterReferenceLocution();
					initiatorPossessiveRef.type = "IP";
					this.initiatorLocutions.push(initiatorPossessiveRef);
				}
				else if (piece == "greeting" || piece == "shocked") {
					mixInLocution = new MixInLocution();
					mixInLocution.mixInType = piece;
					this.initiatorLocutions.push(mixInLocution);
				}
				else if (piece == "toc1") {
					tocLocution = new ToCLocution();
					tocLocution.tocID = 1;
					tocLocution.realizedString = "";
					this.initiatorLocutions.push(tocLocution);
				}
				else if (piece.substr(0, 3) == "CKB") {
					// INPUT: CKB_((i,likes),(r,dislikes),(LAME))
					ckbRef = new CKBLocution();
					
					ckbPiece = "";
					i = 0; // my loop iterator!
					parsedCKB = piece.match(ckbRegEx); 
					//Debug.debug(this, "Parsed Thing using Big B's regex: " + parsedCKB);
					
					for (i = 0; i < parsedCKB.length; i++) {
						//every item in here will be one of two things:
						//1.)  A TUPLE of the form "i, subjective" or "r, subjective"
						//2.)  A SINGLE of the form lame, or romantic.
						if (parsedCKB[i].charAt(2) == ",") { // we are dealing with a tuple.
							tupleArray = new Array;
							currentTuple = parsedCKB[i];
							currentTuple = currentTuple.substr(1, currentTuple.length - 2);
							tupleArray = currentTuple.split(tupleRegEx);
							
							//OK!!! So, at this point,tupleArray[0] is initiator or responder, and tupleArray[1]
							// is like or dislike!  We ALSO know where we are in the array as a whole via 'i', so
							//we can use that to determine if we are dealing with 'primary' or 'secondary' or what
							//have you.
							
							
							pred = "";
							switch(tupleArray[0]) {
								case "i" : pred = "initiator"; break;
								case "r" : pred = "responder"; break;
								case "o" : pred = "other"; break;
							}
							if (i == 0) {
								ckbRef.pred.primary = pred;
								ckbRef.pred.firstSubjectiveLink = tupleArray[1];
							}
							if (i == 1) {
								ckbRef.pred.secondary = pred;
								ckbRef.pred.secondSubjectiveLink = tupleArray[1];
							}
							
						}
						//Here we are dealing with the zeitgeist Truth label.
						else {
							currentTruthLabel = parsedCKB[i];
							currentTruthLabel = currentTruthLabel.substr(1, currentTruthLabel.length - 2);
							ckbRef.pred.truthLabel = currentTruthLabel;
						}	
					}
					this.initiatorLocutions.push(ckbRef); //OK! We have finally successfully filled this in!
					//Debug.debug(this, "createLocutionVectors(): contents of initiator vector pushed ckbref:" + this.initiatorLocutions.toString());
					//Debug.debug(this, "sanity check: " + this.initiatorLocutions[0]);
				}
				else if (piece.substr(0, 5) == "SFDB_"){ // And here we are working with an SFDB Locution!
					mySFDBLocution = new SFDBLabelLocution();
					template = piece.substr(5, piece.length - 5);
					labelType = "";
					window = -999; // window is optional -- it may not be included in what we initially read in.
					//Debug.debug(this, template);
					
					//Look at the next part of the piece, up until the '(' 
					//symbol, to discover what type of SFDB label we are going 
					//to be working with!
					
					openParenIndex = template.indexOf("(");
					labelType = template.substr(0, openParenIndex);
					//Debug.debug(this, "SFDB label type: " + labelType);
					template = template.substr(openParenIndex + 1, template.length - openParenIndex - 2);
					//Debug.debug(this, "After label type: " + template);

					//At this point, labelType should be the 'english' 
					//representation of an SFDB label, e.g. "cool" or "negative"
					//and template should be a comma seperated list of the
					//people involved in the SFDB entry, e.g. "first,second"
					//POTENTIALLY followed by an 'int' representing the window.
					if (SocialFactsDB.getLabelByName(labelType) < SocialFactsDB.FIRST_DIRECTED_LABEL) {
						//WE ARE DEALING WITH UNDIRECTED LABELS -- ONE parameter, and MAYBE a window
						//Debug.debug(this, "Value of label: " + labelType);
						//Debug.debug(this, "Value of template: " + template);
						if (template.indexOf(",") != -1) {
							parsedUndirectedTag = new Array;
							
						
							parsedUndirectedTag = template.split(undirectedTagRegEx);
							
							//I believe at this point, it is safe to assume that
							//parsedLabel[0] = i or r or o And that parsedLabel[1] 
							//should be a string representation of the window.
							
							template = parsedUndirectedTag[0];
							window = parseInt(parsedUndirectedTag[1]);
							Debug.debug(this, "Value of window: " + window);
							
						}
						mySFDBLocution.pred.sfdbLabel = SocialFactsDB.getLabelByName(labelType);
						mySFDBLocution.pred.window = window;
						mySFDBLocution.pred.primary = template;
					}
					else {
						//WE ARE DEALING WITH DIRECTED LABELS -- TWO parameters and MAYBE a window.
						//Debug.debug(this, "Value of label: " + labelType);
						//Debug.debug(this, "Value of template: " + template);
						
						mySFDBLocution.pred.sfdbLabel = SocialFactsDB.getLabelByName(labelType);
						
						parsedLabel = new Array;
						player="";
						tempInt = 0;
						
						parsedLabel = template.split(labelRegEx);
						
						for (i = 0; i < parsedLabel.length; i++) {
							player = parsedLabel[i];
							//Debug.debug(this, "i: " + i + " player is: " +  player);
							tempInt = parseInt(player);
							//Debug.debug(this, "here is the value of tempInt: " + tempInt);
							if (tempInt != 0) { // It is a number, referring to the window size!
								mySFDBLocution.pred.window = tempInt;
								//Debug.debug(this, "Set the window size to be: " + tempInt);
							}
							else{
								switch(player) {
									case "i" : player = "initiator"; break;
									case "r" : player = "responder"; break;
									case "o" : player = "other"; break;
									default : player = "UNKNOWN PLAYER!"; break;
								}
								if (i == 0) {
									mySFDBLocution.pred.primary = player;
									//Debug.debug(this, "Set the primary person to be " + player);
								}
								if (i == 1) {
									mySFDBLocution.pred.secondary = player;
									//Debug.debug(this, "Set the secondary person to be: " + player);
								}
							}
						}
					}
					
					/*
					switch (labelType) {
						case "cool" : Debug.debug(this, "label is cool!"); break;
						case "lame" : Debug.debug(this, "label is lame!"); break;
						case "negative" : Debug.debug(this, "label is negative!"); break;
						case "positive" : Debug.debug(this, "label is positive!"); break;
						case "taboo" : Debug.debug(this, "label is taboo!"); break;
						case "disagreement" : Debug.debug(this, "label is disagreement!"); break;
						case "harassment" : Debug.debug(this, "label is harassment!"); break;
						default : Debug.debug(this, "UNKNOWN LABEL"); break;
					}
					*/
					
					this.initiatorLocutions.push(mySFDBLocution);
				}
				else { // the catch all is just a literal! We can push it in!
					myLiteralLocution = new LiteralLocution()
					myLiteralLocution.content = piece;
					this.initiatorLocutions.push(myLiteralLocution);
				}
			}
			//Debug.debug(this, "createLocutionVectors(): initiatorLine:" + this.initiatorLine);
			//responder dialogue
			parsedLine = this.responderLine.split(tagRegEx);
			for each(piece in parsedLine) {
				
				//Debug.debug(this, "createLocutionVectors(): " + piece);
				if (piece == "r") {
					responderRef= new CharacterReferenceLocution();
					responderRef.type = "R";
					this.responderLocutions.push(responderRef);
				}
				else if (piece == "rp") {
					responderPossessiveRef = new CharacterReferenceLocution();
					responderPossessiveRef.type = "RP";
					this.responderLocutions.push(responderPossessiveRef);
				}
				else if (piece == "i") {
					initiatorRef= new CharacterReferenceLocution();
					initiatorRef.type = "I";
					this.responderLocutions.push(initiatorRef);
				}
				else if (piece == "ip") {
					initiatorPossessiveRef = new CharacterReferenceLocution();
					initiatorPossessiveRef.type = "IP";
					this.responderLocutions.push(initiatorPossessiveRef);
				}
				else if (piece == "greeting" || piece == "shocked") {
					mixInLocution = new MixInLocution();
					mixInLocution.mixInType = piece;
					this.responderLocutions.push(mixInLocution);
				}
				else if (piece.substr(0, 3) == "CKB") {
					// INPUT: CKB_((i,likes),(r,dislikes),(LAME))
					ckbRef = new CKBLocution();
					
					ckbPiece = "";
					i = 0; // my loop iterator!
					parsedCKB = piece.match(ckbRegEx); 
					//Debug.debug(this, "Parsed Thing using Big B's regex: " + parsedCKB);
					
					for (i = 0; i < parsedCKB.length; i++) {
						//every item in here will be one of two things:
						//1.)  A TUPLE of the form "i, subjective" or "r, subjective"
						//2.)  A SINGLE of the form lame, or romantic.
						if (parsedCKB[i].charAt(2) == ",") { // we are dealing with a tuple.
							tupleArray = new Array;
							currentTuple = parsedCKB[i];
							currentTuple = currentTuple.substr(1, currentTuple.length - 2);
							tupleArray = currentTuple.split(tupleRegEx);
							
							//OK!!! So, at this point,tupleArray[0] is initiator or responder, and tupleArray[1]
							// is like or dislike!  We ALSO know where we are in the array as a whole via 'i', so
							//we can use that to determine if we are dealing with 'primary' or 'secondary' or what
							//have you.
							
							
							pred = "";
							switch(tupleArray[0]) {
								case "i" : pred = "initiator"; break;
								case "r" : pred = "responder"; break;
								case "o" : pred = "other"; break;
							}
							if (i == 0) {
								ckbRef.pred.primary = pred;
								ckbRef.pred.firstSubjectiveLink = tupleArray[1];
							}
							if (i == 1) {
								ckbRef.pred.secondary = pred;
								ckbRef.pred.secondSubjectiveLink = tupleArray[1];
							}
							
						}
						//Here we are dealing with the zeitgeist Truth label.
						else {
							currentTruthLabel = parsedCKB[i];
							currentTruthLabel = currentTruthLabel.substr(1, currentTruthLabel.length - 2);
							ckbRef.pred.truthLabel = currentTruthLabel;
						}	
					}
					this.responderLocutions.push(ckbRef); //OK! We have finally successfully filled this in!
					//Debug.debug(this, "createLocutionVectors(): contents of initiator vector pushed ckbref:" + this.responderLocutions.toString());
					//Debug.debug(this, "sanity check: " + this.responderLocutions[0]);
				}
				else if (piece.substr(0, 5) == "SFDB_"){ // And here we are working with an SFDB Locution!
					mySFDBLocution = new SFDBLabelLocution();
					template = piece.substr(5, piece.length - 5);
					labelType = "";
					window = -999; // window is optional -- it may not be included in what we initially read in.
					//Debug.debug(this, template);
					
					//Look at the next part of the piece, up until the '(' 
					//symbol, to discover what type of SFDB label we are going 
					//to be working with!
					
					openParenIndex = template.indexOf("(");
					labelType = template.substr(0, openParenIndex);
					//Debug.debug(this, "SFDB label type: " + labelType);
					template = template.substr(openParenIndex + 1, template.length - openParenIndex - 2);
					//Debug.debug(this, "After label type: " + template);

					//At this point, labelType should be the 'english' 
					//representation of an SFDB label, e.g. "cool" or "negative"
					//and template should be a comma seperated list of the
					//people involved in the SFDB entry, e.g. "first,second"
					//POTENTIALLY followed by an 'int' representing the window.
					if (SocialFactsDB.getLabelByName(labelType) < SocialFactsDB.FIRST_DIRECTED_LABEL) {
						//WE ARE DEALING WITH UNDIRECTED LABELS -- ONE parameter, and MAYBE a window
						//Debug.debug(this, "Value of label: " + labelType);
						//Debug.debug(this, "Value of template: " + template);
						if (template.indexOf(",") != -1) {
							parsedUndirectedTag = new Array;
							
						
							parsedUndirectedTag = template.split(undirectedTagRegEx);
							
							//I believe at this point, it is safe to assume that
							//parsedLabel[0] = i or r or o And that parsedLabel[1] 
							//should be a string representation of the window.
							
							template = parsedUndirectedTag[0];
							window = parseInt(parsedUndirectedTag[1]);
							//Debug.debug(this, "Value of window: " + window);
							
						}
						mySFDBLocution.pred.sfdbLabel = SocialFactsDB.getLabelByName(labelType);
						mySFDBLocution.pred.window = window;
						mySFDBLocution.pred.primary = template;
					}
					else {
						//WE ARE DEALING WITH DIRECTED LABELS -- TWO parameters and MAYBE a window.
						Debug.debug(this, "Value of label: " + labelType);
						Debug.debug(this, "Value of template: " + template);
						
						mySFDBLocution.pred.sfdbLabel = SocialFactsDB.getLabelByName(labelType);
						
						parsedLabel = new Array;
						player="";
						tempInt = 0;
						
						parsedLabel = template.split(labelRegEx);
						
						for (i = 0; i < parsedLabel.length; i++) {
							player = parsedLabel[i];
							Debug.debug(this, "i: " + i + " player is: " +  player);
							tempInt = parseInt(player);
							//Debug.debug(this, "here is the value of tempInt: " + tempInt);
							if (tempInt != 0) { // It is a number, referring to the window size!
								mySFDBLocution.pred.window = tempInt;
								Debug.debug(this, "Set the window size to be: " + tempInt);
							}
							else{
								switch(player) {
									case "i" : player = "initiator"; break;
									case "r" : player = "responder"; break;
									case "o" : player = "other"; break;
									default : player = "UNKNOWN PLAYER!"; break;
								}
								if (i == 0) {
									mySFDBLocution.pred.primary = player;
									Debug.debug(this, "Set the primary person to be " + player);
								}
								if (i == 1) {
									mySFDBLocution.pred.secondary = player;
									Debug.debug(this, "Set the secondary person to be: " + player);
								}
							}
						}
					}
					
					/*
					switch (labelType) {
						case "cool" : Debug.debug(this, "label is cool!"); break;
						case "lame" : Debug.debug(this, "label is lame!"); break;
						case "negative" : Debug.debug(this, "label is negative!"); break;
						case "positive" : Debug.debug(this, "label is positive!"); break;
						case "taboo" : Debug.debug(this, "label is taboo!"); break;
						case "disagreement" : Debug.debug(this, "label is disagreement!"); break;
						case "harassment" : Debug.debug(this, "label is harassment!"); break;
						default : Debug.debug(this, "UNKNOWN LABEL"); break;
					}
					*/
					
					this.responderLocutions.push(mySFDBLocution);
				}
				else { // the catch all is just a literal! We can push it in!
					myLiteralLocution = new LiteralLocution()
					myLiteralLocution.content = piece;
					this.responderLocutions.push(myLiteralLocution);
				}
			}
			//other dialogue
			parsedLine = this.otherLine.split(tagRegEx);
			for each(piece in parsedLine) {
				
				//Debug.debug(this, "createLocutionVectors(): " + piece);
				if (piece == "r") {
					responderRef= new CharacterReferenceLocution();
					responderRef.type = "R";
					this.otherLocutions.push(responderRef);
				}
				else if (piece == "rp") {
					responderPossessiveRef = new CharacterReferenceLocution();
					responderPossessiveRef.type = "RP";
					this.otherLocutions.push(responderPossessiveRef);
				}
				else if (piece == "i") {
					initiatorRef= new CharacterReferenceLocution();
					initiatorRef.type = "I";
					this.otherLocutions.push(initiatorRef);
				}
				else if (piece == "ip") {
					initiatorPossessiveRef = new CharacterReferenceLocution();
					initiatorPossessiveRef.type = "IP";
					this.otherLocutions.push(initiatorPossessiveRef);
				}
				else if (piece == "greeting" || piece == "shocked") {
					mixInLocution = new MixInLocution();
					mixInLocution.mixInType = piece;
					this.otherLocutions.push(mixInLocution);
				}
				else if (piece.substr(0, 3) == "CKB") {
					// INPUT: CKB_((i,likes),(r,dislikes),(LAME))
					ckbRef = new CKBLocution();
					
					ckbPiece = "";
					i = 0; // my loop iterator!
					parsedCKB = piece.match(ckbRegEx); 
					//Debug.debug(this, "Parsed Thing using Big B's regex: " + parsedCKB);
					
					for (i = 0; i < parsedCKB.length; i++) {
						//every item in here will be one of two things:
						//1.)  A TUPLE of the form "i, subjective" or "r, subjective"
						//2.)  A SINGLE of the form lame, or romantic.
						if (parsedCKB[i].charAt(2) == ",") { // we are dealing with a tuple.
							tupleArray = new Array;
							currentTuple = parsedCKB[i];
							currentTuple = currentTuple.substr(1, currentTuple.length - 2);
							tupleArray = currentTuple.split(tupleRegEx);
							
							//OK!!! So, at this point,tupleArray[0] is initiator or responder, and tupleArray[1]
							// is like or dislike!  We ALSO know where we are in the array as a whole via 'i', so
							//we can use that to determine if we are dealing with 'primary' or 'secondary' or what
							//have you.
							
							
							pred = "";
							switch(tupleArray[0]) {
								case "i" : pred = "initiator"; break;
								case "r" : pred = "responder"; break;
								case "o" : pred = "other"; break;
							}
							if (i == 0) {
								ckbRef.pred.primary = pred;
								ckbRef.pred.firstSubjectiveLink = tupleArray[1];
							}
							if (i == 1) {
								ckbRef.pred.secondary = pred;
								ckbRef.pred.secondSubjectiveLink = tupleArray[1];
							}
							
						}
						//Here we are dealing with the zeitgeist Truth label.
						else {
							currentTruthLabel = parsedCKB[i];
							currentTruthLabel = currentTruthLabel.substr(1, currentTruthLabel.length - 2);
							ckbRef.pred.truthLabel = currentTruthLabel;
						}	
					}
					this.otherLocutions.push(ckbRef); //OK! We have finally successfully filled this in!
					//Debug.debug(this, "createLocutionVectors(): contents of initiator vector pushed ckbref:" + this.otherLocutions.toString());
					//Debug.debug(this, "sanity check: " + this.otherLocutions[0]);
				}
				else if (piece.substr(0, 5) == "SFDB_"){ // And here we are working with an SFDB Locution!
					mySFDBLocution = new SFDBLabelLocution();
					template = piece.substr(5, piece.length - 5);
					labelType = "";
					window = -999; // window is optional -- it may not be included in what we initially read in.
					//Debug.debug(this, template);
					
					//Look at the next part of the piece, up until the '(' 
					//symbol, to discover what type of SFDB label we are going 
					//to be working with!
					
					openParenIndex = template.indexOf("(");
					labelType = template.substr(0, openParenIndex);
					//Debug.debug(this, "SFDB label type: " + labelType);
					template = template.substr(openParenIndex + 1, template.length - openParenIndex - 2);
					//Debug.debug(this, "After label type: " + template);

					//At this point, labelType should be the 'english' 
					//representation of an SFDB label, e.g. "cool" or "negative"
					//and template should be a comma seperated list of the
					//people involved in the SFDB entry, e.g. "first,second"
					//POTENTIALLY followed by an 'int' representing the window.
					if (SocialFactsDB.getLabelByName(labelType) < SocialFactsDB.FIRST_DIRECTED_LABEL) {
						//WE ARE DEALING WITH UNDIRECTED LABELS -- ONE parameter, and MAYBE a window
						//Debug.debug(this, "Value of label: " + labelType);
						//Debug.debug(this, "Value of template: " + template);
						if (template.indexOf(",") != -1) {
							parsedUndirectedTag = new Array;
							
						
							parsedUndirectedTag = template.split(undirectedTagRegEx);
							
							//I believe at this point, it is safe to assume that
							//parsedLabel[0] = i or r or o And that parsedLabel[1] 
							//should be a string representation of the window.
							
							template = parsedUndirectedTag[0];
							window = parseInt(parsedUndirectedTag[1]);
							Debug.debug(this, "Value of window: " + window);
							
						}
						mySFDBLocution.pred.sfdbLabel = SocialFactsDB.getLabelByName(labelType);
						mySFDBLocution.pred.window = window;
						mySFDBLocution.pred.primary = template;
					}
					else {
						//WE ARE DEALING WITH DIRECTED LABELS -- TWO parameters and MAYBE a window.
						//Debug.debug(this, "Value of label: " + labelType);
						//Debug.debug(this, "Value of template: " + template);
						
						mySFDBLocution.pred.sfdbLabel = SocialFactsDB.getLabelByName(labelType);
						
						parsedLabel = new Array;
						player="";
						tempInt = 0;
						
						parsedLabel = template.split(labelRegEx);
						
						for (i = 0; i < parsedLabel.length; i++) {
							player = parsedLabel[i];
							Debug.debug(this, "i: " + i + " player is: " +  player);
							tempInt = parseInt(player);
							//Debug.debug(this, "here is the value of tempInt: " + tempInt);
							if (tempInt != 0) { // It is a number, referring to the window size!
								mySFDBLocution.pred.window = tempInt;
								Debug.debug(this, "Set the window size to be: " + tempInt);
							}
							else{
								switch(player) {
									case "i" : player = "initiator"; break;
									case "r" : player = "responder"; break;
									case "o" : player = "other"; break;
									default : player = "UNKNOWN PLAYER!"; break;
								}
								if (i == 0) {
									mySFDBLocution.pred.primary = player;
									Debug.debug(this, "Set the primary person to be " + player);
								}
								if (i == 1) {
									mySFDBLocution.pred.secondary = player;
									Debug.debug(this, "Set the secondary person to be: " + player);
								}
							}
						}
					}
					
					/*
					switch (labelType) {
						case "cool" : Debug.debug(this, "label is cool!"); break;
						case "lame" : Debug.debug(this, "label is lame!"); break;
						case "negative" : Debug.debug(this, "label is negative!"); break;
						case "positive" : Debug.debug(this, "label is positive!"); break;
						case "taboo" : Debug.debug(this, "label is taboo!"); break;
						case "disagreement" : Debug.debug(this, "label is disagreement!"); break;
						case "harassment" : Debug.debug(this, "label is harassment!"); break;
						default : Debug.debug(this, "UNKNOWN LABEL"); break;
					}
					*/
					
					this.otherLocutions.push(mySFDBLocution);
				}
				else { // the catch all is just a literal! We can push it in!
					myLiteralLocution = new LiteralLocution()
					myLiteralLocution.content = piece;
					this.otherLocutions.push(myLiteralLocution);
				}
			}
		}
		
		/**
		 * Realizes the dialogue with reference to the players of the roles in
		 * the current social game.
		 * 
		 * @param	initiator	The initator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return	The line of dialogue to present to the player in their 
		 * proper role locations.
		 */
		public function realizeDialogue(initiator:Character, responder:Character, other:Character = null):LineOfDialogue {
			var lod:LineOfDialogue = this.clone();
			var l:Locution;

			lod.initiatorLine = "";
			lod.responderLine = "";
			lod.otherLine= "";
			//Debug.debug(this, "realizeDialogue(): initiator locutions length: " + this.initiatorLocutions.length);
			for each (l in this.initiatorLocutions) {
				if (l.getType() == "MixInLocution")
				{
					initiator.isSpeakerForMixInLocution = true;
					lod.initiatorLine += l.renderText(initiator, responder, other, lod);
					initiator.isSpeakerForMixInLocution = false;
				}
				else
				{
					//Debug.debug(this, "realizeDialogue(): initiator locution: " + l);
					lod.initiatorLine += l.renderText(initiator, responder, other, lod) + " ";
				}
			}
			for each (l in this.responderLocutions) {
				if (l.getType() == "MixInLocution")
				{
					responder.isSpeakerForMixInLocution = true;
					lod.responderLine += l.renderText(null, responder, null, lod);
					responder.isSpeakerForMixInLocution = false;
				}
				else
				{
					lod.responderLine += l.renderText(initiator, responder, other, lod) + " ";
				}
			}
			for each (l in this.otherLocutions) {
				if (l.getType() == "MixInLocution")
				{
					other.isSpeakerForMixInLocution = true;
					lod.otherLine += l.renderText(initiator, responder, other, lod);
					other.isSpeakerForMixInLocution = false;
				}
				else
				{
					lod.otherLine += l.renderText(initiator, responder, other, lod) + " ";
				}
			}
			//trace(lod);
			return lod;
		}
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/
		public function toString():String {
			var returnstr:String = new String();
			
			//only print out a single line at a time... and make it the line of the primary speaker.
			if (this.primarySpeaker == "initiator") {
				returnstr += (lineNumber + "\ninitiator:" + initiatorLine + "\n" + initiatorBodyAnimation + "\n" + initiatorFaceAnimation + "\n" + initiatorFaceState + "\n" + responderBodyAnimation + "\n" + responderFaceAnimation + "\n" + responderFaceState + "\n" + otherBodyAnimation + "\n" + otherFaceAnimation + "\n" + otherFaceState + "\n" + time + "\n" + initiatorIsThought + "\n" + initiatorIsDelayed + "\n" + initiatorIsPicture + "\n" + initiatorAddressing + "\n" + isOtherChorus);
			}
			else if (this.primarySpeaker == "responder") {
				returnstr += (lineNumber + "\nresponder:" + responderLine + "\n" + initiatorBodyAnimation + "\n" + initiatorFaceAnimation + "\n" + initiatorFaceState + "\n" + responderBodyAnimation + "\n" + responderFaceAnimation + "\n" + responderFaceState + "\n" + otherBodyAnimation + "\n" + otherFaceAnimation + "\n" + otherFaceState + "\n" + time + "\n" + responderIsThought + "\n" + responderIsDelayed + "\n" + responderIsPicture + "\n" + responderAddressing + "\n" + isOtherChorus);
			}
			else if (this.primarySpeaker == "other") {
				returnstr += (lineNumber + "\nother:" + otherLine + "\n" + initiatorBodyAnimation + "\n" + initiatorFaceAnimation + "\n" + initiatorFaceState + "\n" + responderBodyAnimation + "\n" + responderFaceAnimation + "\n" + responderFaceState + "\n" + otherBodyAnimation + "\n" + otherFaceAnimation + "\n" + otherFaceState + "\n" + time + "\n" + otherIsThought + "\n" + otherIsDelayed + "\n" + otherIsPicture+ "\n" + otherAddressing + "\n" + isOtherChorus + "\n" + otherApproach + "\n" + otherExit);
			}
			else {
				Debug.debug(this, "toString() -- not sure who is the primary speaker");
			}
			return returnstr;
		}
		
		public function toXMLString():String {
			var returnstr:String = new String();
			returnstr += "<LineOfDialogue lineNumber=\"" + this.lineNumber 
				+ "\" initiatorLine=\"" + this.initiatorLine 
				+ "\" responderLine=\"" + this.responderLine 
				+ "\" otherLine=\"" + this.otherLine
				+ "\" primarySpeaker=\"" + this.primarySpeaker
				+"\" initiatorBodyAnimation=\"" + this.initiatorBodyAnimation 
				+ "\" initiatorFaceAnimation=\"" + this.initiatorFaceAnimation 
				+ "\" initiatorFaceState=\"" + this.initiatorFaceState 
				+ "\" responderBodyAnimation=\"" + this.responderBodyAnimation 
				+ "\" responderFaceAnimation=\"" + this.responderFaceAnimation 
				+ "\" responderFaceState=\"" + this.responderFaceState 
				+ "\" otherBodyAnimation=\"" + this.otherBodyAnimation 
				+ "\" otherFaceAnimation=\"" + this.otherFaceAnimation 
				+ "\" otherFaceState=\"" + this.otherFaceState 
				+ "\" time=\"" + this.time 
				+ "\" initiatorIsThought=\"" + this.initiatorIsThought
				+ "\" responderIsThought=\"" + this.responderIsThought
				+ "\" otherIsThought=\"" + this.otherIsThought
				+ "\" initiatorIsDelayed=\"" + this.initiatorIsDelayed
				+ "\" responderIsDelayed=\"" + this.responderIsDelayed
				+ "\" otherIsDelayed=\"" + this.otherIsDelayed
				+ "\" initiatorIsPicture=\"" + this.initiatorIsPicture
				+ "\" responderIsPicture=\"" + this.responderIsPicture
				+ "\" otherIsPicture=\"" + this.otherIsPicture
				+ "\" initiatorAddressing=\"" + this.initiatorAddressing
				+ "\" responderAddressing=\"" + this.responderAddressing
				+ "\" otherAddressing=\"" + this.otherAddressing
				+ "\" otherApproach=\"" + this.otherApproach
				+ "\" otherExit=\"" + this.otherExit
				+ "\" isOtherChorus=\"" + this.isOtherChorus
				+ "\" >\n";
			returnstr += "<PartialChange>\n" + this.partialChange.toXMLString() +"\n</PartialChange>\n";
			returnstr += "<ChorusRule>\n" + this.chorusRule.toXMLString() +"\n</ChorusRule>\n";
			returnstr += "</LineOfDialogue>";
			return returnstr;
		}
		
		
		public function clone(): LineOfDialogue {
			var l:LineOfDialogue = new LineOfDialogue();
			l.lineNumber = this.lineNumber;
			l.initiatorLine = this.initiatorLine;
			l.responderLine = this.responderLine;
			l.otherLine = this.otherLine;
			l.primarySpeaker = this.primarySpeaker;
			l.initiatorBodyAnimation = this.initiatorBodyAnimation;
			l.initiatorFaceAnimation = this.initiatorFaceAnimation;
			l.initiatorFaceState = this.initiatorFaceState;
			l.responderBodyAnimation = this.responderBodyAnimation;
			l.responderFaceAnimation = this.responderFaceAnimation;
			l.responderFaceState = this.responderFaceState;
			l.otherBodyAnimation = this.otherBodyAnimation;
			l.otherFaceAnimation = this.otherFaceAnimation;
			l.otherFaceState = this.otherFaceState;
			l.time = this.time;
			l.partialChange = this.partialChange.clone();
			l.initiatorIsThought = this.initiatorIsThought;
			l.responderIsThought = this.responderIsThought;
			l.otherIsThought = this.otherIsThought;
			l.initiatorIsDelayed = this.initiatorIsDelayed;
			l.responderIsDelayed = this.responderIsDelayed;
			l.otherIsDelayed = this.otherIsDelayed;
			l.initiatorIsPicture = this.initiatorIsPicture;
			l.responderIsPicture = this.responderIsPicture;
			l.otherIsPicture = this.otherIsPicture;
			l.initiatorAddressing = this.initiatorAddressing;
			l.responderAddressing = this.responderAddressing;
			l.otherAddressing = this.otherAddressing;
			l.isOtherChorus = this.isOtherChorus;
			l.otherApproach = this.otherApproach;
			l.otherExit= this.otherExit;
			
			
			l.initiatorLocutions = this.initiatorLocutions.concat();
			l.responderLocutions = this.responderLocutions.concat();
			l.otherLocutions = this.otherLocutions.concat();
			
			l.chorusRule = this.chorusRule.clone();
			
			return l;
		}
		
		public static function equals(x:LineOfDialogue, y:LineOfDialogue): Boolean {
			if (x.lineNumber != y.lineNumber) return false;
			if (x.initiatorLine != y.initiatorLine) return false;
			if (x.responderLine != y.responderLine) return false;
			if (x.otherLine != y.otherLine) return false;
			if (x.primarySpeaker != y.primarySpeaker) return false;
			if (x.initiatorBodyAnimation != y.initiatorBodyAnimation) return false;
			if (x.initiatorFaceAnimation != y.initiatorFaceAnimation) return false;
			if (x.initiatorFaceState != y.initiatorFaceState) return false;
			if (x.responderBodyAnimation != y.responderBodyAnimation) return false;
			if (x.responderFaceAnimation != y.responderFaceAnimation) return false;
			if (x.responderFaceState != y.responderFaceState) return false;
			if (x.otherBodyAnimation != y.otherBodyAnimation) return false;
			if (x.otherFaceAnimation != y.otherFaceAnimation) return false;
			if (x.otherFaceState != y.otherFaceState) return false;
			if (x.time != y.time) return false;
			if (x.initiatorIsThought != y.initiatorIsThought) return false;
			if (x.responderIsThought != y.responderIsThought) return false;
			if (x.otherIsThought != y.otherIsThought) return false;
			
			if (x.initiatorIsDelayed != y.initiatorIsDelayed) return false;
			if (x.responderIsDelayed != y.responderIsDelayed) return false;
			if (x.otherIsDelayed != y.otherIsDelayed) return false;
			
			if (x.initiatorIsPicture != y.initiatorIsPicture) return false;
			if (x.responderIsPicture != y.responderIsPicture) return false;
			if (x.otherIsPicture != y.otherIsPicture) return false;
			if (x.initiatorAddressing != y.initiatorAddressing) return false;
			if (x.responderAddressing != y.responderAddressing) return false;
			if (x.otherAddressing != y.otherAddressing) return false;
			if (x.isOtherChorus != y.isOtherChorus) return false;
			if (x.otherApproach!= y.otherApproach) return false;
			if (x.otherExit != y.otherExit) return false;
			if (!Rule.equals(x.chorusRule, y.chorusRule)) return false;
			return true;
		}
	}
}