package CiF 
{
	/**
	 * Manages a set of influence rules. Has the ability to evalute the truth
	 * of all the rules and return a weight corresponding to the sum of the
	 * weights of the true influence rules.
	 * 
	 * <p>The results of the most current evaluation of the influence rule set
	 * is stored in the class.</p>
	 * 
	 * @author Tiger Team
	 * @see CiF.InfluenceRule
	 * @see CiF.Rule
	 * @see CiF.Predicate
	 */
	public class InfluenceRuleSet
	{
		/**
		 * The vector of InfluceRules that comprise the influce rule set.
		 */
		public var influenceRules:Vector.<InfluenceRule>;
		/**
		 * The truth values of the last evaluation of the the influence rule sets.
		 */
		public var lastTruthValues:Vector.<Boolean>;
		/**
		 * Then scores of the last evaluation of the IRS.
		 */
		public var lastScores:Vector.<Number>;
		/**
		 * The number of true rules in the last scoring of the IRS.
		 */
		public var truthCount:int = 0;
		
		public function InfluenceRuleSet() 
		{
			this.influenceRules = new Vector.<InfluenceRule>();
			this.lastTruthValues = new Vector.<Boolean>();
			this.lastScores = new Vector.<Number>();
		}
		
		/**
		 * Scores the rules of the influence rule set and returns the aggregate
		 * weight of the true influence rules by going through all others whenever
		 * others are relevant
		 *
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return The sum of the weight values associated with true influence
		 * rules.
		 */
		public function scoreRulesWithVariableOther(initiator:Character, responder:Character, other:Character = null, sg:SocialGame = null, activeOtherCast:Vector.<Character> = null, microtheoryName:String = "", isResponder:Boolean = false):Number {
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:CiFSingleton.getInstance().cast.characters;
			var score:Number = 0.0;
			this.truthCount = 0;
			var ruleRecord:RuleRecord;
			this.lastScores = new Vector.<Number>();
			this.lastTruthValues = new Vector.<Boolean>();
			
			for each (var ir:InfluenceRule in this.influenceRules) 
			{
				if (ir.weight != 0)
				{
					if (ir.requiresThirdCharacter())
					{
						for each (var other1:Character in possibleOthers)
						{
							if (other1.characterName != initiator.characterName && other1.characterName != responder.characterName)
							{
								if (ir.evaluate(initiator, responder, other1, sg))
								{
									ruleRecord = new RuleRecord();
									ruleRecord.type = (microtheoryName != "")?RuleRecord.MICROTHEORY_TYPE: RuleRecord.SOCIAL_GAME_TYPE;
									ruleRecord.name = (microtheoryName != "")?microtheoryName: sg.name;
									ruleRecord.influenceRule = ir;
									ruleRecord.initiator = initiator.characterName;
									ruleRecord.responder = responder.characterName;
									ruleRecord.other = other1.characterName;
									if (isResponder)
									{
										responder.prospectiveMemory.responseSGRuleRecords.push(ruleRecord);
									}
									else
									{
										initiator.prospectiveMemory.ruleRecords.push(ruleRecord);
									}
									
									score += ir.weight;
									
									//this data might be broken city USA because of the way we handle others above. Use ruleRecords instead.
									this.lastScores.push(score);
									this.lastTruthValues.push(true);
									++this.truthCount;
								}
								else 
								{
									this.lastScores.push(0.0);
									this.lastTruthValues.push(false);
								}
							}
						}
					}
					else
					{
						if (ir.evaluate(initiator, responder, null, sg))
						{
							ruleRecord = new RuleRecord();
							ruleRecord.type = (microtheoryName != "")?RuleRecord.MICROTHEORY_TYPE: RuleRecord.SOCIAL_GAME_TYPE;
							ruleRecord.name = (microtheoryName != "")?microtheoryName: sg.name;
							ruleRecord.influenceRule = ir;
							ruleRecord.initiator = initiator.characterName;
							ruleRecord.responder = responder.characterName;
							if (isResponder)
							{
								responder.prospectiveMemory.responseSGRuleRecords.push(ruleRecord);
							}
							else
							{
								initiator.prospectiveMemory.ruleRecords.push(ruleRecord);
							}
							
							score += ir.weight;
							
							//this data might be broken city USA because of the way we handle others above. Use ruleRecords instead.
							this.lastScores.push(score);
							this.lastTruthValues.push(true);
							++this.truthCount;
						}
						else 
						{
							this.lastScores.push(0.0);
							this.lastTruthValues.push(false);
						}
					}
				}
			}
			return score;
		}
		
		/**
		 * Scores the rules of the influence rule set and returns the aggregate
		 * weight of the true influence rules
		 *
		 * @param	initiator	The initiator of the social game.
		 * @param	responder	The responder of the social game.
		 * @param	other		A third party in the social game.
		 * @return The sum of the weight values associated with true influence
		 * rules.
		 */
		public function scoreRules(initiator:Character, responder:Character, other:Character = null, sg:SocialGame = null, activeOtherCast:Vector.<Character> = null, microtheoryName:String = "", isResponder:Boolean = false):Number 
		{
			var possibleOthers:Vector.<Character> = (activeOtherCast)?activeOtherCast:CiFSingleton.getInstance().cast.characters;
			var score:Number = 0.0;
			this.truthCount = 0;
			var ruleRecord:RuleRecord;
			this.lastScores = new Vector.<Number>();
			this.lastTruthValues = new Vector.<Boolean>();
			
			//var numberCount:int = 0;
			
			for each (var ir:InfluenceRule in this.influenceRules) 
			{
				//numberCount = 0;
				if (ir.weight != 0)
				{
					//Debug.debug(this, "game: " + sg.name +" scoreRules() Rule: " + ir.toString());
					if (ir.requiresThirdCharacter())
					{
						if (!other) Debug.debug(this, "scoreRules() No other passed in! Fatal bug with rule: " + ir.toString());
						
						if (ir.evaluate(initiator, responder, other, sg))
						{
							ruleRecord = new RuleRecord();
							ruleRecord.type = (microtheoryName != "")?RuleRecord.MICROTHEORY_TYPE: RuleRecord.SOCIAL_GAME_TYPE;
							ruleRecord.name = (microtheoryName != "")?microtheoryName: sg.name;
							ruleRecord.influenceRule = ir;
							ruleRecord.initiator = initiator.characterName;
							ruleRecord.responder = responder.characterName;
							ruleRecord.other = other.characterName;
							if (isResponder)
							{
								responder.prospectiveMemory.responseSGRuleRecords.push(ruleRecord);
							}
							else
							{
								initiator.prospectiveMemory.ruleRecords.push(ruleRecord);
							}
							
							score += ir.weight;
							
							//this data might be broken city USA because of the way we handle others above. Use ruleRecords instead.
							this.lastScores.push(score);
							this.lastTruthValues.push(true);
							++this.truthCount;
						}
						else 
						{
							this.lastScores.push(0.0);
							this.lastTruthValues.push(false);
						}
					}
					else
					{
						if (ir.evaluate(initiator, responder, null, sg))
						{							
							ruleRecord = new RuleRecord();
							ruleRecord.type = (microtheoryName != "")?RuleRecord.MICROTHEORY_TYPE: RuleRecord.SOCIAL_GAME_TYPE;
							ruleRecord.name = (microtheoryName != "")?microtheoryName: sg.name;
							ruleRecord.influenceRule = ir;
							ruleRecord.initiator = initiator.characterName;
							ruleRecord.responder = responder.characterName;
							//if there is an other, this means it is the other that was important in the SG precondition, or MT def
							if (other) ruleRecord.other = other.characterName;
							if (isResponder)
							{
								responder.prospectiveMemory.responseSGRuleRecords.push(ruleRecord);
							}
							else
							{
								initiator.prospectiveMemory.ruleRecords.push(ruleRecord);
							}
							
							
							score += ir.weight;
							
							//this data might be broken city USA because of the way we handle others above. Use ruleRecords instead.
							this.lastScores.push(score);
							this.lastTruthValues.push(true);
							++this.truthCount;
						}
						else 
						{
							this.lastScores.push(0.0);
							this.lastTruthValues.push(false);
						}
					}
				}
			}
			return score;
		}
		
		public function getlastTruthValues():Vector.<Boolean> {
			return this.lastTruthValues.concat();
		}
		
		public function getlastScores():Vector.<Number> {
			return this.lastScores.concat();
		}
		
		
		/**
		 * Returns the rule who's id matches the id provided
		 * @param	ruleID
		 * @return
		 */
		public function getRuleByID(ruleID:int):InfluenceRule
		{
			for each (var r:InfluenceRule in this.influenceRules)
			{
				if (r.id == ruleID)
				{
					return r;
				}
			}
			Debug.debug(this, "getRuleByID() the id "+ruleID+ " is not matched by any influence rules in the set.");
			return new InfluenceRule();
		}
		
		/**
		 * Replaces the influence rule at ID with the given influence rule
		 * @param	ruleID
		 * @param	replaceRule
		 * @return
		 */
		public function replaceRuleAtID(ruleID:int, replaceRule:InfluenceRule):void
		{
			for (var i:int = 0; i < this.influenceRules.length; i++ )
			{
				if (this.influenceRules[i].id == ruleID)
				{
					this.influenceRules[i] = replaceRule.clone() as InfluenceRule;
					//Debug.debug(this, "replaceRuleAtID() Replaced rule at index " + i);
					return;
				}
			}
			Debug.debug(this, "replaceRuleAtID() the id "+ruleID+ " is not matched by any influence rules in the set.");
		}

		/**
		 * Removes the influence rule at ID.
		 * @param	ruleID
		 * @return
		 */
		public function removeRuleWithID(ruleID:int):void
		{
			for (var i:int = 0;  i < this.influenceRules.length; i++ )
			{
				if (this.influenceRules[i])
				{
					if (this.influenceRules[i].id == ruleID)
					{
						this.influenceRules.splice(i, 1);
						return;
					}
				}
			}
			Debug.debug(this, "removeRuleWithID() the id "+ruleID+ " is not matched by any influence rules in the set.");
		}
		
		public function clearLastValues():void
		{
			var i:int;
			for (i = 0; i < this.lastTruthValues.length; i++ )
			{
				this.lastTruthValues[i] = false;
			}
			
			for (i = 0; i < this.lastScores.length; i++ )
			{
				this.lastScores[i] = 0;
			}
		}
		
		/**********************************************************************
		 * Utilty functions.
		 *********************************************************************/
		public function toString():String {
			var returnstr:String;
			for each (var ir:InfluenceRule in this.influenceRules) {
				returnstr += super.toString() + "\n";
			}
			return returnstr;
		}
		
		public function toXMLString():String {
			//return this.toXML().toXMLString();
			var returnstr:String = "";
			for each (var irXML:InfluenceRule in this.influenceRules) {
				returnstr += irXML.toXMLString();
			}
			//Debug.debug(this, "toXMLString() returnstr: " + returnstr);
			return returnstr;
		}
		
		public function toXML():XMLList {
			return new XMLList(this.toXMLString());
			//var outXML:XML = new XML();
			//for each(var ir:InfluenceRule in this.influenceRules) {
				//outXML.appendChild(ir.toXML());
			//}
			//return outXML
		}
		
		public function clone(): InfluenceRuleSet {
			var irs:InfluenceRuleSet = new InfluenceRuleSet();
			irs.influenceRules = new Vector.<InfluenceRule>();
			for each(var ir:InfluenceRule in this.influenceRules) {
				irs.influenceRules.push(ir.clone() as InfluenceRule);
			}
			return irs;
		}
		
		public static function equals(x:InfluenceRuleSet, y:InfluenceRuleSet): Boolean {
			if (x.influenceRules.length != y.influenceRules.length) return false;
			for (var i:Number = 0; i < x.influenceRules.length; ++i) {
				if (!InfluenceRule.equals(x.influenceRules[i], y.influenceRules[i])) return false;
			}
			return true;
		}
	}

}