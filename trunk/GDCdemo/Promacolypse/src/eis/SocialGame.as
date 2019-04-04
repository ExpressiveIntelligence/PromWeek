package eis 
{
	/**
	 * ...
	 * @author Ben*
	 */
	public class SocialGame
	{
		public static const DATING:int = 0;
		public static const FRIENDS:int = 1;
		public static const ENEMY:int = 2;
		public static const FIGHTING:int = 3;
		public static const ROMANCE_UP:int = 4;
		public static const ROMANCE_DOWN:int = 5;
		public static const RELATIONSHIP_UP:int = 6;
		public static const RELATIONSHIP_DOWN:int = 7;
		public static const AUTHENTICITY_UP:int = 8;
		public static const AUTHENTICITY_DOWN:int = 9;
		public static const NOT_DATING:int = 10;
		public static const NOT_FRIENDS:int = 11;
		public static const NOT_ENEMY:int = 12;
		public static const NOT_FIGHTING:int = 13;
		//If more social game categories are added to the consts above, update
		//the count below:
		public static const CHANGE_TYPE_COUNT:int = 14;
		
		public var conversation:Vector.<LineOfDialogue>;
		public var lineNo:int = 0;
		public var specificTypeOfGame:String = ""; // e.g. "ConversationalFlirt" or "JokeAtExpenseOf"
		public var socialStatusChange:int = -1;
		public var isSuccess:Boolean = true;
		
		public function SocialGame(tog:String, success:Boolean, socialStatusChange:int)
		{
			specificTypeOfGame = tog;
			isSuccess = success;
			this. socialStatusChange = socialStatusChange;
			conversation = new Vector.<LineOfDialogue>;
		}
		
		public function addLine(speaker:String, text:String, anim:String, time:int, reactAnim:String=""):void {
			var lod:LineOfDialogue = new LineOfDialogue(lineNo, speaker, text, anim, time, reactAnim);
			conversation.push(lod);
			lineNo++;
		}
		
		public function toXML(init:String, targ:String):String {
			var output:String = "<SCRIPT>";
			for (var i:int = 0; i < conversation.length; i++) {
				var currentLod:String = conversation[i].line;
				currentLod = currentLod.replace("%%INITIATOR%%", init);
				currentLod = currentLod.replace("%%TARGET%%", targ);
				output += currentLod;
			}
			output += "</SCRIPT>";
			return output;
		}
		public function fillNameTemplates(init:String, targ:String):void {
			for (var i:int = 0; i < this.conversation.length; i++) {
				this.conversation[i].line = this.conversation[i].line.replace("%%INITIATOR%%", init);
				this.conversation[i].line = this.conversation[i].line.replace("%%TARGET%%", targ);
			}
		}
		public function copyWithFilledTemplates(init:String, targ:String):SocialGame {
			var typeOfGame:String = this.specificTypeOfGame;
			var success:Boolean = this.isSuccess;
			var socialStatus:int = this.socialStatusChange;
			var copiedGame:SocialGame = new SocialGame(typeOfGame, success, socialStatus);
			
			for (var i:int = 0; i < this.conversation.length; i++) {
				var tempLineNumber:int = this.conversation[i].lineNumber;
				var tempSpeaker:String = this.conversation[i].speaker;
				var tempLine:String = this.conversation[i].line;
				tempLine = tempLine.replace("%%INITIATOR%%", init);
				tempLine = tempLine.replace("%%TARGET%%", targ);
				var tempAnimation:String = this.conversation[i].associatedAnimation;
				var tempReaction:String = this.conversation[i].reactionAnimation;
				var tempTime:int = this.conversation[i].time;
				copiedGame.addLine(tempSpeaker, tempLine, tempAnimation, tempTime, tempReaction);
			}
			return copiedGame;
		}
	}

}