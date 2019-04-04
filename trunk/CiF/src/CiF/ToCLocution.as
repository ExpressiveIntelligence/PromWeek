package CiF 
{
	import CiF.Character;
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class ToCLocution implements Locution
	{
		public var locutions:Vector.<Locution>;
		public var realizedString:String;
		
		public var tocID:int;
		public var rawString:String = "";
		
		public var speaker:String = "";
		
		public function ToCLocution() 
		{
			
		}		
		
		/* INTERFACE CiF.Locution */
		public function renderText(initiator:Character, responder:Character, other:Character, line:LineOfDialogue):String
		{
			realizedString = "";
			
			//render toc strings
			var locution:Locution;

			for each (locution in this.locutions)
			{
				if (locution.getType() == "MixInLocution")
				{
					initiator.isSpeakerForMixInLocution = true;
					this.realizedString += locution.renderText(initiator, responder, other, line) + " ";
					initiator.isSpeakerForMixInLocution = false;
				}
				else
				{
					if (locution.getType() == "SFDBLabelLocution")
					{
						(locution as SFDBLabelLocution).speaker = this.speaker;
					}
					//this.realizedString += locution.renderText(initiator, responder, other) + " "; //THIS MAKES PLURAL THINGS NOT WORK!
					this.realizedString += locution.renderText(initiator, responder, other, line);
				}
			}

			return this.realizedString;
		}
		
		public function toString():void
		{
			
		}
		
		public function getType():String
		{
			return "ToCLocution";
		}
	}
}