package eis 
{
	import eis.skins.SocialNetworkButtonSkin;
	/**
	 * Character specific prosespective memory. This needs to be cleared each round.
	 */
	public class ProspectiveMemory
	{
		//private var volitions:SocialNetwork;
		private var volitions:Vector.<Vector.<Number>>;
		
		private var characters:int;
		private var changeTypes:int;
		
		public function ProspectiveMemory(chars:int, types:int) {
			this.volitions = new Vector.<Vector.<Number>>();
			var i:int;
			var j:int;
			
			this.characters = chars;
			this.changeTypes = types;
			
			//populate prospective memory storage and initialize to zero
			for (i = 0; i < characters; ++i) {
				volitions.push(new Vector.<Number>());
				for (j = 0; j < changeTypes; ++j) {
					volitions[i].push(0.0);
				}
			}
			//trace(this.characters + " " + this.changeTypes);
		}
		
		/**
		 * 
		 *XXX Keeping the largest volition values that come in for each round of
		 * social games.
		 * 
		 */
		public function setValue(char:Character, changeType:int, vol:Number):void {
			
			if(vol > this.volitions[char.networkID][changeType]) 
				this.volitions[char.networkID][changeType] = vol;
				//trace("ProspectiveMemory.setValue(): char.networkID=" + char.networkID + " changeType=" + changeType + " vol=" + vol + " stored=" +this.volitions[char.networkID][changeType]);
		}
		
		
		public function getValue(char:Character, changeType:int):Number {
			return this.volitions[char.networkID][changeType];
		}
		
		public function zeroMemory():void {
			var i:int;
			var j:int;

			//populate prospective memory storage and initialize to zero
			for (i = 0; i < characters; ++i) {
				volitions.push(new Vector.<Number>());
				for (j = 0; j < changeTypes; ++j) {
					volitions[i][j] = 0.0;
				}
			}
		}
		
		public function toString():String {
			var str:String = new String();
			var i:int;
			var j:int;
			for (i = 0; i < characters; ++i) {
				volitions.push(new Vector.<Number>());
				for (j = 0; j < changeTypes; ++j) {
					str += volitions[i][j] + "\t";
				}
				str += "\n";
			}
			return str;
		}
	}
}

