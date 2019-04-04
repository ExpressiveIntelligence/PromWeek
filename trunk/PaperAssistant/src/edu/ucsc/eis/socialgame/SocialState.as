/******************************************************************************
 * edu.ucsc.eis.socialgame.SocialState
 * 
 * This class keeps track of the social state of the game by keeping a database
 * of social facts. SocialFacts is an interface that is implemented by 
 * BasicNeedFacts, StatusFacts, and (eventually) RelationshipFacts. It also
 * keeps track of the aggregate changes of basic needs of the characters 
 * for the game up to the current point. This is done automatically as the 
 * BasicNeedFacts are entered into the database or manually through accessors.
 * 
 * xRegister characters
 * xcharacters -> index mapping
 * xindex -> pos/neg basic needs change
 * xvector/db of social facts
 * look up for fact types (by type, character, which views are handy?)
 * 
 *****************************************************************************/
package edu.ucsc.eis.socialgame
{
	import __AS3__.vec.Vector;
	
	import edu.ucsc.eis.socialgame.facts.BasicNeedFact;
	import edu.ucsc.eis.socialgame.facts.SocialFact;
	
	public class SocialState
	{
		private var facts:Vector.<SocialFact>;
		
		/* The characters registered to the social state.
		 */
		private var regChars:Vector.<String>;
		
		/* Vectors of 16 int values per character that keep track of the
		 * total change done to each registered character's basic needs.
		 */
		private var needsUpTotal:Vector.<Vector.<Number>>;
		private var needsDownTotal:Vector.<Vector.<Number>>;
		
		public function SocialState()
		{
			this.facts = new Vector.<SocialFact>();
			this.regChars = new Vector.<String>();
			this.needsUpTotal = new Vector.< Vector.<Number> >();
			this.needsDownTotal = new Vector.< Vector.<Number> >();
		}
		
		public function registerCharacter(name:String):void {
			this.regChars.push(name);
			this.needsUpTotal.push(new Vector.<Number>(16));
			this.needsDownTotal.push(new Vector.<Number>(16));
		}
		
		public function addSocialFact(fact:SocialFact):void {
			if(fact.factType() == 0) { //it's a basic needs fact
				var index:int = new int(-1);
				for(var i:int = new int(0); i < regChars.length; ++i) {
					if(regChars[i] == fact.factAbout()) {
						index = i;
					}
					
				}
				
				if(-1 == index) {
					trace("Error: adding a fact to the social state for a character that is not registered; basic needs fulfillment accounting skipped.");
				}else{
					var change:Number = new Number();
					var need:int = new int();
					change = BasicNeedFact(fact).getChange();
					need = BasicNeedFact(fact).getNeed();
					
					//might need this hook later; right now either fork does
					//the same math.
					
					if(0.0 < change) {
						this.needsUpTotal[index][need] += change;
					}else {
						this.needsDownTotal[index][need] += change;
					}
				}
			}
			
			this.facts.push(fact);
		}
	
		public function toString():String {
			var returnStr:String = new String("SocialState:[");
			returnStr=returnStr.concat(this.regChars,"],[",this.facts,"],[",this.needsUpTotal,"],[",this.needsDownTotal,"]");
			return returnStr;
		}
	
	}
}