package eis 
{
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author Ben*
	 */
	public class LineOfDialogue
	{
		public var lineNumber:int = -1;
		public var speaker:String = "";
		public var line:String = "";
		public var associatedAnimation:String;
		public var reactionAnimation:String;
		public var time:int = -999;
		
		public function LineOfDialogue(ln:int, s:String, l:String, aa:String, t:int, reactionAnimation:String = "") {
			this.lineNumber = ln;
			this.speaker = s;
			this.line = l;
			this.associatedAnimation = aa;
			this.time = t;
			this.reactionAnimation = reactionAnimation;
		}
		
		public function toString():String {
			var tempLine:String = line.replace("'", "`"); //for parsing purposes on the flash end.
			var output:String = "<DIALOGUE "
			output += "lineNum='" + lineNumber + "' name='" + speaker + "' line='" + tempLine
			output += "' Animation='" + associatedAnimation + "' Reaction='" + reactionAnimation + "' time='"
			output += time + "' />"
			return output
		}
		
	}

}