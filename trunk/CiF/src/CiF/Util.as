package CiF 
{
	import flash.utils.ByteArray;
	

	/**
	 * ...
	 * @author Josh
	 */
	public class Util
	{
	
		public function Util() 
		{
			
		}
		
		public static function xor(lhs:Boolean, rhs:Boolean):Boolean {
			//return !( lhs && rhs ) && ( lhs || rhs );
			return lhs != rhs;
		}


		/**
		 * Returns the base multiplied by 2^exponent. The parameter numbers are
		 * truncated like integers in C -- everything past the decimal point is
		 * removed.
		 * 
		 * @param	base
		 * @param	exponent
		 * @return Returns base*2^exponent.
		 */
		public static function pow2(base:Number, exponent:Number):Number {
			return base <<= exponent;
		}
 
		public static function cloneArray(source:Object):* { 
			var myBA:ByteArray = new ByteArray(); 
			myBA.writeObject(source); 
			myBA.position = 0; 
			return(myBA.readObject()); 
		}
		
		/**
		 * Returns a random number between the minNum and maxNum
		 * 
		 * @param	minNum
		 * @param	maxNum
		 * @return
		 */
		public static function randRange(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		/**
		 * Parses the String representations of the role-specific lines of
		 * dialogue and creates a synonmous Vector of classes that implement
		 * the Locution interface. Explicitly, the three role dialogue strings
		 * are parsed with respect to their literal string and tag components
		 * and placed into Locutions that make performance realization a bit
		 * easier.
		 */
		public static function createLocutionVectors(unparsedLine:String):Vector.<Locution> {
			var locutions:Vector.<Locution> = new Vector.<Locution>();
			
			var parsedLine:Array;
			var tagRegEx:RegExp = /%/; 
			var piece:String;
			var responderRef:CharacterReferenceLocution;
			var responderPossessiveRef:CharacterReferenceLocution;
			var responderSubjectRef:CharacterReferenceLocution;
			var responderObjectRef:CharacterReferenceLocution;
			var initiatorRef:CharacterReferenceLocution;
			var otherPossessiveRef:CharacterReferenceLocution;
			var otherRef:CharacterReferenceLocution;
			var initiatorPossessiveRef:CharacterReferenceLocution;
			var initiatorSubjectRef:CharacterReferenceLocution;
			var initiatorObjectRef:CharacterReferenceLocution;
			var mixInLocution:MixInLocution;
			var pronounLocution:PronounLocution;
			var listLocution:ListLocution;
			var povLocution:POVLocution;
			var randomLocution:RandomLocution;
			var genderLocution:GenderLocution;
			var conditionalLocution:ConditionalLocution;
			var categoryLocution:CategoryLocution;
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
			var openParenIndex:int;
			var closedParenIndex:int;
			var tupleArray:Array;
			var tupleRegEx:RegExp = /,/; // split by comma
			var parsedUndirectedTag:Array;
			var parsedSFDBTag:Array;
			var undirectedTagRegEx:RegExp = /,/;
			var currentTuple:String;
			var myLiteralLocution:LiteralLocution;
			var tocLocution:ToCLocution;
			var workingStr:String;
			var remainingStr:String;
			var workingStringVarsSplit:Array;
			
			var genderStringVars:String;
			var genderStringVarsSplit:Array;
			
			//initiator dialogue
			parsedLine = unparsedLine.split(tagRegEx);
			for each(piece in parsedLine) {
				if (piece == "r" || piece == "rs") {
					responderRef= new CharacterReferenceLocution();
					responderRef.type = "R";
					if (piece == "rs")
					{
						responderRef.type = "RS";
					}
					locutions.push(responderRef);
				}
				else if (piece == "rp") {
					responderPossessiveRef = new CharacterReferenceLocution();
					responderPossessiveRef.type = "RP";
					locutions.push(responderPossessiveRef);
				}
				else if (piece == "o" || piece == "os") {
					otherRef= new CharacterReferenceLocution();
					otherRef.type = "O";
					if (piece == "os")
					{
						otherRef.type = "OS";
					}
					locutions.push(otherRef);
				}
				else if (piece == "op") {
					otherPossessiveRef = new CharacterReferenceLocution();
					otherPossessiveRef.type = "OP";
					locutions.push(otherPossessiveRef);
				}
				else if (piece == "i" || piece == "is") {
					initiatorRef= new CharacterReferenceLocution();
					initiatorRef.type = "I";
					if (piece == "is")
					{
						initiatorRef.type = "IS";
					}
					locutions.push(initiatorRef);
				}
				else if (piece == "ip") {
					initiatorPossessiveRef = new CharacterReferenceLocution();
					initiatorPossessiveRef.type = "IP";
					locutions.push(initiatorPossessiveRef);
				}
				else if (piece == "greeting" || piece == "shocked" || piece == "positiveadj" || piece == "positiveAdj" || piece == "pejorative"
							|| piece == "sweetie" || piece == "buddy") {
					mixInLocution = new MixInLocution();
					mixInLocution.mixInType = piece;
					locutions.push(mixInLocution);
				}
				else if (piece == "toc1") {
					tocLocution = new ToCLocution();
					tocLocution.tocID = 1;
					tocLocution.realizedString = "";
					locutions.push(tocLocution);
				}
				else if (piece == "toc2") {
					tocLocution = new ToCLocution();
					tocLocution.tocID = 2;
					tocLocution.realizedString = "";
					locutions.push(tocLocution);
				}
				else if (piece == "toc3") {
					tocLocution = new ToCLocution();
					tocLocution.tocID = 3;
					tocLocution.realizedString = "";
					locutions.push(tocLocution);
				}
				else if (piece.substr(0, 2) == "if")
				{
					//%if(34,text 1)elseif(10,text 2)elseif(11,text 3)else(text 4)%
					
					conditionalLocution = new ConditionalLocution();
					
					openParenIndex = piece.indexOf("(");
					closedParenIndex = piece.indexOf(")");
					
					workingStr = piece.substring(openParenIndex + 1, closedParenIndex);
					remainingStr = piece.substring(closedParenIndex + 1, piece.length);
					
					workingStringVarsSplit = workingStr.split(",");
					
					conditionalLocution.ifRuleID = workingStringVarsSplit[0];
					conditionalLocution.ifRuleString = workingStringVarsSplit[1];
					
					//Debug.debug(Util, "ConditionalLocution Parse: if workingString: " + workingStr);
					//Debug.debug(Util, "ConditionalLocution Parse: what's left: " + remainingStr);
					
					if (remainingStr.substr(0,6) == "elseif")
					{
						var isElseIf:Boolean = true;
						while (isElseIf)
						{
							openParenIndex = remainingStr.indexOf("(");
							closedParenIndex = remainingStr.indexOf(")");
							workingStr = remainingStr.substring(openParenIndex + 1, closedParenIndex);
							remainingStr = remainingStr.substring(closedParenIndex + 1, piece.length);
														
							workingStringVarsSplit = workingStr.split(",");
							
							//Debug.debug(Util, "ConditionalLocution Parse: elseif workingString: " + workingStr);
							//Debug.debug(Util, "ConditionalLocution Parse: what's left: " + remainingStr);
							
							conditionalLocution.elseIfRuleIDs.push(workingStringVarsSplit[0]);
							conditionalLocution.elseIfStrings.push(workingStringVarsSplit[1]);
							
							if (remainingStr.substr(0, 6) != "elseif")
							{
								isElseIf = false;
							}
						}
					}
					
					if (remainingStr.substr(0,4) == "else")
					{
							openParenIndex = remainingStr.indexOf("(");
							closedParenIndex = remainingStr.indexOf(")");
							workingStr = remainingStr.substring(openParenIndex + 1, closedParenIndex);
							
							//Debug.debug(Util, "ConditionalLocution Parse: else workingString: " + workingStr);
							//Debug.debug(Util, "ConditionalLocution Parse: what's left: " + remainingStr);
							
							conditionalLocution.elseString = workingStr;
					}

					//Debug.debug(Util, "ConditionalLocution Parse: first if ID: " + conditionalLocution.ifRuleID);
					//Debug.debug(Util, "ConditionalLocution Parse: first if string: " + conditionalLocution.ifRuleString);
					//for (var ggg:int = 0; ggg < conditionalLocution.elseIfRuleIDs.length; ggg++)
					//{
						//Debug.debug(Util, "ConditionalLocution Parse: elseif[" + conditionalLocution.elseIfRuleIDs[ggg] + "]: " + conditionalLocution.elseIfStrings[ggg]);
					//}
					//Debug.debug(Util, "ConditionalLocution Parse: else: " + conditionalLocution.elseString);
					
					locutions.push(conditionalLocution);
				}
				else if (piece.substr(0, 6) == "random") {
					randomLocution = new RandomLocution();
					
					openParenIndex = piece.indexOf("(");
					closedParenIndex = piece.indexOf(")");
					
					workingStr = piece.substring(openParenIndex + 1, closedParenIndex);
					remainingStr = piece.substring(closedParenIndex + 1, piece.length);
					
					workingStringVarsSplit = workingStr.split(",");
					
					for each (var str:String in workingStringVarsSplit)
					{
						randomLocution.candidateStrings.push(str);
					}
					
					locutions.push(randomLocution);
				}
				else if (piece.substr(0, 4) == "rand") {
					randomLocution = new RandomLocution();
					
					openParenIndex = piece.indexOf("(");
					closedParenIndex = piece.indexOf(")");
					
					workingStr = piece.substring(openParenIndex + 1, closedParenIndex);
					remainingStr = piece.substring(closedParenIndex + 1, piece.length);
					
					workingStringVarsSplit = workingStr.split(",");
					
					for each (var str1:String in workingStringVarsSplit)
					{
						randomLocution.candidateStrings.push(str1);
					}
					
					locutions.push(randomLocution);
				}
				else if (piece.substr(0,3) == "cat")
				{
					categoryLocution = new CategoryLocution();
					
					openParenIndex = piece.indexOf("(");
					closedParenIndex = piece.indexOf(")");
					
					workingStr = piece.substring(openParenIndex + 1, closedParenIndex);
					remainingStr = piece.substring(closedParenIndex + 1, piece.length);
					
					workingStringVarsSplit = workingStr.split(",");
					
					categoryLocution.who = workingStringVarsSplit[0];
					categoryLocution.type = workingStringVarsSplit[1];
					
					if (workingStringVarsSplit.length > 2)
					{
						categoryLocution.towardWho = workingStringVarsSplit[2];
					}
					
					locutions.push(categoryLocution);
				}
				else if (piece.substr(0, 4) == "list")
				{
					listLocution = new ListLocution();
					listLocution.who1 = piece.substr(5, 1);
					listLocution.who2 = piece.substr(7, 1);
					listLocution.type = piece.substring(9, piece.length - 1);
					locutions.push(listLocution);
				}
				else if (piece.substr(0, 3) == "pov")
				{
					povLocution = new POVLocution();
					
					openParenIndex = piece.indexOf("(");
					closedParenIndex = piece.indexOf(")");
					workingStr = piece.substring(openParenIndex + 1, closedParenIndex);
					workingStringVarsSplit = workingStr.split(",");
					
					povLocution.initiatorString = workingStringVarsSplit[0];
					povLocution.responderString = workingStringVarsSplit[1];
					povLocution.defaultString = workingStringVarsSplit[2];
					
					locutions.push(povLocution);
				}
				else if (piece.substr(0, 5) == "prons")
				{  // Pronoun ref for subject (default is object)
					pronounLocution = new PronounLocution();
					pronounLocution.who = piece.substr(6, 1);
					pronounLocution.type = piece.substring(8, piece.length - 1);
					pronounLocution.isSubject = true;
					locutions.push(pronounLocution);
				}					
				else if (piece.substr(0, 4) == "pron")
				{
					pronounLocution = new PronounLocution();
					//start at 5 because we don't want '('
					pronounLocution.who = piece.substr(5, 1);
					//the rest will be one of the pronouns, -2 because we don't want the closing ')'
					//and 7 because we don't want the ','
					pronounLocution.type = piece.substring(7, piece.length - 1);					
					locutions.push(pronounLocution);
				}
				else if (piece.substr(0, 6) == "gender")
				{
					genderLocution = new GenderLocution();
					
					genderStringVars = piece.substring(7, piece.length - 1);
					
					genderStringVarsSplit = genderStringVars.split(",");
					
					genderLocution.who = genderStringVarsSplit[0];
					genderLocution.maleString = genderStringVarsSplit[1];
					genderLocution.femaleString = genderStringVarsSplit[2];
					
					locutions.push(genderLocution);
				}
				else if (piece.substr(0, 4) == "CKB_") {
					// INPUT: CKB_((i,likes),(r,dislikes),(LAME))
					ckbRef = new CKBLocution();
					//fix up default responder values in the CKBLocution predicate
					ckbRef.pred.primary = "";
					ckbRef.pred.firstSubjectiveLink = "";
					
					ckbRef.pred.secondary = "";
					ckbRef.pred.secondSubjectiveLink = "";
					
					ckbPiece = "";
					i = 0; // my loop iterator!
					parsedCKB = piece.match(ckbRegEx); 
					//Debug.debug(this, "Parsed Thing using Big B's regex: " + parsedCKB);
					//trace("Parsed Thing using Big B's regex: " + parsedCKB)
					
					if (parsedCKB.length == 2)
					{
						ckbRef.pred.truthLabel = "";
					}
					for (i = 0; i < parsedCKB.length; i++) {
						
						//Debug.debug(Util, "createLocutionVectors() ParsedCKB["+i+"]: "+ parsedCKB[i]);
						
						//every item in here will be one of two things:
						//1.)  A TUPLE of the form "i, subjective" or "r, subjective"
						//2.)  A SINGLE of the form lame, or romantic.
						//if (parsedCKB[i].charAt(2) == ",") { // we are dealing with a tuple.
						if (parsedCKB[i].indexOf(",") != -1)
						{
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
								default: pred = "";
							}
							if (i == 0) {
								ckbRef.pred.primary = pred;
								if (tupleArray[1])
								{
									ckbRef.pred.firstSubjectiveLink = tupleArray[1];
								}
								else
								{
									ckbRef.pred.firstSubjectiveLink = "";
								}
							}
							if (i == 1) {
								ckbRef.pred.secondary = pred;
								if (tupleArray[1])
								{
									ckbRef.pred.secondSubjectiveLink = tupleArray[1];
								}
								else
								{
									ckbRef.pred.secondSubjectiveLink = "";
								}
							}
						}
						//Here we are dealing with the zeitgeist Truth label.
						else 
						{
							currentTruthLabel = parsedCKB[i];
							currentTruthLabel = currentTruthLabel.substr(1, currentTruthLabel.length - 2);
							//Debug.debug(Util, "-----"+currentTruthLabel+"------");
							if (currentTruthLabel && currentTruthLabel != ",")
							{
								ckbRef.pred.truthLabel = currentTruthLabel;
							}
							else
							{
								ckbRef.pred.truthLabel = "";
								//Debug.debug(Util, "Truth label is blank!");
							}
							//Debug.debug(Util,"createLocutionVectors() "+ckbRef.pred.toString());
						}	
					}
					//trace("ckb primary: " + ckbRef.pred.primary + " " + ckbRef.pred.firstSubjectiveLink);
					//trace("ckb secondary: "+ckbRef.pred.secondary + " " + ckbRef.pred.secondSubjectiveLink);
					//trace("ckb truth: "+ckbRef.pred.truthLabel);
					locutions.push(ckbRef); //OK! We have finally successfully filled this in!
					//Debug.debug(this, "createLocutionVectors(): contents of initiator vector pushed ckbref:" + locutions.toString());
					//Debug.debug(this, "sanity check: " + locutions[0]);
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
					
					
					
					if (template.indexOf(",") != -1) {
						parsedSFDBTag = new Array;
						parsedSFDBTag = template.split(undirectedTagRegEx);
					}else {
						Debug.debug(Util, "createLocutionVectors() SFDB_ has no parameters: " + piece);
					}
					
					/*
					 * %SFDB_(,,,)%
					 * The SFDB tag will always have 4 commas that separate 4
					 * potential values. The first value is the label, second
					 * is the first character role, third is the second
					 * character role, and fourth is the SFDB window.
					 * 
					 * Parse each one in turn.
					 * 
					 * Directional SFDB labels aren't being checked yet.
					 */
					
					if (!parsedSFDBTag.length >= 3) {
						Debug.debug(Util, "createLocutionVectors() the parsed SFDB tag is missing parameters during parameter parse: " + parsedSFDBTag);
					}else {
						//Debug.debug(Util, "createLocutionVectors() parameter parse: " + parsedSFDBTag);
						//first should be a string label
						mySFDBLocution.pred.sfdbLabel = SocialFactsDB.getLabelByName(parsedSFDBTag[0]);
						//second should be a role specifier
						switch(parsedSFDBTag[1]) {
									case "i" : mySFDBLocution.pred.primary = "initiator"; break;
									case "r" : mySFDBLocution.pred.primary = "responder"; break;
									case "o" : mySFDBLocution.pred.primary = "other"; break;
									case "" : mySFDBLocution.pred.primary = ""; break;
									default : 
										Debug.debug(Util, "createLocutionVectors() the first SFDB role is not a valid i,r,o,\"\": " + parsedSFDBTag[1]);
						}
						//third should be a role specifier
						switch(parsedSFDBTag[2]) {
									case "i" : mySFDBLocution.pred.secondary = "initiator"; break;
									case "r" : mySFDBLocution.pred.secondary = "responder"; break;
									case "o" : mySFDBLocution.pred.secondary = "other"; break;
									case "" : mySFDBLocution.pred.secondary = ""; break;
									default : 
										Debug.debug(Util, "createLocutionVectors() the first SFDB role is not a valid i,r,o,\"\": " + parsedSFDBTag[2]);
						}
						//fourth, if it exists, should be the SFDBENTRY window
						mySFDBLocution.pred.window = 0;
						if (parsedSFDBTag.length > 3) {
							if (parsedSFDBTag[3].toString().length > 0) {
								mySFDBLocution.pred.window = parseInt(parsedSFDBTag[3]);
							}
						}
						//make noise if the SFDB label was a directional type and only has one specified role.
						if (mySFDBLocution.pred.sfdbLabel >= SocialFactsDB.FIRST_DIRECTED_LABEL
							&& (mySFDBLocution.pred.primary.length == 0 || mySFDBLocution.pred.primary.length == 0)) {
							Debug.debug(Util, "createLocutionVectors() the SFDB label is directed and there is a missing role specification: " + piece);
						}
					}
					locutions.push(mySFDBLocution);
				}
				else { // the catch all is just a literal! We can push it in!
					myLiteralLocution = new LiteralLocution()
					myLiteralLocution.content = piece;
					locutions.push(myLiteralLocution);
				}
			}
			return locutions;
		}
		
	}

}