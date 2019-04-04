package PromWeekVisualization
{
	/**
	 * ...
	 * @author Ryan
	 */
	public class VisNodeDataObj 
	{
		// make the list for the IDs associated with this VNDO
		private var idList:Vector.<Number>
		// make the list of VSGO to be attached, just for funsies (possibly take this out?)
		private var vsgList:Vector.<VisSocialGameObj>
		// make the summary of this node (initiator,responder,game)
		public var name:String
		// make the weight of this node (# of times someone has come through here
		public var weight:Number
		
		
		public function VisNodeDataObj() 
		{
			idList = new Vector.<Number>()
			vsgList = new Vector.<VisSocialGameObj>()
		}
		
		/**
		 * addVSG - adds a VisSocialGameObject to the list, adds an ID to the list, and increases the weight
		 * @param	vsg the VisSocialGameObject to add
		 */
		public function addVSG(vsg:VisSocialGameObj):void {
			if(vsgList.length == 0) this.name = vsg.name
			vsgList.push(vsg)
			idList.push(vsg.playerID)
			weight = idList.length
		}
		
		/**
		 * cmpID - used to test whether or not the ID exists in this list
		 * @param	cmpID - the ID to be looked for
		 * @return true if it exists, false if not
		 */
		public function hasID(cmpID:Number):Boolean {
			for each (var id:Number in idList) {
				if(cmpID == id) return true
			}
			return false
		}
		
		public function getIDs():Vector.<Number> {
			return idList
		}
	}

}