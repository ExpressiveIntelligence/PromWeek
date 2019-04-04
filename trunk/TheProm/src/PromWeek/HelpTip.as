package PromWeek 
{
	/**
	 * This is what is meant to occupy the 'help tip' window.  It is
	 * exactly what we had before, but now instead of it only being a string,
	 * it has an understanding of what tip comes 'next' and what tip comes 'previous'
	 * so that it is easy to cycle through them.
	 * @author Ben*
	 */
	public class HelpTip
	{
		public var nextTip:String; // the dictionary index of the 'next tip';
		public var previousTip:String; // the dictionary index of the 'previous tip';
		public var theTip:String; // the actual tip itself.
		public var thisIndex:String; // let's let the tip itself know what it's own index is.
		
		public function HelpTip() 
		{
			nextTip = "next tip unset";
			previousTip = "previous tip unset";
			theTip = "the tip unset";
			thisIndex = " this index unset";
		}
		
	}

}