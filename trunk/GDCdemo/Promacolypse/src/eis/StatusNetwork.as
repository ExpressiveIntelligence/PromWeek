package eis 
{
	/**
	 * This class holds a separate instance of the SocialNetwork class for each
	 * of our social statuses. If the entry in that network is non-zero, we 
	 * that status is considered true between the two characters. If the number
	 * is zero, the status is not true.
	 * 
	 * Statuses are not consider exclusive in this implementations (edward and
	 * lily can be friends and enemies simultaneously). When a status is set
	 * or removed, entries are removed transitively.
	 * 
	 * Example of use:
	 * var sn:StatusNetwork = new StatusNetwork(characterCount);
	 * sn.setStatus(StatusNetwork.DATING, lily, edward);
	 * sn.removeStatus(StatusNetwork.DATING, edward, lily);
	 * 
	 */
	public class StatusNetwork
	{
		
		public static const FRIEND:int = 1;
		public static const DATING:int = 2;
		public static const FIGHTING:int = 3;
		public static const ENEMIES:int = 4;
		
		public var friendNet:SocialNetwork;
		public var datingNet:SocialNetwork;	
		public var fightingNet:SocialNetwork;	
		public var enemiesNet:SocialNetwork;
		
		public function StatusNetwork(characters:int) {
			this.friendNet = new SocialNetwork(characters);
			this.datingNet = new SocialNetwork(characters);
			this.fightingNet = new SocialNetwork(characters);
			this.enemiesNet = new SocialNetwork(characters);
		}
		
		public function setStatus(status:int, a:Character, b:Character):void {
			if (status == FRIEND) {
				this.friendNet.setWeight(a.networkID, b.networkID, 1.0);
				this.friendNet.setWeight(b.networkID, a.networkID, 1.0);
			}else if (status == DATING) {
				this.datingNet.setWeight(a.networkID, b.networkID, 1.0);
				this.datingNet.setWeight(b.networkID, a.networkID, 1.0);
			}else if (status == FIGHTING) {
				this.fightingNet.setWeight(a.networkID, b.networkID, 1.0);
				this.fightingNet.setWeight(b.networkID, a.networkID, 1.0);
			}else if (status == ENEMIES) {
				this.enemiesNet.setWeight(a.networkID, b.networkID, 1.0);
				this.enemiesNet.setWeight(b.networkID, a.networkID, 1.0);
			}
		}
		
		public function removeStatus(status:int, a:Character, b:Character):void {
			if (status == FRIEND) {
				this.friendNet.setWeight(a.networkID, b.networkID, 0.0);
				this.friendNet.setWeight(b.networkID, a.networkID, 0.0);
			}else if (status == DATING) {
				this.datingNet.setWeight(a.networkID, b.networkID, 0.0);
				this.datingNet.setWeight(b.networkID, a.networkID, 0.0);
			}else if (status == FIGHTING) {
				this.fightingNet.setWeight(a.networkID, b.networkID, 0.0);
				this.fightingNet.setWeight(b.networkID, a.networkID, 0.0);
			}else if (status == ENEMIES) {
				this.enemiesNet.setWeight(a.networkID, b.networkID, 0.0);
				this.enemiesNet.setWeight(b.networkID, a.networkID, 0.0);
			}
		}
		
		public function getStatus(status:int, a:Character, b:Character):int {
			if (status == FRIEND) {
				return this.friendNet.getWeight(a.networkID, b.networkID);
			}else if (status == DATING) {
				return this.datingNet.getWeight(a.networkID, b.networkID);
			}else if (status == FIGHTING) {
				return this.fightingNet.getWeight(a.networkID, b.networkID);
			}else if (status == ENEMIES) {
				return this.enemiesNet.getWeight(a.networkID, b.networkID);
			}
			return 0.0;
			
		}
	}

}