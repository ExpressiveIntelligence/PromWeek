/******************************************************************************
 * edu.ucsc.eis.socialgame.facts.BasicNeedsFact
 * 
 * implements SocialFact interface
 * 
 * The BasicNeedFact is a class that implements the SocialFact interface and
 * is meant to be instatiated and stored in the SocialState database. These
 * social facts are essentially records of what basic need changes have
 * happened to the characters throughout the course of the game.
 * 
 * 
 *****************************************************************************/

package edu.ucsc.eis.socialgame.facts
{
	public class BasicNeedFact implements SocialFact
	{
		private const type:int = 0;//SocialFact.BASIC_NEED;
		private var need:int;
		private var change:Number;
		private var character:String;
		
		public function BasicNeedFact() {
			this.need = new int(-1);
			this.change = new Number();
			this.character = new String();
		}
		
		//interface mandated functions
		public function factType():int {return this.type;}
		public function factAbout():String {return this.character;}
		
		//getters
		public function getNeed():int { return this.need; }
		public function getChange():Number { return this.change; }
		public function getCharacter():String {return this.factAbout();}
		
		
		//setters
		
		public function setNeed(n:int):void { this.need = n; }
		public function setChange(d:Number):void { this.change = d; }
		public function setAbout(char:String):void { this.character = char; }
		public function setCharacter(char:String):void { this.setAbout(char); }
		
		
		public function toString():String {
			var returnStr:String = new String();
			returnStr = returnStr.concat("BasicNeedFact:",this.character,",",this.need,",",this.change);
			return returnStr;
		}
	}
}