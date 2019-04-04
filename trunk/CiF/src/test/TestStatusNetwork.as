package test 
{
	import CiF.*;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestStatusNetwork
	{
		public var cif:CiFSingleton;
		public var statusNet:StatusNetwork;
		public var statusNet2:StatusNetwork;
		public var theCast:Cast;
		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			this.cif.defaultState();
			this.theCast = Cast.getInstance();
			
			//Set up the network ids of the cast (important for network testing)
			theCast.characters[0].setNetworkID(0);
			theCast.characters[0].setName("Robert");
			
			theCast.characters[1].setNetworkID(1);
			theCast.characters[1].setName("Karen");
			
			theCast.characters[2].setNetworkID(2);
			theCast.characters[2].setName("Lily");
			
			this.statusNet = StatusNetwork.getInstance();
			this.statusNet2 = StatusNetwork.getInstance();
			this.statusNet.initialize(this.theCast.characters.length);
			this.statusNet2.initialize(this.theCast.characters.length);
			this.statusNet.setStatus(StatusNetwork.DESPERATE, theCast.characters[2]);
			this.statusNet2.setStatus(StatusNetwork.DESPERATE, theCast.characters[2]);
			this.statusNet.setStatus(StatusNetwork.HAS_CRUSH, theCast.characters[1], theCast.characters[2]);
			this.statusNet.setStatus(StatusNetwork.JEALOUS, theCast.characters[2], theCast.characters[0]);
			
		}
		
		[Test]
		public function testToXML():void {
			var testString:String = "<Statuses>\n<Status type=\"desperate\" from=\"Lily\" to=\"\" />\n<Status type=\"has crush\" from=\"Karen\" to=\"Lily\" />\n<Status type=\"jealous\" from=\"Lily\" to=\"Robert\" />\n</Statuses>"; 
			//Debug.debug(this, "the StatusNetwork.toXMLString():\n" + statusNet.toXMLString());
			//Debug.debug(this, "the test string:\n" + testString);
			Assert.assertTrue(testString == statusNet.toXMLString());
			
		}
		
		[Test]
		public function testStatusNetworkEquals():void {
			//Debug.debug(this, "testStatusNetworkEquals(): " + statusNet);
			Assert.assertTrue(StatusNetwork.equals(statusNet, statusNet));
			//you cannot have two StatusNetwork instances at the same time as they
			//are singletons. Commenting out the test below.
			//Assert.assertFalse(StatusNetwork.equals(statusNet, statusNet2));
		}
		
		//Singletons don't need clones.
		/*[Test]
		public function testStatusNetworkClone():void {
			//Assert.assertTrue(StatusNetwork.equals(statusNet, statusNet.clone()));  //Not sure about SocialNetwork.clone as super to all networks?
		}*/
	}

}