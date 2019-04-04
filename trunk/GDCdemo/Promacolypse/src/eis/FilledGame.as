package eis
{
	import eis.skins.SocialGameButtonSkin;
	/**
	 * ...
	 * @author Josh
	 */
	public class FilledGame
	{
		public var game:SocialGame;
		public var weight:Number;
		public var initiator:String;
		public var target:String;
		
		public function FilledGame(sg:SocialGame, w:Number, init:String, tar:String) {
			//trace(w);
			this.game = sg;
			this.weight = new Number(w);
			this.initiator = init;
			this.target = tar;
		}
		
		public static function compare(x:FilledGame, y:FilledGame):Number {
			if (x.weight > y.weight) {
				return -1.0;
			}else if (x.weight < y.weight) {
				return 1.0;
			}
			return 0.0;
		}
		
		public function toString():String {
			return "WeightedGame: " + this.game.specificTypeOfGame + ", " + this.initiator + ", " + this.target + "," + this.weight+"\n";
		}
	}

}