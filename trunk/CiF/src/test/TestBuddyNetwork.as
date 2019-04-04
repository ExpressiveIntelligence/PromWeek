package test 
{
	import CiF.*;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestBuddyNetwork
	{
		public var budNet:BuddyNetwork;
		public var theCast:Cast;
		public var cif:CiFSingleton;
		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			this.cif.defaultState();
			this.budNet = BuddyNetwork.getInstance();
			this.theCast = Cast.getInstance();
			
			this.budNet.initialize(this.theCast.characters.length);
			
			//Set up the network ids of the cast (important for network testing)
			theCast.characters[0].setNetworkID(0);
			theCast.characters[1].setNetworkID(1);
			theCast.characters[2].setNetworkID(2);
			
			/*******************
			 * Setting up the Buddy Network with some default values.
			 * Note: theCast has been initialized in the CiFSingleton function 'reset'
			 * As of 5/23/2010, there are a total of three characters with which to work.
			 * ******************/
			budNet.setWeight(theCast.characters[0].networkID, theCast.characters[1].networkID, 10);
			budNet.setWeight(theCast.characters[0].networkID, theCast.characters[2].networkID, 20);
			budNet.setWeight(theCast.characters[1].networkID, theCast.characters[0].networkID, 30);
			budNet.setWeight(theCast.characters[1].networkID, theCast.characters[2].networkID, 40);
			budNet.setWeight(theCast.characters[2].networkID, theCast.characters[0].networkID, 50);
			budNet.setWeight(theCast.characters[2].networkID, theCast.characters[1].networkID, 60);
		}
		
		[Test]
		public function testToXML():void {
			var testString:String = "<Network type=\"buddy\" numChars=\"3\">\n<edge from=\"0\" to=\"1\" value=\"10\" />\n<edge from=\"0\" to=\"2\" value=\"20\" />\n<edge from=\"1\" to=\"0\" value=\"30\" />\n<edge from=\"1\" to=\"2\" value=\"40\" />\n<edge from=\"2\" to=\"0\" value=\"50\" />\n<edge from=\"2\" to=\"1\" value=\"60\" />\n</Network>"; 
			//Debug.debug(this, "the BuddyNetwork.toXMLString():\n" + budNet.toXMLString());
			//Debug.debug(this, "the test string:\n" + testString);
			Assert.assertTrue(testString == budNet.toXMLString());
			
		}

	}

}