package CiF 
{
	import adobe.utils.CustomActions;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author 
	 */
	public class InstrumentedInfluenceRule extends InfluenceRule 
	{
		public static var counter:int = 0;
		/**
		 * Holds reference to all InstrumentedInfluenceRules by keys of their unique IDs.
		 */
		public static var rulesByID:Dictionary = new Dictionary();

		public var uniqueID:int;
		public var history:Dictionary;
		
		public function InstrumentedInfluenceRule() {
			super();
			counter++;
			this.uniqueID = counter;
			this.history = new Dictionary();
			
			if (!InstrumentedInfluenceRule.rulesByID) {
				InstrumentedInfluenceRule.rulesByID = new Dictionary();
			}
			InstrumentedInfluenceRule.rulesByID[this.uniqueID] = this;
		}
		
		public override function evaluate(initiator:Character, responder:Character, other:Character = null, sg:SocialGame=null):Boolean {
			this.lastTrueCount = 0;
			var p:Predicate;
			var p1:Predicate;
			var i:int = 0;
			var truthState:Dictionary = new Dictionary();
			
			var isTrue:Boolean = false;
			
			if (0 < this.highestSFDBOrder()) {
				//Debug.debug(this, "evaluate() this.highestSFDBOrder of the rule: " + this.highestSFDBOrder());
				return this.evaluateTimeOrdedRule(initiator, responder, other);
			}
			
	
			for each (p in this.predicates) {
				//Debug.debug(this, "evaluating predicate of type: " + Predicate.getNameByType(p.type), 0);
				var startTime:Number = getTimer();
				if (!p.evaluate(initiator, responder, other, sg)) {
					Predicate.evalutionComputationTime += getTimer() - startTime;
					//Debug.debug(this, "predicate is false - " + p.toString());
					truthState[i] = false;
				}else {
					truthState[i] = true;
					++this.lastTrueCount;
				}
				Predicate.evalutionComputationTime += getTimer() - startTime;
				
				++i;
			}

			if(this.lastTrueCount == this.predicates.length)
				isTrue = true
			else
				isTrue = false;
				
			truthState["numTrue"] = this.lastTrueCount;
			truthState["result"] = isTrue;
			this.addTruthStateToHistory(initiator, responder, other, truthState);

			return isTrue;
		}
		
		public override function evaluateTimeOrdedRule(x:Character, y:Character, z:Character):Boolean {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			//The max order value of the rule.
			var maxOrderInRule:Number = this.highestSFDBOrder();
			//when evaluating an order, this is value is updated with the highest truth time for the order.
			//when evaluating an order, this is value is updated with the highest truth time for the order.
			var curOrderTruthTime:Number = cif.sfdb.getLowestContextTime();
			//the highest truth time of all the predicates in the previous order.
			var lastOrderTruthTime:Number = curOrderTruthTime;
			//the truth time of the current predicate.
			var time:Number;
			//the current order being evaluated
			var order:Number;
			var pred:Predicate; //predicate iterator
			var startTime:Number;
			
			var truthState:Dictionary = new Dictionary();
			var i:int = 0;
			var numTrue:int = 0;
		
			var isTrue:Boolean = false;
			
			for (order = 1; order <= maxOrderInRule; ++order) {
				for each (pred in this.predicates) {
					if (pred.sfdbOrder == order) {
						startTime = getTimer(); 
						//the predicate is of the order we are currently concerned with
						time = cif.sfdb.timeOfPredicateInHistory(pred, x, y, z);
						Predicate.evalutionComputationTime += getTimer() - startTime;
						//was the predicate true at all in history? If not, return false.
						if ((SocialFactsDB.PREDICATE_NOT_FOUND == time) || (time < lastOrderTruthTime)) {
							truthState[i] = false;
						}else {
							truthState[i] = true;
							numTrue++
						}
						++i;
						
						//update curOrderTruthTime to highest value for this order
						if (time > curOrderTruthTime) curOrderTruthTime = time;
					}
				}
				lastOrderTruthTime = curOrderTruthTime;
			}
			
			//evaluate the predicates in the rule that are not time sensitive (i.e. their order is less than 1).
			for each (pred in this.predicates) {
				if (pred.isSFDB < 1) {
					startTime = getTimer();
					if (!pred.evaluate(x, y, z)) {
						Predicate.evalutionComputationTime += getTimer() - startTime;
						truthState[i] = false;
					}else {
						numTrue++
						truthState[i] = true;
					}
					++i;
					Predicate.evalutionComputationTime += getTimer() - startTime;
				}
			}

			if(numTrue == this.predicates.length)
				isTrue = true
			else
				isTrue = false;
				
			truthState["numTrue"] = numTrue;
			truthState["result"] = isTrue;
			this.addTruthStateToHistory(x, y, z, truthState);

			return isTrue;
		}
		
		/**
		 * Prepares the history dictionaries to accept this rule. It properly links the dictionary entries including
		 * the truth state.
		 * @param	x	First character variable.
		 * @param	y	Second character variable.
		 * @param	z	Third character variable.
		 * @param	truthState	The state of evaluation of the rules of one evaluation.
		 */
		private function addTruthStateToHistory(x:Character, y:Character, z:Character, truthState:Dictionary):void {
			var time:int = CiFSingleton.getInstance().time;
			//is there a dictionary for this time?\
			
			var zName:String = (z)?z.characterName:"none";
			//if (!InstrumentedInfluenceRule.history[time]) {
			if (!(time in this.history)) {
				this.history[time] = new Dictionary();
			}
			
			//is there a dictionary for this x?
			if (!(x.characterName in this.history[time])) {
				(this.history[time] as Dictionary)[x.characterName] = new Dictionary();
			}
			
			//is there a dictionary for this y?
			if (!this.history[time][x.characterName][y.characterName]) {
				this.history[time][x.characterName][y.characterName] = new Dictionary();
			}

			//is there a dictionary for this z?
			if (!this.history[time][x.characterName][y.characterName][zName]) {
				this.history[time][x.characterName][y.characterName][zName] = new Dictionary();
			}

			//Add the truthState.
			this.history[time][x.characterName][y.characterName][zName] = truthState;
		}
		
		/**
		 * Returns a string containing either one or all of the rules and their histories.
		 * @param	id	The unique identified of a rule. The default value is -1 and it
		 * tells the function to print the history of all rules.
		 * @return	A string containing the history of one or more rules.
		 */
		public static function ruleHistoryToString(id:int=-1):String {
			var output:String = new String();
			var iir:InstrumentedInfluenceRule;
			var i:int = 0;
			var truthState:Dictionary;
			
			if (id >= 0) {
				return singleRuleHistoryToString(id);
			}
			for (var IDkey:* in InstrumentedInfluenceRule.rulesByID) {
				output += singleRuleHistoryToString(IDkey) + "\n";
			}
			
			return output;
		}
		
		private static function singleRuleHistoryToString(id:int):String {
			//the truth state
			var t:Dictionary;
			var output:String = new String();
			var curHistory:Dictionary = (InstrumentedInfluenceRule.rulesByID[id] as InstrumentedInfluenceRule).history;
			var rulePredicateCount:int = (InstrumentedInfluenceRule.rulesByID[id] as InstrumentedInfluenceRule).predicates.length;
			for (var time:* in curHistory) {
				for (var xName:* in curHistory[time]) {
					for (var yName:* in curHistory[time][xName]) {
						for (var zName:* in curHistory[time][xName][yName]) {
							//for (var ts:* in curHistory[time][xName][yName][zName]) {
								//t = ts as Dictionary;
								t = curHistory[time][xName][yName][zName] as Dictionary;
								//at the truth state level here
								output += "\t" + time + ", " + xName + ", " + yName + ", " + zName + ", " + t["result"] + ", " + t["numTrue"];
								for (var i:int = 0; i < rulePredicateCount; ++i ) {
									output += ", " + t[i];
								}
								output += "\n";
							//}
						}
					}
				}
			}
			if ("" == output) {
				output = id + " was never evaluated. " + (InstrumentedInfluenceRule.rulesByID[id] as InstrumentedInfluenceRule) + "\n";
			}else {
				output = id + ": " +(InstrumentedInfluenceRule.rulesByID[id] as InstrumentedInfluenceRule)+ "\n" + output;
			}
			return output;
		}
		
		
		//add rule id
		//add rule weight
		public static function dumpMicrotheoryStatesToXML(initiator:String, responder:String, time:int = -1):XML {
			var outXML:XML = <MTDump initiator={initiator} responder={responder} />;
			var cif:CiFSingleton = CiFSingleton.getInstance();
			
			if (time >= 0) {
				return outXML.appendChild(singleTimeMicrotheoryDump(initiator, responder, time));
			}
			for (var t:int = 1; t <= cif.time; ++t) {
				outXML.appendChild(singleTimeMicrotheoryDump(initiator, responder, t));
			}
			return outXML;
			
		}
		
		private static function singleTimeMicrotheoryDump(initiator:String, responder:String, t:int):XML {
			var outXML:XML = <MTDump initiator={initiator} responder={responder} />;
			var cif:CiFSingleton = CiFSingleton.getInstance();
			var timeDumpXML:XML = <MicrotheoryDumpAtTime time={t} />;
			for each (var mt:Microtheory in cif.microtheories) {
				var mtDumpXML:XML = <SingleMicrotheoryDump name={mt.name} />
				for each(var ir:InstrumentedInfluenceRule in mt.initiatorIRS.influenceRules) {
					if(ir.history[t]) {
						if(ir.history[t][initiator]) {
							if(ir.history[t][initiator][responder]) {
								for (var otherName:* in ir.history[t][initiator][responder]) {
									var ts:Dictionary = ir.history[t][initiator][responder][otherName] as Dictionary;
									var ruleStateXML:XML = <RuleState other={otherName} result={ts["result"]} numTrue={ts["numTrue"]} ruleID={ir.id} weight={ir.weight} />;
									for (var i:int = 0; i < ir.length; ++i ) {
											ruleStateXML.appendChild(<PredicateState index={i} evaluation={ts[i]} />);
									}
									mtDumpXML.appendChild( ruleStateXML);
								}
							}
						}
					}
				}				
				timeDumpXML.appendChild(mtDumpXML);
			}
			return timeDumpXML;
		}

	}

}