package CiF 
{
	import CiF.Character;
	/**
	 * The Trigger class consists of conditional rules that look over the recent
	 * social state and perform social change based on evaluation of the conditions.
	 * This allows for social state transformations that are difficult to capture
	 * in SocialGame effect changes. For example, the detection of a the cheating
	 * status, or where a character is dating more than one other character
	 * simultaneously, is a very conditional and difficult statement in the 
	 * context of social game effect changes. Furthermore, it would have to be
	 * present in every effect that has dating in it's change rule. Triggers
	 * centralize this logic and allow for more "third party" reasoning. An
	 * example would be the emnity rule:
	 * <pre>friends(x,y)^negativeAct(z,y)->emnity(x,z)</pre>
	 * 
	 * <p>Affected triggers are placed into the social facts database as a
	 * TriggerContext.</p>
	 * 
	 * <p>As triggers behave generally like SocialGame Effects in that they 
	 * have a condition rule, a change rule, and a performance realization
	 * description, they extend Effect as to not duplicate functionality.</p>
	 * 
	 * </p>Unlike the logical structures in social games, the logical rules
	 * in triggers are not associated with roles; they are standard logical
	 * variables -- x, y, and z. The condition and change rules of triggers
	 * should use x,y, and z instead of responder, initiator, and other.</p>
	 * 
	 * @see CiF.Rule
	 * @see CiF.Predicate
	 * @see CiF.SocialGame
	 * @see CiF.Effect
	 * @see CiF.SocialFactsDB
	 * @see CiF.TriggerContext
	 */
	public class Trigger extends Effect
	{
		/**
		 * This is used to help know when we are dealing with an actual authored trigger, or a trigger context which has
		 * no condition, and is the result of the tatus timing out.
		 */
		public static var STATUS_TIMEOUT_TRIGGER_ID:int = -1;
		
		public var useAllChars:Boolean;
		
		
		public function Trigger() {
			
		}
		
		override public function evaluateCondition(initiator:Character, responder:Character = null, other:Character = null):Boolean 
		{
			//Debug.debug(this, "evaluateCondition() about to evaluate trigger: " + this.toXML());
			return super.evaluateCondition(initiator, responder, other);
			
		}
		
		/**
		 * Returns a SFDBContext interface compatable SFDB entry for this
		 * trigger. No time is set as this function is meant to be called
		 * in either CiFSingleton or SocialFactsDB when placing a trigger
		 * that has fired into the SFDB context.
		 * @param	time The SFDB time with which to tag the SFDB entry.
		 * @return	The SFDB entry for the Trigger.
		 */
		public function makeTriggerContext(time:Number, x:Character, y:Character = null, z:Character = null):TriggerContext {
			var tc:TriggerContext = new TriggerContext();
			var p:Predicate;
			
			//var cif:CiFSingleton = CiFSingleton.getInstance();
			
			if (this.id == 10)
			{
				//trace("23432432432");
			}
			
			tc.time = time;
			tc.id = this.id;
			tc.initiator = x.characterName;
			tc.responder = (y)?y.characterName:"";
			tc.other = (z)?z.characterName:"";

			for each (p in this.change.predicates) {
				if (Predicate.SFDBLABEL == p.type) {
					var label:SFDBLabel = new SFDBLabel();
					label.to = p.primaryCharacterNameFromVariables(x, y, z);
					label.from = p.secondaryCharacterNameFromVariables(x, y, z);
					label.type = SocialFactsDB.getLabelByNumber(p.type);
					tc.SFDBLabels.push(label);
				}
			}
			
			return tc;
		}
	
		/**********************************************************************
		 * Utility functions
		 *********************************************************************/
		
		public function toXML():XML {
			var outXML:XML = <Trigger id={this.id}>
								<PerformanceRealization> { this.referenceAsNaturalLanguage } </PerformanceRealization>
								<ConditionRule>{new XML(this.condition.toXMLString())}</ConditionRule>
								<ChangeRule>{new XML(this.change.toXMLString())}</ChangeRule>
							</Trigger>;
			return outXML;
		}
		
		public override function toXMLString():String {
			return this.toXML().toXMLString();
		}

		public override function toString():String {
			return "Trigger: " + super.toString();
		}
	}
}