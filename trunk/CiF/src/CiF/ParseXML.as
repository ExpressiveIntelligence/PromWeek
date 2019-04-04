package CiF 
{
	import flash.events.Event;
	/**
	 * TODO: make this an XMLIO class instead of just parseXML
	 * TODO: Clean up this class: documentation, clarity, function domains.
	 * TODO: Clear out old code.
	 * TODO: SFDB
	 * TODO: Characters
	 * TODO: Networks
	 * TODO: Relationships
	 * 
	 */
	public class ParseXML
	{
		
		public function ParseXML() 
		{
	
		}

		public static function predicateParse(predXML:XML):Predicate {
			var p:Predicate = new Predicate();
			var type:String = predXML.@type.toLowerCase();
			var negatedBool:Boolean = false; // pulling from xml will return a string, we need a boolean.
			var sfdbBool:Boolean = false; // pulling from xml will return a string, we need a boolean.
			//trace("\t\t\t" + type);
			if (type == "trait") {
				if (predXML.@negated == "true") 
					negatedBool = true;
				if (predXML.@isSFDB == "true") 
					sfdbBool = true;		
				p.setTraitPredicate(predXML.@first, Trait.getNumberByName(predXML.@trait), negatedBool, sfdbBool);
				//trace("\t\t\t creating trait predicate: " + predXML.@first + " " + Trait.getNumberByName(predXML.@trait) + " " + negatedBool + " " + sfdbBool);
			}
			else if (type == "network") {
				if (predXML.@negated == "true") 
					negatedBool = true;
				if (predXML.@isSFDB == "true") 
					sfdbBool = true;	
				p.setNetworkPredicate(predXML.@first, predXML.@second, predXML.@comparator, predXML.@value, SocialNetwork.getTypeFromName(predXML.@networkType), negatedBool, sfdbBool);
				//trace("\t\t\t creating network predicate: " + predXML.@first + " " + predXML.@second + " " + predXML.@comparator + " " + predXML.@value + " " + predXML.@networkType + " " + negatedBool + " " + sfdbBool);
			}
			else if (type == "status") {			
				if (predXML.@negated == "true") 
					negatedBool = true;
				if (predXML.@isSFDB == "true") 
					sfdbBool = true;	
				p.setStatusPredicate(predXML.@first, predXML.@second, Status.getStatusNumberByName(predXML.@status), negatedBool, sfdbBool);
			}
			
			else if (type.toLowerCase() == "ckb entry" || type.toLowerCase() == "ckbentry") {
				if (predXML.@negated == "true")
					negatedBool = true;
				p.setCKBPredicate(predXML.@first, predXML.@second, predXML.@firstSubjective, predXML.@secondSubjective, predXML.@label, negatedBool);
				//p.setCKBEntryPredicate(predXML.@first, predXML.@second, predXML.@firstSubjective, predXML.@secondSubjective, predXML.@label);
				//trace("\t\t\t creating ckb entry predicate: " + predXML.@first + " " + predXML.@second + " "  + predXML.@firstSubjective + " "  + predXML.@secondSubjective + " "  + predXML.@label + " " + negatedBool + " " + sfdbBool);
			}
			else if (type.toLowerCase() == "sfdb label" || type.toLowerCase() == "sfdblabel") {
				if (predXML.@negated == "true") 
					negatedBool = true;
				p.setSFDBLabelPredicate(predXML.@first, predXML.@second, SocialFactsDB.getLabelByName(predXML.@label), negatedBool, predXML.@window);
			}
			else if (type == "relationship") {
				if (predXML.@negated == "true") 
					negatedBool = true;
				if (predXML.@isSFDB == "true") 
					sfdbBool = true;	
				p.setRelationshipPredicate(predXML.@first, predXML.@second, RelationshipNetwork.getRelationshipNumberByName(predXML.@relationship), negatedBool, sfdbBool);
				//trace("\t\t\t creating relationship predicate: " + predXML.@first + " " + predXML.@second + " "  + predXML.@relationship + " " + type + " " + negatedBool + " " + sfdbBool);
			}
			
			if (predXML.@intent == "true") p.intent = true;
			
			if (predXML.@description)
			{
				p.description = predXML.@description;
			}
			
			//p.numTimesUniquelyTrueFlag = (predXML.@numTimesUniquelyTrueFlag.toString().length > 0) ? predXML.@numTimesUniquelyTrueFlag.toString(): false;
			if (predXML.@numTimesUniquelyTrueFlag == "true") 
			{
				p.numTimesUniquelyTrueFlag = true 
			}
			else 
			{
				p.numTimesUniquelyTrueFlag = false;
			}
			p.numTimesUniquelyTrue = (predXML.@numTimesUniquelyTrue.toString().length > 0) ? predXML.@numTimesUniquelyTrue: 0;
			p.numTimesRoleSlot = (predXML.@numTimesRoleSlot.toString().length > 0) ? predXML.@numTimesRoleSlot: "";
			
			p.window = (predXML.@window)?predXML.@window:0;
			
			p.sfdbOrder = (predXML.@sfdbOrder.toString().length > 0) ? predXML.@sfdbOrder: 0;
			
			//trace(p.toNaturalLanguageString("Monica", "Simon"));
			return p;
		}
		/**
		 * Parses the XML representation of the cast and populates the Cast
		 * singletone.
		 * @param	castXML The XML representation of the cast.
		 */
		public static function castParse(castXML:XML):void {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			var character:Character;
			var characterXML:XML;
			
			//make the Character instantiations and put them in the Cast with names and network IDs
			for each(characterXML in castXML.Character) {
				
				character = new Character();
				character.characterName = characterXML.@name;
				character.networkID = characterXML.@networkID;

				for each (var locutionXML:XML in characterXML.Locution)
				{
					//Debug.debug(ParseXML, "castParse: " + locutionXML.@type);
					//Debug.debug(ParseXML, "castParse: " + locutionXML);
					character.locutions[new String(locutionXML.@type)] = new String(locutionXML);
					//for (var key:Object in character.locutions)
					//{
						//Debug.debug(ParseXML, "castParse: key: " + key + " value: " + character.locutions[key as String]);
					//}
				}

				cif.cast.addCharacter(character);
			}
			//now the characters are in the Cast, we can assign their traits and statuses
			for each(characterXML in castXML.Character) {
				characterTraitAndStatusParse(characterXML);
			}
		}
		
		/*
		 * characterParse takes a formatted XML string that is meant to represent a single character. e.g.
		 *<Character name="Robert" networkID="0" >
			<Trait type="clumsy" />
			<Trait type="sex magnet" />
			<Trait type="confidence" />
			<Status type="enmity" from="edward" to="debbie" />
		   </Character>
		 * 
		 * characterParse then uses this information to fill an instance of type Character,
		 * and then returns the filled data structure.
		 * 
		 * @param person -- the XML representation of a character.
		 * */
		public static function characterTraitAndStatusParse(characterXML:XML):void {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			var currentChar:Character;
			
			
			//Go through all of the traits of this character
			//var traitAndStatusListXML:XMLList = characterXML..Statuses.Status;
			//Debug.debug(ParseXML, "characterParse() status XML list: " + traitAndStatusListXML);
			//Debug.debug(ParseXML, "characterParse() ..Statuses: " + characterXML..Statuses);
			//Debug.debug(ParseXML, "characterParse() ..Status: " + characterXML..Status);
			//Debug.debug(ParseXML, "characterParse() .Statuses: " + characterXML.Statuses);
			//Debug.debug(ParseXML, "characterParse() ..Status: " + characterXML..Status);
			//Debug.debug(ParseXML, "characterParse() .Statuses.Status: " + characterXML..Statuses.Status);
			//Debug.debug(ParseXML, "characterParse() ..Statuses..Status: " + characterXML..Statuses.Status);
			
			for each(var statusXML:XML in characterXML..Status) {
				//Debug.debug(ParseXML, "characterParse() statusXML: " + statusXML.toXMLString());
				currentChar = cif.cast.getCharByName(statusXML.@from);
				currentChar.addStatus(Status.getStatusNumberByName(statusXML.@type), cif.cast.getCharByName(statusXML.@to));
			}

			for each(var curTrait:XML in characterXML..Trait) {
				currentChar = cif.cast.getCharByName(characterXML.@name);
				currentChar.traits.push(Trait.getNumberByName(curTrait.attribute("type")));
			}
	
			//trace("XML Version: " + characterXML);
			//trace("Data Structure Version: " + currentChar.toXMLString());
			
		}
		
		/*
		 * SFDBContextParse will, given an SFDBContext formatted in XML, e.g. 
		 * 
		 * 	<StatusContext time="20" >
			<Predicate type="status" status="has crush" first="karen" second="robert" negated="false" isSFDB="true" />
			</StatusContext>
			
			will spit out a data structure with the pertinent information filled in.
		 * */
		public static function SFDBContextParse(context:XML):SFDBContext {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			if (context.name() == "StatusContext") {
				var sc:StatusContext = new StatusContext();
				//var predicateList:XMLList = context.children();
				sc.time = context.attribute("time");
				sc.from = cif.cast.getCharByName(context.@from);
				sc.to = (context.@to.toString != "")?cif.cast.getCharByName(context.@to):null;
				sc.negated = context.@negated;
				sc.statusType = Status.getStatusNumberByName(context.@status);
				//for each(var pred:XML in predicateList) {
					//sc.predicate = ParseXML.predicateParse(pred).clone();
				//}
				//trace("ParseXML:::SFDBContextParse:: Internal Represented Status Context:\n" + sc.toXMLString());
				//trace("ParseXML:::SFDBContextParse:: From XML file:\n" + context);
				return sc;
			}
			else if (context.name() == "JuiceContext")
			{
				
			}
			else if (context.name() == "TriggerContext") {
				var tc:TriggerContext = new TriggerContext();
				tc.time = context.@time;
				tc.id = context.@id;
				tc.initiator = context.@initiator;
				tc.responder = (context.@resonder.toString())?context.@responder:"";
				tc.other = (context.@other.toString())?context.@other:"";
				
				//trace("from ParseXML::SFDBContextParse:: TRIGGER CONTEXT NEEDS TO BE FILLED IN STILL! RETURNING NULL");
				return tc;
			}
			else if (context.name() == "SocialGameContext") {
				var sgc:SocialGameContext = new SocialGameContext();
				sgc.gameName = context.@gameName;
				sgc.initiator = context.@initiator;
				sgc.responder = context.@responder;
				sgc.other = context.@other;
				sgc.initiatorScore = context.@initiatorScore;
				sgc.responderScore = context.@responderScore;
				sgc.effectID = context.@effectID;
				sgc.time = context.@time;
				sgc.chosenItemCKB = context.@chosenCKBItem;
				sgc.referenceSFDB = context.@socialGameContextReference;
				if (context.@label.toString()) sgc.label = context.@label;
				if (context.@labelFrom.toString()) sgc.labelArg1 = context.@labelFrom;
				if (context.@labelDirectedAt.toString()) sgc.labelArg2 = context.@labelDirectedAt;
				
				//get the ckb predicates if they exists
				for each(var ckbPredXML:XML in context..Predicate) {
					sgc.queryCKB=predicateParse(ckbPredXML);
				}
				
				for each(var sgLabelXML:XML in context..SFDBLabel) {
					var sgLabel:SFDBLabel = new SFDBLabel();
					sgLabel.type = (sgLabelXML.@type.toString())?(sgLabelXML.@type):"";
					sgLabel.from = (sgLabelXML.@from.toString())?(sgLabelXML.@from):"";
					sgLabel.to 	 = (sgLabelXML.@to.toString())?(sgLabelXML.@to):"";
					sgc.SFDBLabels.push(sgLabel); // Actually push this beautiful thing that we created.
				}
				
				//trace("from ParseXML::SFDBContextParse:: SOCIAL GAME CONTEXT NEEDS TO BE FILLED IN STILL! RETURNING NULL");
				return sgc;
			}
			else if (context.name() == "BackstoryContext") {
				//trace("we are dealing with a piece of backstory!");
				var bsc:SocialGameContext = new SocialGameContext(); // going to treat it as just a social game context!
				bsc.isBackstory = true;
				bsc.time = context.@time;
				bsc.initiator = context.@initiator;
				bsc.responder = context.@responder;
				bsc.labelArg1 = bsc.initiator;
				bsc.labelArg2 = bsc.responder;
				bsc.other = context.@other;
				bsc.label = context.@SFDBLabel;
				bsc.performanceRealizationString = context.@PerformanceRealizationString;
				//Debug.debug(ParseXML, "SFDBContextParse() - BackstoryContext: Just to test! time=" + bsc.time + "initiator=" + bsc.initiator + "label=" + bsc.label + " prs=" + bsc.performanceRealizationString);
				bsc.backstoryLocutions = Util.createLocutionVectors(bsc.performanceRealizationString);
				return bsc;
			}
			else {
				trace("from ParseXML::SFDBContextParse:: ENCOUNTERED UNKNOWN CONTEXT TYPE! RETURNING NULL: "+context.name());
				return null;
			}	
			return null;
		}
		
		/**
		 * Populates CiF's singleton's microtheories property with the data
		 * structure translation of the microtheories' XML.
		 * 
		 * @param	microtheoryXML	The MXL representation of microtheories.
		 * 
		 * @example <listing version="3.0">
		 * The following a pattern for the XML representation of microtheories.
		 * The Microtheories XML structure is at the same level as the SFDB,
		 * CKB, and social game library.
		 * 
		 * <Microtheories>
		 *   <Microtheory>
		 *     <Name>Brag</Name>
		 *     <Definition>
		 *       <Rule>
		 *         //standard rule predicate list
		 *       </Rule>
		 *     </Definition>
		 *     <InitiatorInfluenceRuleSet>
		 * 			//standard IRS
		 *     </InitiatorInfluenceRuleSet>
		 *     <ResponderInfluenceRuleSet>
		 * 			//standard IRS
		 *     </ResponderInfluenceRuleSet>
		 *   </Microtheory>
		 * </Microtheories>
		 * </listing>
		 */
		public static function microtheoryParse(microtheoryXML:XML):void {
			var theoryXML:XML;
			var domainRuleXML:XML;
			var influenceRuleXML:XML;
			var predXML:XML;
			var ir:InfluenceRule;
			var irIter:InfluenceRule;
			var maxID:int;
			var microtheory:Microtheory;
			
			var cif:CiFSingleton = CiFSingleton.getInstance();
			
			var totalRules:Number = 0;
			
			//Debug.debug(ParseXML, "microtheoryParse() microtheoryXML: " + microtheoryXML.toXMLString());
			
			for each (theoryXML in microtheoryXML..Microtheory) {
				
				microtheory = new Microtheory();
				microtheory.name = theoryXML.Name;
				//Debug.debug(ParseXML, "microtheoryParse() name: " + microtheory.name + " - theoryXML.Name: " + theoryXML.Name);
			
				microtheory.definition.name = theoryXML.Definition.Rule.@name;
				
				for each (predXML in theoryXML.Definition.Rule.Predicate) {
					microtheory.definition.predicates.push(predicateParse(predXML));
					//Debug.debug(ParseXML, "microtheoryParse() predicate in definition: " + microtheory.definition.predicates[microtheory.definition.predicates.length - 1].toXMLString());
					//Debug.debug(ParseXML, "microtheoryParse() predicate XML: " + predXML.toXMLString() );
					
				}
				
				for each (influenceRuleXML in theoryXML.InitiatorInfluenceRuleSet..InfluenceRule) {
					ir = influenceRuleParse(influenceRuleXML);
					
					
					// fill the total weight per intent array (for use with the network line calcuations)
					var intentIndex:int = ir.findIntentIndex();
					if (ir.weight >= 0)
					{
						if (intentIndex >= 0)
						{
							cif.intentsTotalPos[ir.predicates[intentIndex].getIntentType()] += ir.weight;
						}
					}
					else
					{
						if (intentIndex >= 0)
						{						
							cif.intentsTotalNeg[ir.predicates[intentIndex].getIntentType()] += ir.weight;
						}
					}
					
					
					microtheory.initiatorIRS.influenceRules.push(ir);
					
					if (ir.weight != 0)
					{
						totalRules++;
					}
				}
				
				for each (ir in microtheory.initiatorIRS.influenceRules) {
					maxID = 0;
					if ( -1 == ir.id) {
						for each (irIter in microtheory.initiatorIRS.influenceRules) {
							if (maxID <= irIter.id) maxID = irIter.id + 1;
						}
						ir.id = maxID;
					}
					//Debug.debug(ParseXML, ir.generateRuleName());
				}
				/*
				for each (influenceRuleXML in theoryXML.ResponderInfluenceRuleSet..InfluenceRule) {
					ir = influenceRuleParse(influenceRuleXML);

					//swap the roles of each of ir's preds
					ir.reverseRoles();
					
					microtheory.responderIRS.influenceRules.push(ir);
				}
				
				for each (ir in microtheory.responderIRS.influenceRules) {
					maxID = 0;
					if ( -1 == ir.id) {
						for each (irIter in microtheory.responderIRS.influenceRules) {
							if (maxID <= irIter.id) maxID = irIter.id + 1;
						}
						ir.id = maxID;
					}
				}
				*/
				
				var iteratorRule:Rule;
				//before adding this to the library, sort all the predicates in all rules
				for each (iteratorRule in microtheory.initiatorIRS.influenceRules)
				{
					iteratorRule.sortPredicates();
				}
				
				
				//FIX: for now, just clone the initiatorIRS for the responderIRS and remember
				// to call the eval functions with the roles reversed
				//microtheory.responderIRS = microtheory.initiatorIRS.clone();
				
				cif.microtheories.push(microtheory);
			}
			
			/*for (var ii:int = 0; ii < Predicate.NUM_INTENT_TYPES; ii++ )
			{
				trace("microtheoryParse() " + Predicate.getIntentNameByNumber(ii) + " Pos Weight Total: " + cif.intentsTotalPos[ii]);
				trace("microtheoryParse() " + ii + " Neg Weight Total: " + cif.intentsTotalNeg[ii]);
			}*/
			
			//Debug.debug(this, "microtheoryParse(); "+totalRules+" microtheory rules loaded");
			//trace("microtheoryParse(); " + totalRules + " microtheory rules loaded");
			
			
			for each (var microT:Microtheory in cif.microtheories)
			{
				for each (var infR:InfluenceRule in microT.initiatorIRS.influenceRules)
				{
					if (infR.name.charAt(0) == "}")
					{
						var outputStr:String = "";
						outputStr += ("Microtheory Name: " + microT.name + "\nDefinition:\n");
						for each (var defPred:Predicate in microT.definition.predicates)
						{
							//outputStr += ("   " + defPred.toNaturalLanguageString(defPred.primary,defPred.secondary) + "\n");
							outputStr += ("   " + defPred.toString() + "\n");
						}
						outputStr += ("Rule:\n");
						for each (var predI:Predicate in infR.predicates)
						{
							outputStr += "   ";
							if (predI.getIntentType() != -1)
							{
								outputStr += ("* " + infR.weight + " Intent to: ");
							}
							//outputStr += (predI.toNaturalLanguageString(predI.primary, predI.secondary) + "\n");
							outputStr += (predI.toString() + "\n");
						}
						//trace(outputStr);
					}
				}
			}
			
		}
		
		/**
		 * Creates a new InfluenceRule instance parameterized by incoming XML.
		 * @param	irXML	The XML representation of an InfluenceRule.
		 * @return	A new instance of an InfluenceRule corresponding to the XML
		 * input.
		 */
		public static function influenceRuleParse(irXML:XML):InfluenceRule {
			var predXML:XML;
			if (CONFIG::InstrumentRules) {
				var ir:InstrumentedInfluenceRule = new InstrumentedInfluenceRule();
				
				
				
				ir.id = (irXML.@id.toString())?irXML.@id:-1;
				ir.name = irXML.@name;
				ir.weight = irXML.@weight;
				
				
				for each (predXML in irXML..Predicate) {
					ir.predicates.push(predicateParse(predXML));
				}
				return ir;
			}else{
				var influenceRule:InfluenceRule = new InfluenceRule();
				
				influenceRule.id = (irXML.@id.toString())?irXML.@id:-1;
				influenceRule.name = irXML.@name;
				influenceRule.weight = irXML.@weight;
				for each (predXML in irXML..Predicate) {
					influenceRule.predicates.push(predicateParse(predXML));
				}
				return influenceRule;
			}
			/*
			var predXML:XML;
			
			ir.id = (irXML.@id.toString())?irXML.@id:-1;
			ir.name = irXML.@name;
			ir.weight = irXML.@weight;
			for each (predXML in irXML..Predicate) {
				ir.predicates.push(predicateParse(predXML));
			}
			return ir;
			*/
		}
		
		
		/**
		 * Creates a new Rule instance parameterized by incoming XML.
		 * @param	irXML	The XML representation of an Rule.
		 * @return	A new instance of an Rule corresponding to the XML
		 * input.
		 */
		public static function ruleParse(ruleXML:XML):Rule {
			var r:Rule = new Rule();
			var predXML:XML;
			
			r.id = (ruleXML.@id.toString())?ruleXML.@id:-1;
			r.name = ruleXML.@name;
			for each (predXML in ruleXML..Predicate) {
				r.predicates.push(predicateParse(predXML));
			}
			return r;
		}
		
		/*
		 * buddyNetworkParse takes in a formatted XML object representing a BuddyNetwork, e.g.
		 * 	
		<Network type="buddy" numChars="3">
			<edge from="0" to="1" value="10" />
			<edge from="0" to="2" value="20" />
			<edge from="1" to="0" value="30" />
			<edge from="1" to="2" value="40" />
			<edge from="2" to="0" value="50" />
			<edge from="2" to="1" value="60" />
		</Network>
		
		and parses the information contained therein and uses it to fill up
		the BuddyNetwork singleton of CiFSingleton.
		 */
		public static function buddyNetworkParse(network:XML):void {
			var budNet:BuddyNetwork = BuddyNetwork.getInstance();
			budNet.initialize(network.@numChars);
			var buddyWeights:XMLList = network.children();
			for each(var weight:XML in buddyWeights) {
				budNet.setWeight(weight.@from, weight.@to, weight.@value);
			}
			//trace("ParseXML::buddyNetworkParse Internal Representation: " + budNet.toXMLString());
			//trace("ParseXML::buddyNetworkParse XML File: " + network);
		}
		
		/*
		 * coolNetworkParse takes in a formatted XML object representing a CoolNetwork, e.g.
		 * 	
		<Network type="cool" numChars="3">
			<edge from="0" to="1" value="10" />
			<edge from="0" to="2" value="20" />
			<edge from="1" to="0" value="30" />
			<edge from="1" to="2" value="40" />
			<edge from="2" to="0" value="50" />
			<edge from="2" to="1" value="60" />
		</Network>
		
		and parses the information contained therein and uses it to fill up
		the CoolNetwork singleton of CiFSingleton.
		 */
		public static function coolNetworkParse(network:XML):void {
			var coolNet:CoolNetwork = CoolNetwork.getInstance();
			coolNet.initialize(network.@numChars);
			var coolWeights:XMLList = network.children();
			for each(var weight:XML in coolWeights) {
				coolNet.setWeight(weight.@from, weight.@to, weight.@value);
			}
			//trace("ParseXML::coolNetworkParse Internal Representation: " + coolNet.toXMLString());
			//trace("ParseXML::coolNetworkParse XML File: " + network);
		}
		
		/*
		 * romanceNetworkParse takes in a formatted XML object representing a RomanceNetwork, e.g.
		 * 	
		<Network type="romance" numChars="3">
			<edge from="0" to="1" value="10" />
			<edge from="0" to="2" value="20" />
			<edge from="1" to="0" value="30" />
			<edge from="1" to="2" value="40" />
			<edge from="2" to="0" value="50" />
			<edge from="2" to="1" value="60" />
		</Network>
		
		and parses the information contained therein and uses it to fill up
		the RomanceNetwork singleton of CiFSingleton.
		 */
		public static function romanceNetworkParse(network:XML):void {
			var romanceNet:RomanceNetwork = RomanceNetwork.getInstance();
			romanceNet.initialize(network.@numChars);
			var romanceWeights:XMLList = network.children();
			for each(var weight:XML in romanceWeights) {
				//Debug.debug(ParseXML, "romanceNetworkParse() "+weight.toXMLString());
				romanceNet.setWeight(weight.@from, weight.@to, weight.@value);
			}
			//trace("ParseXML::romanceNetworkParse Internal Representation: " + romanceNet.toXMLString());
			//trace("ParseXML::romanceNetworkParse XML File: " + network);
		}
		
		/**
		 * @deprecated Statuses are now attached to characters are are not
		 * represented as a network.
		 * 
		* and parses the information contained therein and uses it to fill up
		* the statues of Characters.
		*/
		public static function statusesParse(network:XML):void {
			var statusList:XMLList = network.children();
			var theCast:Cast = Cast.getInstance();
			var char:Character;
			//statusNet.initialize(theCast.characters.length); // otherwise finds an undefined network later on down the line, I think.
			for each(var stat:XML in statusList) {
				char = theCast.getCharByName(stat.@from);
				if(stat.@to == ""){
					char.addStatus(Status.getStatusNumberByName(stat.@type));
				}
				else{
					char.addStatus(Status.getStatusNumberByName(stat.@type), theCast.getCharByName(stat.@to));
				}
			}
		}
		
		/*
		 * relationshipNetworkParse takes in a formatted XML object representing a RelationshipNetwork, e.g.
		 * 	
		<Relationships>
			<Relationship type="friends" from="Robert" to="Lily" />
			<Relationship type="dating" from="Robert" to="Karen" />
			<Relationship type="enemies" from="Karen" to="Lily" />
		</Relationships>
		
		and parses the information contained therein and uses it to fill up
		the RelationshipNetwork singleton of CiFSingleton.
		*/
		public static function relationshipNetworkParse(network:XML):void {
			var relationshipNet:RelationshipNetwork = RelationshipNetwork.getInstance();
			var relationshipList:XMLList = network.children();
			var theCast:Cast = Cast.getInstance();
			relationshipNet.initialize(theCast.characters.length); // This seems to help eliminate some sporadic crashing.
			for each(var relationship:XML in relationshipList) {
					relationshipNet.setRelationship(RelationshipNetwork.getRelationshipNumberByName(relationship.@type), theCast.getCharByName(relationship.@from), theCast.getCharByName(relationship.@to));
			}
			//trace("ParseXML::relationshipNetworkParse Internal Representation: " + relationshipNet.toXMLString());
			//trace("ParseXML::relationshipoNetworkParse XML File: " + network);
		}	
		
		/*
		public static function addCharacter(myXML:XML):void {
			var newChar:Character = new Character();
			
			trace("making a new character");
			for each (var charXML:XML in myXML..Character) {
				
			}
		}
		*/
		
		/**
		 * This function takes an XMl object filled with a description of
		 * trigger rules and returns a vector of trigger class instantiations
		 * filled with the contents of the XML.
		 * @param	triggersXML	The trigger descriptions.
		 * @return	The Trigger class instantiations.
		 */
		public static function parseTriggers(triggersXML:XML):Vector.<Trigger> {
			var triggersVector:Vector.<Trigger> = new Vector.<Trigger>();
			var trigger:Trigger;
			var tIter:Trigger;
			var rule:Rule;
			var pred:Predicate;
			var maxID:int;
			
			//Debug.debug(ParseXML, "parseTriggers() about to parse triggers: " + triggersXML);
			for each(var triggerXML:XML in triggersXML..Trigger) {
				//Debug.debug(ParseXML, "parseTriggers() parsing trigger: " + triggerXML);
				trigger = new Trigger();
				trigger.id = (triggerXML.@id.toString())?triggerXML.@id: -1;
				//trigger.isAccept = triggerXML.@accept;
				trigger.referenceAsNaturalLanguage = triggerXML.PerformanceRealization;
				for each (var predXML:XML in triggerXML.ConditionRule..Predicate) {
					trigger.condition.predicates.push(predicateParse(predXML));
				}
				for each (predXML in triggerXML.ChangeRule..Predicate) {
					trigger.change.predicates.push(predicateParse(predXML));
				}
				
				trigger.condition.sortPredicates();
				trigger.change.sortPredicates();
				
				triggersVector.push(trigger);
				/*
				 * <Trigger id={this.id} accept={this.isAccept}>
								< PerformanceRealization > { this.referenceAsNaturalLanguage } </PerformanceRealization>
								<ConditionRule>{new XML(this.condition.toXMLString())}</ConditionRule>
								<ChangeRule>{new XML(this.change.toXMLString())}</ChangeRule>
							</Trigger>;
				*/
			}
			for each (trigger in triggersVector) {
				maxID = 0;
				if ( -1 == trigger.id) {
					for each (tIter in triggersVector) {
						if (maxID <= tIter.id) maxID = tIter.id + 1;
					}
					trigger.id = maxID;
				}
			}
		
			return triggersVector;
		}
		
		public static function parseSocialGame(sgXML:XML):SocialGame
		{
			var sg:SocialGame = new SocialGame();
			var sgLib:SocialGamesLib = SocialGamesLib.getInstance();
			var sfdbInstance:SocialFactsDB = SocialFactsDB.getInstance();
			var i:int;
			var ir:InfluenceRule;
			var irIter:InfluenceRule;
			var infrulXML:XML;
			var ruleXML:XML;
			var predXML:XML;
			var r:Rule;
			var rIter:Rule;
			var eIter:Effect;
			var maxID:int;
			var inst:Instantiation;
			var instIter:Instantiation;
			var effXML:XML;
			var e:Effect;
			var t:Trigger;
			

			sg = new SocialGame();
			//trace("so, just what is sgXML:\n" + sgXML);
			sg.name = sgXML.@name;
			sg.italic = (sgXML.@italic)?sgXML.@italic as Boolean:false;
			
			//load the triggers if this is the trigger game

			
			

			/* INTENTS */
			for each (ruleXML in sgXML.Intents..Rule) {
				r = ruleParse(ruleXML);
				sg.intents.push(r);
			}
			
			for each (r in sg.intents) {
				maxID = 0;
				if ( -1 == r.id) {
					for each (rIter in sg.intents) {
						if (maxID <= rIter.id) maxID = rIter.id + 1;
					}
					r.id = maxID;
				}
			}
			
			/* PATSY RULE */
			for each (ruleXML in sgXML.PatsyRule..Rule) {
				r = ruleParse(ruleXML);
				sg.patsyRule = r.clone();
			}
			
			/* PRECONDITIONS */
			i = 0;
			for each (ruleXML in sgXML.Preconditions..Rule) {
				r = ruleParse(ruleXML);
				sg.preconditions.push(r);
			}
			for each (r in sg.preconditions) {
				maxID = 0;
				if ( -1 == r.id) {
					for each (rIter in sg.preconditions) {
						if (maxID <= rIter.id) maxID = rIter.id + 1;
					}
					r.id = maxID;
				}
			}
			/* INITIATOR INFLUENCE RULE SET */
			i = 0;
			for each (infrulXML in sgXML.InitiatorInfluenceRuleSet..InfluenceRule) {
				ir = influenceRuleParse(infrulXML);
				sg.initiatorIRS.influenceRules.push(ir);
			}
			//assign new IDs to the influence rules that weren't assigned one.
			for each (ir in sg.initiatorIRS.influenceRules) {
				maxID = 0;
				if ( -1 == ir.id) {
					for each (irIter in sg.initiatorIRS.influenceRules) {
						if (maxID <= irIter.id) maxID = irIter.id + 1;
					}
					ir.id  = maxID;
				}
			}

			
			/* RESPONDER INFLUENCE RULE SET */
			for each (infrulXML in sgXML.ResponderInfluenceRuleSet..InfluenceRule) {
				ir = influenceRuleParse(infrulXML);
				sg.responderIRS.influenceRules.push(ir);
			}
			//assign new IDs to the influence rules that weren't assigned one.
			for each (ir in sg.responderIRS.influenceRules) {
				maxID = 0;
				if ( -1 == ir.id) {
					for each (irIter in sg.responderIRS.influenceRules) {
						if (maxID <= irIter.id) maxID = irIter.id + 1;
					}
					ir.id = maxID;
				}
			}
			
			/* EFFECTS */
			var index:Number = 0;
			for each (effXML in sgXML.Effects..Effect) {
				e = new Effect();
				
				//trace("\t\t making new effect");
				e.id = (effXML.@id.toString())?effXML.@id: -1;
				e.isAccept = ("true" == effXML.@accept) ? true : false;
				e.referenceAsNaturalLanguage = effXML.PerformanceRealization;
				
				/* uncomment the following 7 lines for converting old FDG XML states for use with current CiF states. */
				
				//if (effXML.@instantiationID) {
					//e.instantiationID = e.id;
					//Debug.debug(ParseXML, "parseSocialGame() parsing effect: effect ID used for instantiation ID: " + e.instantiationID);
				//}else {
				e.instantiationID = effXML.@instantiationID;
				//Debug.debug(ParseXML, "parseSocialGame() parsing effect: instantiation ID taken from XML: " + e.instantiationID);
				//}
				
				for each (predXML in effXML.ConditionRule..Predicate) {
					e.condition.predicates.push(predicateParse(predXML));
					//trace( predXML);
				}
				
				for each (predXML in effXML.ChangeRule..Predicate) {
					e.change.predicates.push(predicateParse(predXML));
				}

				++index;
				e.scoreSalience();
				sg.effects.push(e);
			}
			for each (e in sg.effects) {
				maxID = 0;
				if ( -1 == e.id) {
					for each (eIter in sg.effects) {
						if (maxID <= eIter.id) maxID = eIter.id + 1;
					}
					e.id = maxID;
				}
			}
			
			/* INSTANTIATIONS */
			for each (var instantXML:XML in sgXML.Instantiations..Instantiation) {					
				inst = new Instantiation();
				inst.id = (instantXML.@id.toString())?instantXML.@id:-1;
				inst.name = instantXML.@name;
				//trace("\t\t making new instantiation");
				
				if (instantXML.ToC1)
				{
					inst.toc1.rawString = new String(instantXML.ToC1);
				}
				else
				{
					inst.toc1.rawString = "";
				}
				if (instantXML.ToC2)
				{
					inst.toc2.rawString = new String(instantXML.ToC2);
				}
				else
				{
					inst.toc2.rawString = "";
				}
				if (instantXML.ToC3)
				{
					inst.toc3.rawString = new String(instantXML.ToC3);
				}
				else
				{
					inst.toc3.rawString = "";
				}
				
				for each (ruleXML in instantXML..ConditionalRules..Rule) {
					//Debug.debug(ParseXML, "addGameToLibrary() adding a conditional rule to an instantiation. rxml: " + ruleXML);
					inst.conditionalRules.push(ruleParse(ruleXML));
					
				}
				
				var line:LineOfDialogue;
				for each (var lineXML:XML in instantXML..LineOfDialogue) {
					line = new LineOfDialogue();
					//trace("\t\t\t" + lineXML.@lineNumber);
					line.lineNumber = lineXML.@lineNumber;
					line.initiatorLine = lineXML.@initiatorLine;
					line.responderLine = lineXML.@responderLine;
					line.otherLine = lineXML.@otherLine;
					line.primarySpeaker = lineXML.@primarySpeaker;
					//trace("\t\t\t" + lineXML.@initiatorBodyAnimation);
					line.initiatorBodyAnimation = lineXML.@initiatorBodyAnimation;
					//trace("\t\t\t" + lineXML.@initiatorFaceAnimation);
					line.initiatorFaceAnimation = lineXML.@initiatorFaceAnimation;
					line.initiatorFaceState = lineXML.@initiatorFaceState;
					//trace("\t\t\t" + lineXML.@responderBodyAnimation);
					line.responderBodyAnimation = lineXML.@responderBodyAnimation;
					//trace("\t\t\t" + lineXML.@responderFaceAnimation);
					line.responderFaceAnimation = lineXML.@responderFaceAnimation;
					line.responderFaceState = lineXML.@responderFaceState;
					//trace("\t\t\t" + lineXML.@otherBodyAnimation);
					line.otherBodyAnimation = lineXML.@otherBodyAnimation;
					//trace("\t\t\t" + lineXML.@otherFaceAnimation);
					line.otherFaceAnimation = lineXML.@otherFaceAnimation;
					line.otherFaceState = lineXML.@otherFaceState;
					//trace("\t\t\t" + lineXML.@time);
					line.time = lineXML.@time;
					
					//lineXML.@initiatorIsXXXX returns a string -- strings
					//are true as long as they are not empty -- therefore
					//need to do an actual test of the value of the string
					//to assign the boolean variable correctly.
					if (lineXML.@initiatorIsThought == "true") line.initiatorIsThought = true; else line.initiatorIsThought = false;
					if (lineXML.@responderIsThought == "true") line.responderIsThought = true; else line.responderIsThought = false;
					if (lineXML.@otherIsThought == "true") line.otherIsThought = true; else line.otherIsThought = false;
					if (lineXML.@initiatorIsDelayed == "true") line.initiatorIsDelayed = true; else line.initiatorIsDelayed = false;
					if (lineXML.@responderIsDelayed == "true") line.responderIsDelayed = true; else line.responderIsDelayed = false;
					if (lineXML.@otherIsDelayed == "true") line.otherIsDelayed = true; else line.otherIsDelayed = false;
					if (lineXML.@initiatorIsPicture == "true") line.initiatorIsPicture = true; else line.initiatorIsPicture = false;
					if (lineXML.@responderIsPicture == "true") line.responderIsPicture = true; else line.responderIsPicture = false;
					if (lineXML.@otherIsPicture == "true") line.otherIsPicture = true; else line.otherIsPicture = false;
					
					line.initiatorAddressing = lineXML.@initiatorAddressing;
					line.responderAddressing = lineXML.@responderAddressing;
					line.otherAddressing = lineXML.@otherAddressing;
					
					//for each(var partialRule:XML in lineXML..Rule)
					//{
						//line.partialChange = ruleParse(partialRule);
					//}
					
					var ruleXML1:XML;
					for each(var partialRule:XML in lineXML..PartialChange)
					{
						for each (ruleXML1 in partialRule..Rule)
						{
							line.partialChange = ruleParse(ruleXML1);
						}
					}
					
					for each(var chorusRule:XML in lineXML..ChorusRule)
					{
						for each (ruleXML1 in chorusRule..Rule)
						{
							line.chorusRule = ruleParse(ruleXML1);
						}
					}
					
					
					//lineXML.@isOtherChorus returns a string, so just as
					//above, will need to be converted to a bool explicitly.
					if (lineXML.@isOtherChorus == "true") line.isOtherChorus = true; else line.isOtherChorus = false;
					if (lineXML.@otherApproach == "true") line.otherApproach = true; else line.otherApproach = false;
					if (lineXML.@otherExit == "true") line.otherExit = true; else line.otherExit = false;
					
					inst.lines.push(line);
				}
				sg.instantiations.push(inst);
				for each (inst in sg.instantiations) {
					maxID = 0;
					if ( -1 == inst.id) {
						for each (instIter in sg.instantiations) {
							if (maxID <= instIter.id) maxID = instIter.id + 1;
						}
						inst.id = maxID;
					}
				}
			}

			var iteratorRule:Rule;
			//before saving, sort all the predicates in all rules

			for each (iteratorRule in sg.initiatorIRS.influenceRules)
			{
				iteratorRule.sortPredicates();
			}
			for each (iteratorRule in sg.responderIRS.influenceRules)
			{
				iteratorRule.sortPredicates();
			}
			
			for each (var effect:Effect in sg.effects)
			{
				effect.condition.sortPredicates();
				effect.change.sortPredicates();
			}

			return sg;
			//sgLib.games.push(sg);

		}
		
		/*
		 * addGameToLibrary takes in an XML formatted version of ALL SOCIAL GAMES, it appears, parses it to fill in 
		 * instantiations of SocialGame, and adds each one to the social game library.  Therefore, perhaps a more 
		 * accurate name would be addGamesToLibrary (plural).
		 * */
		public static function addGameToLibrary(myXML:XML):void
		{
			var sg:SocialGame = new SocialGame();
			var sgLib:SocialGamesLib = SocialGamesLib.getInstance();
			var sfdbInstance:SocialFactsDB = SocialFactsDB.getInstance();
			var i:int;
			var ir:InfluenceRule;
			var irIter:InfluenceRule;
			var infrulXML:XML;
			var ruleXML:XML;
			var predXML:XML;
			var r:Rule;
			var rIter:Rule;
			var eIter:Effect;
			var maxID:int;
			var inst:Instantiation;
			var instIter:Instantiation;
			var effXML:XML;
			var e:Effect;
			var t:Trigger;
			var socialStatusUpdateEntry:SocialStatusUpdateEntry;
			
			for each (var sgXML:XML in myXML..SocialGame) {
				
				sg = ParseXML.parseSocialGame(sgXML);
				
				
				if (sg.name == "TriggerGame" || sg.name == "TriggerGameAllChars")
				{
					/* TRIGGERS */
					for each (effXML in sgXML.Effects..Effect) {
						t = new Trigger();
						
						//trace("\t\t making new effect");
						t.id = (effXML.@id.toString())?effXML.@id: -1;
						//e.isAccept = ("true" == effXML.@accept) ? true : false;
						t.referenceAsNaturalLanguage = effXML.PerformanceRealization;
						
						
						for each (predXML in effXML.ConditionRule..Predicate) {
							t.condition.predicates.push(predicateParse(predXML));
							//trace( predXML);
						}
						
						for each (predXML in effXML.ChangeRule..Predicate) {
							t.change.predicates.push(predicateParse(predXML));
						}
						
						if (sg.name == "TriggerGameAllChars")
						{
							t.useAllChars = true;
						}
						else
						{
							t.useAllChars = false;
						}
						
						sfdbInstance.triggers.push(t);
					}
					for each (t in sfdbInstance.triggers) {
						maxID = 0;
						if ( -1 == t.id) {
							for each (eIter in sg.effects) {
								if (maxID <= eIter.id) maxID = eIter.id + 1;
							}
							t.id = maxID;
						}
					}
					//Check to see if we are working in a context where Trigger games should
					//still be inserted into the file (such as with the design tool)
					if (CiFSingleton.getInstance().shouldTriggerGamesBeIncludedInSocialGames) {
						sgLib.addGame(sg);
					}
				}
				else if (sg.name == "StoryTriggerGame")
				{
					/* STORY TRIGGERS */
					for each (effXML in sgXML.Effects..Effect) {
						t = new Trigger();
						
						//trace("\t\t making new effect");
						t.id = (effXML.@id.toString())?effXML.@id: -1;
						//e.isAccept = ("true" == effXML.@accept) ? true : false;
						t.referenceAsNaturalLanguage = effXML.PerformanceRealization;
						
						
						for each (predXML in effXML.ConditionRule..Predicate) {
							t.condition.predicates.push(predicateParse(predXML));
							//trace( predXML);
						}
						
						for each (predXML in effXML.ChangeRule..Predicate) {
							t.change.predicates.push(predicateParse(predXML));
						}
						sfdbInstance.storyTriggers.push(t);
					}
					for each (t in sfdbInstance.storyTriggers) {
						maxID = 0;
						if ( -1 == t.id) {
							for each (eIter in sg.effects) {
								if (maxID <= eIter.id) maxID = eIter.id + 1;
							}
							t.id = maxID;
						}
					}
					//Check to see if we are working in a context where Trigger games should
					//still be inserted into the file (such as with the design tool)
					if (CiFSingleton.getInstance().shouldTriggerGamesBeIncludedInSocialGames) {
						//sgLib.games.push(sg);
						sgLib.addGame(sg);
					}
				}
				else if (sg.name == "SocialStatusUpdateGame")
				{
					for each (var ir1:InfluenceRule in sg.initiatorIRS.influenceRules)
					{
						socialStatusUpdateEntry = new SocialStatusUpdateEntry();
						socialStatusUpdateEntry.condition = ir1 as Rule;
						socialStatusUpdateEntry.originalTemplateString = ir1.name;
						socialStatusUpdateEntry.locutions = Util.createLocutionVectors(ir1.name);
						socialStatusUpdateEntry.scoreSalience();
						CiFSingleton.getInstance().socialStatusUpdates.push(socialStatusUpdateEntry);
					}
					function sortSSUVector(x:SocialStatusUpdateEntry, y:SocialStatusUpdateEntry):Number 
					{
						if (x.salienceScore > y.salienceScore)
						{
							return 1.0;
						}
						else if (x.salienceScore < y.salienceScore)
						{
							return -1.0;
						}
						else
						{
							return 0;
						}
					}
					CiFSingleton.getInstance().socialStatusUpdates.sort(sortSSUVector);
					//Check to see if we are working in a context where Trigger games should
					//still be inserted into the file (such as with the design tool)
					if (CiFSingleton.getInstance().shouldTriggerGamesBeIncludedInSocialGames) {
						//sgLib.games.push(sg);
						sgLib.addGame(sg);
					}
				}
				else if (sg.name == "SocialStatusUpdateGameNotInLevel")
				{
					for each (var ir2:InfluenceRule in sg.initiatorIRS.influenceRules)
					{
						socialStatusUpdateEntry = new SocialStatusUpdateEntry();
						socialStatusUpdateEntry.condition = ir2 as Rule;
						socialStatusUpdateEntry.originalTemplateString = ir2.name;
						socialStatusUpdateEntry.locutions = Util.createLocutionVectors(ir2.name);
						socialStatusUpdateEntry.scoreSalience();
						CiFSingleton.getInstance().socialStatusUpdatesNotInLevel.push(socialStatusUpdateEntry);
					}
					function sortSSUVector1(x:SocialStatusUpdateEntry, y:SocialStatusUpdateEntry):Number 
					{
						if (x.salienceScore > y.salienceScore)
						{
							return 1.0;
						}
						else if (x.salienceScore < y.salienceScore)
						{
							return -1.0;
						}
						else
						{
							return 0;
						}
					}
					CiFSingleton.getInstance().socialStatusUpdatesNotInLevel.sort(sortSSUVector1);
					//Check to see if we are working in a context where Trigger games should
					//still be inserted into the file (such as with the design tool)
					if (CiFSingleton.getInstance().shouldTriggerGamesBeIncludedInSocialGames) {
						//sgLib.games.push(sg);
						sgLib.addGame(sg);
					}
					
				}
				else
				{
					//work around to deal with the accidental creation of blank social games
					if (sg.name != "Game Name" && (sg.instantiations.length > 0 ))
					{	
						// this is the normal case where we just add the SG
						sgLib.addGame(sg);
					}
				}
			}
		}
		
		
		public static function parseInstantiation(instantXML:XML):Instantiation
		{
			var inst:Instantiation = new Instantiation();
			var ruleXML:XML;
			
			inst.id = (instantXML.@id.toString())?instantXML.@id:-1;
			inst.name = instantXML.@name;
			//trace("\t\t making new instantiation");
			
			if (instantXML.ToC1)
			{
				inst.toc1.rawString = new String(instantXML.ToC1);
			}
			else
			{
				inst.toc1.rawString = "";
			}
			if (instantXML.ToC2)
			{
				inst.toc2.rawString = new String(instantXML.ToC2);
			}
			else
			{
				inst.toc2.rawString = "";
			}
			if (instantXML.ToC3)
			{
				inst.toc3.rawString = new String(instantXML.ToC3);
			}
			else
			{
				inst.toc3.rawString = "";
			}
			
			for each (ruleXML in instantXML..ConditionalRules..Rule) {
				//Debug.debug(ParseXML, "addGameToLibrary() adding a conditional rule to an instantiation. rxml: " + ruleXML);
				inst.conditionalRules.push(ruleParse(ruleXML));
				
			}
			
			var line:LineOfDialogue;
			for each (var lineXML:XML in instantXML..LineOfDialogue) {
				line = new LineOfDialogue();
				//trace("\t\t\t" + lineXML.@lineNumber);
				line.lineNumber = lineXML.@lineNumber;
				line.initiatorLine = lineXML.@initiatorLine;
				line.responderLine = lineXML.@responderLine;
				line.otherLine = lineXML.@otherLine;
				line.primarySpeaker = lineXML.@primarySpeaker;
				//trace("\t\t\t" + lineXML.@initiatorBodyAnimation);
				line.initiatorBodyAnimation = lineXML.@initiatorBodyAnimation;
				//trace("\t\t\t" + lineXML.@initiatorFaceAnimation);
				line.initiatorFaceAnimation = lineXML.@initiatorFaceAnimation;
				line.initiatorFaceState = lineXML.@initiatorFaceState;
				//trace("\t\t\t" + lineXML.@responderBodyAnimation);
				line.responderBodyAnimation = lineXML.@responderBodyAnimation;
				//trace("\t\t\t" + lineXML.@responderFaceAnimation);
				line.responderFaceAnimation = lineXML.@responderFaceAnimation;
				line.responderFaceState = lineXML.@responderFaceState;
				//trace("\t\t\t" + lineXML.@otherBodyAnimation);
				line.otherBodyAnimation = lineXML.@otherBodyAnimation;
				//trace("\t\t\t" + lineXML.@otherFaceAnimation);
				line.otherFaceAnimation = lineXML.@otherFaceAnimation;
				line.otherFaceState = lineXML.@otherFaceState;
				//trace("\t\t\t" + lineXML.@time);
				line.time = lineXML.@time;
				
				//lineXML.@initiatorIsXXXX returns a string -- strings
				//are true as long as they are not empty -- therefore
				//need to do an actual test of the value of the string
				//to assign the boolean variable correctly.
				if (lineXML.@initiatorIsThought == "true") line.initiatorIsThought = true; else line.initiatorIsThought = false;
				if (lineXML.@responderIsThought == "true") line.responderIsThought = true; else line.responderIsThought = false;
				if (lineXML.@otherIsThought == "true") line.otherIsThought = true; else line.otherIsThought = false;
				if (lineXML.@initiatorIsDelayed == "true") line.initiatorIsDelayed = true; else line.initiatorIsDelayed = false;
				if (lineXML.@responderIsDelayed == "true") line.responderIsDelayed = true; else line.responderIsDelayed = false;
				if (lineXML.@otherIsDelayed == "true") line.otherIsDelayed = true; else line.otherIsDelayed = false;
				if (lineXML.@initiatorIsPicture == "true") line.initiatorIsPicture = true; else line.initiatorIsPicture = false;
				if (lineXML.@responderIsPicture == "true") line.responderIsPicture = true; else line.responderIsPicture = false;
				if (lineXML.@otherIsPicture == "true") line.otherIsPicture = true; else line.otherIsPicture = false;
				
				line.initiatorAddressing = lineXML.@initiatorAddressing;
				line.responderAddressing = lineXML.@responderAddressing;
				line.otherAddressing = lineXML.@otherAddressing;
				
				if (lineXML.@isOtherChorus == "true") line.isOtherChorus = true; else line.isOtherChorus = false;
				if (lineXML.@otherApproach == "true") line.otherApproach = true; else line.otherApproach = false;
				if (lineXML.@otherExit == "true") line.otherExit = true; else line.otherExit = false;
				
				var ruleXML1:XML;
				for each(var partialRule:XML in lineXML..PartialChange)
				{
					for each (ruleXML1 in partialRule..Rule)
					{
						line.partialChange = ruleParse(ruleXML1);
					}
				}
				
				for each(var chorusRule:XML in lineXML..ChorusRule)
				{
					for each (ruleXML1 in chorusRule..Rule)
					{
						line.chorusRule = ruleParse(ruleXML1);
					}
				}
				
				//lineXML.@isOtherChorus returns a string, so just as
				//above, will need to be converted to a bool explicitly.
				if (lineXML.@isOtherChorus == "true") line.isOtherChorus = true; else line.isOtherChorus = false;
				
				inst.lines.push(line);
			}
			
			return inst;
		}
		
		/**
		 * loadXML pushes the CulturalKB information for both Subjective and Truth propositions
		 * @param	myXML
		 * @see CiF.Proposition
		 * 
		 */
		public static function loadCKBXML(myXML:XML): void {
			var ckb:CulturalKB = CulturalKB.getInstance();
			for each (var prop:XML in myXML..Proposition) {
				var p:Proposition = new Proposition;
				p.type = prop.@type;
				p.head = prop.@head;
				p.connection = prop.@connection;
				p.tail = prop.@tail;
				if (p.type == "truth") {
				   ckb.propsTruth.push(p);
				}else {
				   ckb.propsSubjective.push(p);
				}
			}
		}		
		
		//Ultimately this will be some cool thing that reads in well-formatted XML from Java/Scala town.  For now,
		//it is just a hard coded string.
		public static function getScript():String {
			//This will in reality be talking with the Scala AI side of things to get a well-formated XML string of all
			//of the dialogue of a social game.  However, for now, it is just hard coded.
			return "<SCRIPT><DIALOGUE lineNum='0' name='Karen' line='Hey Edward.' Animation='talk' time='2' /><DIALOGUE lineNum='1' name='Edward' line='Yeah Karen?' Animation='talk' time='2' /><DIALOGUE lineNum='2' name='Karen' line='If I could be reborn into anything in the world, it would be a tear drop... so I could be born in your eyes, live life on your cheek, and die on your lips.' Animation='happytalk' time='8' />" +
			"<DIALOGUE lineNum='3' name='Edward' line='Ohhh, that`s so sweet!' Animation='blush' time='4' /><DIALOGUE lineNum='4' name='Karen' line='Edward, will you be my main squeeze?' Animation='tickle' time='5' /><DIALOGUE lineNum='5' name='Edward' line='Oh Karen! Yes, yes, a thousand times yes!' Animation='blush' time='5' /></SCRIPT>";
		}
		
		public static function getState():String {
			//This will in reality be talking with the Scala AI side of things to get a well-formated XML string of all
			//of the dialogue of a social game.  However, for now, it is just hard coded.
			
			return "<GAME_UPDATE><CHARACTER name='Edward'><GAME rank='1' name='SC_Dating' target='Lily' change='RomanceUp' value='40' /><GAME rank='2' name='SC_Dating' target='Bruce' change='RomanceUp' value='100' /></CHARACTER><CHARACTER name='Karen'><GAME rank='3' name='SC_Friend' target='Lily' change='RelationshipUp' value='80' />" +
			"</CHARACTER><NETWORK name='Romance'><NODE from='Edward' to='Lily' value='70' /></NETWORK><SOCIAL_STATUS name='Dating'><NODE from='Edward' to='Lily' value='true' /></SOCIAL_STATUS></GAME_UPDATE>";
			//WORKS GREAT
			
			//return "<GAME_UPDATE><CHARACTER name='Edward'><GAME rank='1' name='SC_Dating' target='Lily' change='RomanceUp' value='40' /></CHARACTER><NETWORK name='Romance'><NODE from='Edward' to='Lily' value='70' /></NETWORK><SOCIAL_STATUS name='Dating'><NODE from='Edward' to='Lily' value='true' /></SOCIAL_STATUS></GAME_UPDATE>";
		}
		
		//Given a string (probably received from getScript() ) of XML, break it up into it's component parts
		//so that we can have our way with it.
		public static function parseScript(inputString:String):void {
			var mainXML:XML;
			try {
				mainXML = new XML(inputString);
			} catch (e:Error)
			{
				trace("Error: " + e.message)
				return;
			}

			var lineNums:XMLList = mainXML.DIALOGUE.@lineNum;
			var names:XMLList = mainXML.DIALOGUE.@name;
			var lines:XMLList = mainXML.DIALOGUE.@line;
			var animations:XMLList = mainXML.DIALOGUE.@Animation;
			var times:XMLList = mainXML.DIALOGUE.@time;
			var length:int = lineNums.length();
			for (var i:int = 0; i < length; i++) {
				trace(lineNums[i] + " " + names[i] + " says: " + lines[i] + " while doing: " + animations[i] + " for " + times[i] + " seconds");
			}
		}
		
		//Given a string (probably received from getState() ) of XML, break it up into it's component parts
		//so that we can have our way with it.
		public static function parseState(inputString:String):void {
			var mainXML:XML;
			try {
				mainXML = new XML(inputString);
			} catch (e:Error)
			{
				trace("Error: " + e.message)
				return;
			}
			//trace(mainXML);
			
			
			
			var characters:XMLList = mainXML.CHARACTER.@name;
			var networks:XMLList = mainXML.NETWORK.@name;
			var socialStatus:XMLList = mainXML.SOCIAL_STATUS.@name;
			
			var socialGameRanks:XMLList = mainXML.CHARACTER.GAME.@rank;
			trace("what is social games rank?" + socialGameRanks);
			

			var numChars:int = characters.length();
			var numNetworks:int = networks.length();
			var numSocialStatus:int = socialStatus.length();
			trace("number of characters is: " + numChars);
			for (var i:int = 0; i < numChars; i++) {
				//trace(lineNums[i] + " " + names[i] + " says: " + lines[i] + " while doing: " + animations[i] + " for " + times[i] + " seconds");
				
				var tempList:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@rank;
				var tempList2:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@name;
				var tempList3:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@target;
				var tempList4:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@change;
				var tempList5:XMLList = mainXML.CHARACTER.(@name == characters[i]).GAME.@value;
				trace(characters[i] + " Feels this way about games: ");
				for (var j:int = 0; j < tempList.length(); j++) {
					trace("rank:" + tempList[j] + " name:" + tempList2[j] + " target:" + tempList3[j] + " change:" + tempList4[j] + " value:" + tempList5[j]);
				}				
			}
			trace("number of networks is: " + numNetworks);
			for (i = 0; i < numNetworks; i++) {
				var tempList6:XMLList = mainXML.NETWORK.(@name == networks[i]).NODE.@from;
				var tempList7:XMLList = mainXML.NETWORK.(@name == networks[i]).NODE.@to;
				var tempList8:XMLList = mainXML.NETWORK.(@name == networks[i]).NODE.@value;
				trace(networks[i] + " looks like this: ");
				for (j = 0; j < tempList.length(); j++) {
					trace("from " + tempList6[j] + " to " + tempList7[j] + " value " + tempList8[j]);
				}
			}
			
			trace("number of social status is: " + numSocialStatus);
			for (i = 0; i < numSocialStatus; i++) {
				var tempList9:XMLList = mainXML.SOCIAL_STATUS.(@name == socialStatus[i]).NODE.@from;
				var tempList10:XMLList = mainXML.SOCIAL_STATUS.(@name == socialStatus[i]).NODE.@to;
				var tempList11:XMLList = mainXML.SOCIAL_STATUS.(@name == socialStatus[i]).NODE.@value;
				trace(socialStatus[i] + " looks like this: ");
				for (j = 0; j < tempList.length(); j++) {
					trace("from " + tempList9[j] + " to " + tempList10[j] + " value " + tempList11[j]);
				}
			}
		}
	}

}