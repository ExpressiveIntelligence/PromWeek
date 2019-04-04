package CiF 
{
	import CiF.Character;
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class RandomLocution implements Locution
	{
		public var realizedString:String;

		public var candidateStrings:Vector.<String>;
		
		public function RandomLocution() 
		{
			candidateStrings = new Vector.<String>();
		}		
		
		/* INTERFACE CiF.Locution */
		public function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String
		{
			this.realizedString = "";
			if (this.candidateStrings.length > 0)
			{
				this.realizedString = this.candidateStrings[Util.randRange(0, this.candidateStrings.length - 1)];
			}
			
			return this.realizedString;
		}
		
		public function toString():void
		{
			
		}
		
		public function getType():String
		{
			return "RandomLocution";
		}
	}
}