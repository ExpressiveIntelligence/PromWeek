/******************************************************************************
 * edu.ucsc.eis.socialgame.FactPrecondition
 *
 * Class that implements the DramaturgicalPrecondition interface that represents
 * a fact precondition. To build a FactPrecondition, the constructor must be
 * used followed by a call to the setPrecondition() interface method. This 
 * function ignores the third string specified in the interface, so it is safe
 * to call it with two string parameters instead of three.
 * ***************************************************************************/

package edu.ucsc.eis.socialgame
{
	public class FactPrecondition implements DramaturgicalPrecondition {
		private var entity:String;
		private var fact:String;
		
		
		
		public function FactPrecondition() {
			super();
			this.entity = new String();
			this.fact = new String();
		}
		
		public function setPrecondition(e:String, f:String, e1:String=""):void {
			this.entity = new String(e);
			this.fact = new String(f);
		}
		
		public function getPrecondition():Vector.<String> {
			var returnVector:Vector.<String> = new Vector.<String>();
			returnVector.push(this.entity);
			returnVector.push(this.fact);
			return returnVector;
		}
		
		public function isFact():Boolean {
			return true; 
		}
		
		public function isRelationship():Boolean {
			return false;
		}
	}
}