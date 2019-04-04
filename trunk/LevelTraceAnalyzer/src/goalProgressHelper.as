package  
{
	import CiF.Rule;
	/**
	 * Each one of these 'goal progress helpers' is meant to track the progress of a single
	 * goal. That means that there will be a lot of these per campaign.
	 * @author ...
	 */
	public class goalProgressHelper 
	{
		public var storyLeadCharacter:String;
		public var goalName:String;
		public var conditionRule:Rule;
		
		public function goalProgressHelper() 
		{
			conditionRule = new Rule();
		}
		
	}

}