package CiF 
{
	/**
	 * The Skein class represents a path through social games in the form of
	 * a tree consisting of character/user that branches when a social game
	 * is played. The Skein consists of SkeinNodes, each of which represents
	 * the a distinct states resulting from social game play choices.
	 * 
	 * @see CiF.SkeinNode
	 */
	public class Skein
	{
		/**
		 * The root of the Skein.
		 */
		public var rootNode:SkeinNode;
		
		public function Skein() 
		{
			this.rootNode = new SkeinNode();
		}
		
		/**
		 * Returns the change associated with a path through the Skein. The 
		 * path is represented by a vector of numbers each of which is an index
		 * into the "nextNodes" vector of the SkeinNodes taken in order (i.e.
		 * path[0] is the first node choice, path[1] is the index of the choice
		 * taken on the second node, etc.).
		 * @param	path The indices of the next nodes in the Skein.
		 * @return	The all of the changes associated with the social state of each
		 * Skein node in the path. Null if there is an error in the path or if there
		 * is no tree and only a root.
		 */
		public function changeOfPath(path:Vector.<int>):Vector.<Rule> {
			return null;
		}
		
	}

}