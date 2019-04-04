package CiF 
{
	/**
	 * The SkeinNode class represents a node in the tree graph comprising the
	 * explored social game progression space explored thus far in CiF (in
	 * either a game or a simulation). It a vector of SFDBContexts and a Vector
	 * of SkeinNode references that lead to the next explored social game choices
	 * after the current node.
	 */
	public class SkeinNode 
	{
		/**
		 * The one and only social game context that stores the information
		 * associated with the specific social game played at this node.
		 */
		public var gameContext:SocialGameContext;
		
		/**
		 * The contexts associated with statuses lost via timeout and state 
		 * change brought about by triggers as a result of the social game
		 * played in the current node.
		 */
		public var otherContexts:Vector.<SFDBContext>;
		/**
		 * The references to the the next SkeinNodes in the Skein.
		 */
		public var nextNodes:Vector.<SkeinNode>;
		/**
		 * A reference to the parent SkeinNode.
		 */
		public var parent:SkeinNode;
		
		public function SkeinNode() {
			this.otherContexts = new Vector.<SFDBContext>();
			this.nextNodes = new Vector.<SkeinNode>();
		}
		
		/**
		 * Determines the index of this SkeinNode in its parent's nextNodes
		 * vector.
		 * @return	Index of this node in its parent's nextNodes vector.
		 */
		public function getParentIndex():int {
			return this.parent.nextNodes.indexOf(this);
		}
		
	}

}