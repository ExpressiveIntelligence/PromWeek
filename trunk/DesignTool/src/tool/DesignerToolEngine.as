package tool 
{
	import CiF.*;
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	//import avmplus.DescribeType;
	/**
	 * The DesignerToolEngine class is the model and heart of the design tool.
	 * It is where the acutal modification to the game/social state happen and 
	 * is where the canonical version of the state resides. All major data
	 * changes should happen in this class; classes or components that show the
	 * user's intent to change the data should call a member of this class and
	 * let the class perform the update.
	 *
	 * 
	 */
	[Bindable]
	public final class DesignerToolEngine
	{
		private static var _instance:DesignerToolEngine = new DesignerToolEngine();
		
		public var cif:CiFSingleton;
		
		// Indecies
		public var preconditionAuthoringIndex:int;
		
		//Boolean flags
		public var tabAndAccordianLinkBoxValue:Boolean;
		
		//data provider for the list of games in the social games library
		public var gameNamesDP:ArrayCollection;
		
		//data provider for the list of microtheories in the microtheories library
		public var microtheoryNamesDP:ArrayCollection;
		
		public var workingMicrotheory:Microtheory = new Microtheory();
		
		//data providers that are relatively constant
		public var predTypes:ArrayCollection; // list of available predicates
		public var traitTypes:ArrayCollection; // list of available traits
		public var relationTypes:ArrayCollection; // list of available relationships
		public var statusTypes:ArrayCollection; // list of available statuses (statii)
		public var ckbTruthTypes:ArrayCollection; // list of available ckb truth types
		public var ckbSubjectiveTypes:ArrayCollection; // list of available ckb subjective types
		public var sfdbLabels:ArrayCollection; // list of available sfdb labels
		public var networkTypes:ArrayCollection; // list of available networks
		public var networkComparatorTypes:ArrayCollection; //list of network comparators
		public var networkOperatorTypes:ArrayCollection; //list of network operators for valuation
		public var roleTypes:ArrayCollection; //list of character roles
		public var predicateEdPredicatesList:ArrayCollection; //What fills in the right hand side with content
		public var bodyAnimationList:ArrayCollection; //list of all possible body animations for performance authoring tab.
		public var faceAnimationList:ArrayCollection; //list of all possible face animations for performance authoring tab.
		
		//data providers that change often via user interaction
		public var workingPreconditionRuleDP:ArrayCollection; //list of character roles
		
		public var microtheoryDefinitionPRDP:ArrayCollection;
		public var microtheoryInitiatorIRSDP:ArrayCollection;
		public var microtheoryResponderIRSDP:ArrayCollection;
			
		public var initiatorIRSDP:ArrayCollection;
		public var responderIRSDP:ArrayCollection; 
		
		public var intentPRDP:ArrayCollection;
		public var preconditionPRDP:ArrayCollection;
		public var effectEADP:ArrayCollection;
		public var instantiationDP:ArrayCollection;
		public var instantiationIDandNamesDP:ArrayCollection;
		//public var instantiationConditionalRuleDP:ArrayCollection;
		
		public var workingPreconditionRule:Rule = new Rule();
		public var workingInitiatorIR:InfluenceRule = new InfluenceRule();
		public var workingResponderIR:InfluenceRule = new InfluenceRule();
		public var workingEffect:Effect = new Effect();
		public var workingInstantiation:Instantiation = new Instantiation();
		public var workingSocialGame:SocialGame = new SocialGame();
		
		public function DesignerToolEngine(){
			if (_instance != null) {
				throw new Error("DesignerToolEngine can only be accessed through DesignerToolEngine.getInstance()");
			}
			this.cif = CiFSingleton.getInstance();
			this.cif.defaultState();
			this.tabAndAccordianLinkBoxValue = true;
		}
		
		public static function getInstance():DesignerToolEngine {
			return _instance;
		}
	
		/**********************************************************************
		 * Property synonyms and convenience properties.
		 *********************************************************************/
		//public function get roleTypes():ArrayCollection { return this.roleList; }

		//{ Generate Raw Data Providers
		/**
		 * Updates all of the DTE's array collections that are data providers
		 * component elements like drop down lists that do not often change. */
		public function initializeDataProviders():void {
			Debug.debug(this, "initialize data providers inside of DTE");
			this.gameNamesDP = this.generateGameNamesDP();
			
			this.microtheoryNamesDP = this.generateMicrotheoryNamesDP();
			
			this.predTypes = this.generatePredListProvider();
			//Debug.debug(this, this.predTypes.toString());
			this.traitTypes = this.generateTraitTypeListProvider();
			this.relationTypes = this.generateRelationListProvider();
			this.statusTypes = this.generateStatusListProvider();
			this.ckbSubjectiveTypes = this.generateCKBSubjectiveListProvider();
			this.ckbTruthTypes = this.generateCKBTruthListProvider();
			this.sfdbLabels = this.generateSFDBLabelListProvider();
			this.networkTypes = this.generateNetworkListProvider();
			this.networkComparatorTypes = this.generateNetworkComparatorListProvider();
			this.networkOperatorTypes = this.generateNetworkOperatorListProvider();
			this.bodyAnimationList = this.generateBodyAnimationListProvider();
			this.faceAnimationList = this.generateFaceAnimationListProvider();
			
			this.roleTypes= this.generateRoleListProvider();
			
			this.intentPRDP = this.generateIntentPRDP();
			this.preconditionPRDP = this.generatePreconditionPRDP();
			this.initiatorIRSDP = this.generateInitiatorIRSDP();
			this.responderIRSDP = this.generateResponderIRSDP();
			
			this.microtheoryDefinitionPRDP = this.generateMicrotheoryDefinitionPRDP();
			this.microtheoryInitiatorIRSDP = this.generateMicrotheoryInitiatorIRSDP();
			this.microtheoryResponderIRSDP = this.generateMicrotheoryResponderIRSDP();
			
			
			this.effectEADP = this.generateEffectEADP();
			this.instantiationDP = this.generateInstantiationDP();
			this.instantiationIDandNamesDP = this.generateInstantiationIDandNames();
			//this.instantiationConditionalRuleDP = this.generateInstantiationConditionalRuleDP();
		}

		public function generateInstantiationIDandNames():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			
			for each (var instantiation:Instantiation in this.workingSocialGame.instantiations) {
				result.addItem(instantiation.id + " " + instantiation.name);
				//Debug.debug(this, "generateGameNamesDP(): game name " + game.name);
			}
			return result;
		}
		
		public function generateGameNamesDP():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var game:SocialGame in this.cif.socialGamesLib.games) {
				result.addItem(game.name);
				//Debug.debug(this, "generateGameNamesDP(): game name " + game.name);
			}
			return result;
		}
		
		public function generateMicrotheoryNamesDP():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var microtheory:Microtheory in this.cif.microtheories) {
				result.addItem(microtheory.name);
				//Debug.debug(this, "generateGameNamesDP(): game name " + game.name);
			}
			return result;
		}

		
		public function generateIntentPRDP(value:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var intentRule:Rule in this.workingSocialGame.intents) {
				if (value) result.addItem(intentRule.name);
				else result.addItem(intentRule.toString());
			}
			return result;
		}
		
		/*
		public function generatePreconditionPRDP(value:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var preconRule:Rule in this.workingSocialGame.preconditions) {
				if (value) result.addItem(preconRule.name);
				else result.addItem(preconRule.toString());
			}
			return result;
		}
		*/
		
		public function generatePreconditionPRDP(straight:Boolean = false, handAuthored:Boolean = false, generated:Boolean = false, mismatches:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			
			var mismatchTest:String = "";
			for each (var preconRule:Rule in this.workingSocialGame.preconditions) {	
				
				if (preconRule.generatedName == null) { // if generated name hasn't been generated yet...
					preconRule.generateRuleName(); // technically this is returning a string, but this is ALSO filling in a very important property!
				}
				if (preconRule.name != preconRule.generatedName && mismatches) mismatchTest = "···";
				
				if (handAuthored) result.addItem(mismatchTest + preconRule.name);
				else if (generated) result.addItem(mismatchTest + preconRule.generateRuleName());
				else result.addItem(mismatchTest + preconRule.toString());
				
				mismatchTest = "";
			}
			return result;
		}
		
		/*
		public function generateInitiatorIRSDP(value:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var ir:InfluenceRule in this.workingSocialGame.initiatorIRS.influenceRules) {
				if (value) result.addItem(ir.weight + ": " + ir.name);
				else result.addItem(ir.toString());
			}
			return result;
		}
		*/
		
		public function generateInitiatorIRSDP(straight:Boolean = false, handAuthored:Boolean = false, generated:Boolean = false, mismatches:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			var mismatchTest:String = "";
			for each (var ir:InfluenceRule in this.workingSocialGame.initiatorIRS.influenceRules) {

				if (ir.generatedName == null) { // if generated name hasn't been generated yet...
					ir.generateRuleName(); // technically this is returning a string, but this is ALSO filling in a very important property!
				}
				if (ir.name != ir.generatedName && mismatches) mismatchTest = "···";
				//if (ir.isGeneratedRuleEqualToName() && mismatches) mismatchTest = "···";
				
				if (handAuthored) result.addItem(mismatchTest + ir.weight + ": " + ir.name);
				else if (generated) result.addItem(mismatchTest + ir.weight + ": " + ir.generateRuleName());
				else result.addItem(mismatchTest + ir.toString());
				
				mismatchTest = "";
			}
			return result;
		}
		
		/*
		public function generateResponderIRSDP(value:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var ir:InfluenceRule in this.workingSocialGame.responderIRS.influenceRules) {
				if (value) result.addItem(ir.weight + ": " + ir.name);
				else result.addItem(ir.toString());
			}
			return result;
		}
		*/
		
		public function generateResponderIRSDP(straight:Boolean = false, handAuthored:Boolean = false, generated:Boolean = false, mismatches:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			var mismatchTest:String = "";
			
			for each (var ir:InfluenceRule in this.workingSocialGame.responderIRS.influenceRules) {
				
				if (ir.generatedName == null) { // if generated name hasn't been generated yet...
					ir.generateRuleName(); // technically this is returning a string, but this is ALSO filling in a very important property!
				}
				if (ir.name != ir.generatedName && mismatches) mismatchTest = "···";
				
				if (handAuthored) result.addItem(mismatchTest + ir.weight + ": " + ir.name);
				else if (generated) result.addItem(mismatchTest + ir.weight + ": " + ir.generateRuleName());
				else result.addItem(mismatchTest + ir.toString());
				
				mismatchTest = "";
			}
			return result;
		}
		
		
		
		public function generateMicrotheoryDefinitionPRDP(value:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			if (this.workingMicrotheory.definition != null) {
				if (value) result.addItem(this.workingMicrotheory.definition.name);
				else result.addItem(this.workingMicrotheory.definition);
			}
			return result;
		}
		
		/*
		public function generateMicrotheoryInitiatorIRSDP(value:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var ir:InfluenceRule in this.workingMicrotheory.initiatorIRS.influenceRules) {
				if (value) result.addItem(ir.weight + ": " + ir.name);
				else result.addItem(ir.toString());
			}
			return result;
		}
		*/
		
		public function generateMicrotheoryInitiatorIRSDP(straightRule:Boolean = false, handAuthored:Boolean = false, generatedRule:Boolean = false, mismatches:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			var mismatchTest:String = "";
			for each (var ir:InfluenceRule in this.workingMicrotheory.initiatorIRS.influenceRules) {
				if (ir.generatedName == null) { // if generated name hasn't been generated yet...
					ir.generateRuleName(); // technically this is returning a string, but this is ALSO filling in a very important property!
				}
				if (ir.name != ir.generatedName && mismatches) mismatchTest = "···";
				
				if (generatedRule) result.addItem(mismatchTest + ir.weight + ": " + ir.generateRuleName());
				else if (handAuthored) result.addItem(mismatchTest + ir.weight + ": " + ir.name);
				else result.addItem(mismatchTest + ir.toString()); //straight rule -- default
				
				mismatchTest = "";
			}
			return result;
		}
		
		/*
		public function generateMicrotheoryResponderIRSDP(value:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var ir:InfluenceRule in this.workingMicrotheory.responderIRS.influenceRules) {
				if (value) result.addItem(ir.weight + ": " + ir.name);
				else result.addItem(ir.toString());
			}
			return result;
		}
		*/
		
		public function generateMicrotheoryResponderIRSDP(straightRule:Boolean = false, handAuthored:Boolean = false, generatedRule:Boolean = false, mismatches:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			var mismatchTest:String = "";
			for each (var ir:InfluenceRule in this.workingMicrotheory.responderIRS.influenceRules) {
				if (ir.name != ir.generatedName && mismatches) mismatchTest = "···";
				
				if (handAuthored) result.addItem(mismatchTest + ir.weight + ": " + ir.name);
				else if (generatedRule) result.addItem(mismatchTest + ir.weight + ": " + ir.generateRuleName());
				else result.addItem(mismatchTest + ir.toString());
				mismatchTest = "";
			}
			return result;
		}
		
		
		public function generateInstantiationDP(value:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var instan:Instantiation in this.workingSocialGame.instantiations) {
				if (value) {
					result.addItem(instan.id + ": " + instan.name);
				} else {
					var lineResult:String = instan.id + ": ";
					for each (var line:LineOfDialogue in instan.lines) {
						lineResult += lineOfDialogToListString(line) + " |*| ";
					}
					result.addItem(lineResult);
				}
			}
			return result;
		}
		
		//public function generateInstantiationConditionalRuleDP(value:Boolean = false):ArrayCollection {
			//var result:ArrayCollection = new ArrayCollection;
			//for each (var r:Rule in this.workingInstantiation.conditionalRules) {
				//if (value) result.addItem(ir.weight + ": " + ir.name);
				//else result.addItem(ir.toString());
			//}
			//return result;
		//}
		
		/**
		 * Data Provider for Effect Authoring Box in Game Summary
		 * 
		 * @param	value
		 * @return
		 */
		public function generateEffectEADP(value:Boolean = false):ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for each (var ea:Effect in this.workingSocialGame.effects) {
				if (!value) result.addItem("Linked to " + ea.instantiationID + ":" + ((ea.isAccept)?" Accept: ":" Reject: ") + ea.condition.toString() + " => " + ea.change.toString());
				else result.addItem(ea.referenceAsNaturalLanguage);
				//Debug.debug(this, "generateEffectEADP() effect's instantiation ID: " + ea.instantiationID);
			}
			return result;
		}
		
		public function generateWorkingPreconditionRuleDP():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:Number = 0; i < this.workingPreconditionRule.predicates.length; ++i) {
				result.addItem(this.workingPreconditionRule.predicates[i].toString());
			}
			return result;
		}
		
		public function generateTraitTypeListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < Trait.TRAIT_COUNT; ++i) {
				result.addItem(Trait.getNameByNumber(i));
			}
			return result;
		}
		
		public function generatePredListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < Predicate.TYPE_COUNT; ++i) {
				result.addItem(Predicate.getNameByType(i));
			}
			return result;
		}
		
		public function generateRelationListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < RelationshipNetwork.RELATIONSHIP_COUNT; ++i) {
				result.addItem(RelationshipNetwork.getRelationshipNameByNumber(i));	
			}
			return result;
		}

		public function generateStatusListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < Status.STATUS_COUNT; ++i) {
				result.addItem(Status.getStatusNameByNumber(i));
			}
			return result;
		}
		
		public function generateNetworkListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < SocialNetwork.NETWORK_COUNT; ++i) {
				result.addItem(SocialNetwork.getNameFromType(i));
			}
			return result;
		}
		
		public function generateNetworkComparatorListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < Predicate.COMPARATOR_COUNT; ++i) {
				result.addItem(Predicate.getCompatorByNumber(i));
			}
			return result;
		}

		public function generateNetworkOperatorListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < Predicate.OPERATOR_COUNT; ++i) {
				result.addItem(Predicate.getOperatorByNumber(i));
			}
			return result;
		}
		
		public function generateCKBTruthListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:Number = 0; i < CulturalKB.TRUTH_LABEL_COUNT; ++i) {
				result.addItem(CulturalKB.getTruthNameByNumber(i));
			}
			return result;
		}
		
		public function generateCKBSubjectiveListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:Number = 0; i < CulturalKB.SUBJECTIVE_LABEL_COUNT; ++i) {
				result.addItem(CulturalKB.getSubjectiveNameByNumber(i));
			}
			return result;
		}	
		
		public function generateSFDBLabelListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			for (var i:int = 0; i < SocialFactsDB.LABEL_COUNT; ++i) {
				result.addItem(SocialFactsDB.getLabelByNumber(i));
			}
			return result;
		}	
		
		public function generateRoleListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			result.addItem("initiator");
			result.addItem("responder");
			result.addItem("other");
			return result; 
		}
		
		/**
		 * generateBodyAnimationListProvider simple generates a list of all of the
		 * various body animations that the actors can engage in, for purposes
		 * including populating the animation viewer drop down list in the
		 * performance authoring tab.  We will perhaps want to make all
		 * possible animations a seperate ENUM in CiF, but to start, they
		 * will be hardcoded into this generator function.
		 * @return result an ArrayCollection that represents all of the different body animations characters can be assigned for any given line of dialog
		 */
		public function generateBodyAnimationListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			result.addItem("");
			result.addItem("idle");
			result.addItem("accuse");
			result.addItem("adore");
			result.addItem("agitated_talk");
			result.addItem("blush");
			result.addItem("brush_hair");
			result.addItem("casual_talking");
			result.addItem("console");
			result.addItem("cry");
			result.addItem("dance_cool");
			result.addItem("dance_lame");
			result.addItem("excited_talk");
			result.addItem("flirt_wave");
			result.addItem("handing");
			result.addItem("high_five_give");
			result.addItem("high_five_denied");
			result.addItem("high_five_reject");
			result.addItem("hug");
			result.addItem("kiss");
			result.addItem("gasp");
			result.addItem("giggle");
			result.addItem("laughBig");
			result.addItem("laughSmall");
			result.addItem("lightsaber_new");
			result.addItem("lightsaber");
			result.addItem("masculine_wave");
			result.addItem("nervous");
			result.addItem("nod");
			result.addItem("pointObject");
			result.addItem("poke");
			result.addItem("punch");
			result.addItem("punchReaction");
			result.addItem("pushups");
			result.addItem("relieved");
			result.addItem("sexy_pose");
			result.addItem("shakehead");
			result.addItem("showoff");
			result.addItem("shocked");
			result.addItem("shrug");
			result.addItem("talk_phone_idle");
			result.addItem("talking_short");
			result.addItem("talking_medium");
			result.addItem("talking_long");
			result.addItem("talking_on_phone");
			result.addItem("texting");
			result.addItem("tickled");
			result.addItem("tickling");
			result.addItem("toss_hands_up");
			result.addItem("walking");
			result.addItem("wave");
			result.addItem("waveObject");

			var sort:Sort= new Sort();
			result.sort = sort;
			result.refresh();
			
			return result;
		}
		
/**
		 * generateFaceAnimationListProvider simple generates a list of all of the
		 * various face animations that the actors can engage in, for purposes
		 * including populating the animation viewer drop down list in the
		 * performance authoring tab.  We will perhaps want to make all
		 * possible animations a seperate ENUM in CiF, but to start, they
		 * will be hardcoded into this generator function.
		 * @return result an ArrayCollection that represents all of the different face animations characters can be assigned for any given line of dialog
		 */
		public function generateFaceAnimationListProvider():ArrayCollection {
			var result:ArrayCollection = new ArrayCollection;
			result.addItem("");
			result.addItem("no action");
			result.addItem("disinterest_action");
			result.addItem("flinch_action");
			result.addItem("laugh_large_action");
			result.addItem("laugh_small_action");
			result.addItem("lying_action");
			result.addItem("scorned_action");
			result.addItem("shifty_action");
			result.addItem("surprised_action");
			result.addItem("whatever_action");
			
			var sort:Sort= new Sort();
			result.sort = sort;
			result.refresh();
			
			return result;
		}
		//}
		
		public function generateFaceStateListProvider():ArrayCollection
		{
			var result:ArrayCollection = new ArrayCollection;
			result.addItem("");
			result.addItem("idle");
			result.addItem("angry");
			result.addItem("anxious");
			result.addItem("concerned");
			result.addItem("disinterested");
			result.addItem("happy");
			result.addItem("very happy");
			result.addItem("resentful");
			result.addItem("sad");
			result.addItem("very sad");
			
			var sort:Sort= new Sort();
			result.sort = sort;
			result.refresh();
			
			return result;
		}
		
		public function compareAnimationNames(x:String, y:String):Number
		{
			if (x < y) {
				return -1;
			}
			else if (x > y) {
				return 1;
			}
			else return 0;
		}
		
		
		public function lineOfDialogToListString(line:LineOfDialogue):String {
			return line.primarySpeaker + ": " + line.initiatorLine + ", " + line.responderLine + ", " + line.otherLine;
		}
		
	}
}