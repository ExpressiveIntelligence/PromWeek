/******************************************************************************
 * edu.ucsc.eis.socialgame.facts.StatusFact
 * 
 * implements SocialFactInterface
 * 
 * The StatusFact class implements SocialFact and is mean to be used to store
 * all of the StatusFacts that occur in the game in the SocialState database
 * of SocialFacts. It is comprised of a subject, a status, and an object.
 * An example would be "bill friend ted" meaning the bill is a friend of ted. 
 * 
 *****************************************************************************/

package edu.ucsc.eis.socialgame.facts
{
	public class StatusFact implements SocialFact
	{
		private const type:int = 1;
		private var subject:String;
		private var status:String;
		private var object:String;
		
		public function StatusFact(){
		}

		//interface mandated functions
		public function factType():int{ return this.type; }
		public function factAbout():String {return this.subject;}
		
		//getters
		public function getSubject():String{ return this.subject; }
		public function getStatus():String{ return this.status; }
		public function getObject():String{ return this.object; }
		
		//setters
		public function setSubject(sub:String):void { this.subject = sub;}
		public function setStatus(stat:String):void { this.status = stat;}
		public function setObject(ob:String):void {this.object = ob;}
		
		public function toString():String {
			var returnStr:String = new String();
			returnStr = returnStr.concat("StatusFact:",this.subject,",",this.status,",",this.object);
			return returnStr;
		}
		
	}
}