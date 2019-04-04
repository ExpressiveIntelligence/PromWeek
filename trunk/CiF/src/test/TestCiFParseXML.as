package test 
{
	import CiF.BuddyNetwork;
	import CiF.Cast;
	import CiF.CiFSingleton;
	import CiF.CoolNetwork;
	import CiF.CulturalKB;
	import CiF.Debug;
	import CiF.RelationshipNetwork;
	import CiF.RomanceNetwork;
	import CiF.SocialFactsDB;
	import CiF.SocialGamesLib;
	//import CiF.StatusNetwork;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestCiFParseXML
	{
		public var cif:CiFSingleton;
		public var cast:Cast;
		public var sfdb:SocialFactsDB;
		public var buddyNetwork:BuddyNetwork;
		public var coolNetwork:CoolNetwork;
		public var romanceNetwork:RomanceNetwork;
		//public var statusNetwork:StatusNetwork;
		public var relationshipNetwork:RelationshipNetwork;
		public var socialGamesLib:SocialGamesLib;
		public var ckb:CulturalKB;
		
		[Before]
		public function setUp():void {
			cif = CiFSingleton.getInstance();
			cif.clear();
			

		}
		
		[Test]
		public function testCiFSingletonParse():void {
			//Debug.debug(this, "and now I am testing!");
			//cif.getStateFromXML();
				/* PRINT OUT THE CURRENT STATE JUST FOR FUN! */
/*
				cast = Cast.getInstance();
				sfdb = SocialFactsDB.getInstance();
				buddyNetwork = BuddyNetwork.getInstance();
				coolNetwork = CoolNetwork.getInstance();
				romanceNetwork = RomanceNetwork.getInstance();
				statusNetwork = StatusNetwork.getInstance();
				relationshipNetwork = RelationshipNetwork.getInstance();
				socialGamesLib = SocialGamesLib.getInstance();
				ckb = CulturalKB.getInstance();
				
				Debug.debug(this, cast.toXMLString());
				Debug.debug(this, sfdb.toXMLString());
				Debug.debug(this, buddyNetwork.toXMLString());
				Debug.debug(this, coolNetwork.toXMLString());
				Debug.debug(this, romanceNetwork.toXMLString());
				Debug.debug(this, statusNetwork.toXMLString());
				Debug.debug(this, relationshipNetwork.toXMLString());
				Debug.debug(this, socialGamesLib.toXMLString());
				Debug.debug(this, ckb.toXMLString());
				*/
				//cif = CiFSingleton.getInstance();
				//cif.printXMLString();
		}
		
	}

}