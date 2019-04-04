package test 
{
	import CiF.*;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestSocialNetwork
	{
		public var socNet:SocialNetwork;
		public var theCast:Cast;
		public var cif:CiFSingleton;
		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			this.cif.defaultState();
			this.socNet = new SocialNetwork();
			this.theCast = Cast.getInstance();
			
			this.socNet.initialize(this.theCast.characters.length);
			
			//Set up the network ids of the cast (important for network testing)
			theCast.characters[0].setNetworkID(0);
			theCast.characters[1].setNetworkID(1);
			theCast.characters[2].setNetworkID(2);
			
			socNet.type = SocialNetwork.BUDDY;
			socNet.setWeight(theCast.characters[0].networkID, theCast.characters[1].networkID, 10);
			socNet.setWeight(theCast.characters[0].networkID, theCast.characters[2].networkID, 20);
			socNet.setWeight(theCast.characters[1].networkID, theCast.characters[0].networkID, 30);
			socNet.setWeight(theCast.characters[1].networkID, theCast.characters[2].networkID, 40);
			socNet.setWeight(theCast.characters[2].networkID, theCast.characters[0].networkID, 50);
			socNet.setWeight(theCast.characters[2].networkID, theCast.characters[1].networkID, 60);
		}
		
		[Test]
		public function testToXML():void {
			var baseline:String = "<Network type=\"buddy\" numChars=\"3\">\n<edge from=\"0\" to=\"1\" value=\"10\" />\n<edge from=\"0\" to=\"2\" value=\"20\" />\n<edge from=\"1\" to=\"0\" value=\"30\" />\n<edge from=\"1\" to=\"2\" value=\"40\" />\n<edge from=\"2\" to=\"0\" value=\"50\" />\n<edge from=\"2\" to=\"1\" value=\"60\" />\n</Network>"; 
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "the BuddyNetwork.toXMLString():\n" + socNet.toXMLString());
			Assert.assertTrue(baseline == socNet.toXMLString());
			
		}
	}

}