package PromWeekVisualization
{
	
	/**
	 * This is a simple data holder object, so we don't have to do stuff like "data[1]" and such.
	 * It should be pretty self explanitory
	 * @author Ryan
	 */
	public class VisSocialGameObj
	{
		var initiator:String
		var responder:String
		var game:String
		var effect:int
		var name:String
		var playerID:Number
		
		public function VisSocialGameObj(init:String, resp:String, gm:String, eff:int, pID:Number) {
			initiator = init
			responder = resp
			game = gm
			effect = eff
			this.name = init + "," + resp + "," + gm + "," + eff
			playerID = pID
		}
	}
	
}