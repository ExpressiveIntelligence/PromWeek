/******************************************************************************
 * edu.ucsc.eis.socialgame.RelationPrecondition
 *
 * Class that implements the DramaturgicalPrecondition interface that represents
 * a Relation precondition. To build a RelationPrecondition, the constructor must
 * be used followed by a call to the setPrecondition() interface method. This 
 * function uses all three of the parameters specified in the interface
 * definition.
 *****************************************************************************/

package edu.ucsc.eis.socialgame
{
	public class RelationPrecondition implements DramaturgicalPrecondition {
		private var entity1:String;
		private var fact:String;
		private var entity2:String;
		
		
		
		public function RelationPrecondition() {
			super();
			this.entity1 = new String();
			this.fact = new String();
			this.entity2 = new String();
		}
		
		public function setPrecondition(e1:String, f:String, e2:String=""):void {
			this.entity1 = new String(e1);
			this.fact = new String(f);
			this.entity2 = new String(e2);
		}
		
		public function getPrecondition():Vector.<String> {
			var returnVector:Vector.<String> = new Vector.<String>();
			returnVector.push(this.entity1);
			returnVector.push(this.fact);
			returnVector.push(this.entity2);
			return returnVector;
		}
		
		public function isFact():Boolean {
			return false; 
		}
		
		public function isRelationship():Boolean {
			return true;
		}
		
		public function toString():String {
			var returnStr:String = new String();
			return  returnStr.concat("RelationPrecondition:",this.entity1,",",this.fact,",",this.entity2);
		}
	}
}