package test 
{
	import CiF.*;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestRelationshipNetwork
	{
		public var cif:CiFSingleton;
		public var relationNet:RelationshipNetwork;
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
			
			this.relationNet = RelationshipNetwork.getInstance();
			this.relationNet.initialize(this.theCast.characters.length);
			this.relationNet.setRelationship(RelationshipNetwork.DATING, theCast.characters[0], theCast.characters[1]);
			this.relationNet.setRelationship(RelationshipNetwork.ENEMIES, theCast.characters[1], theCast.characters[2]);
			this.relationNet.setRelationship(RelationshipNetwork.FRIENDS, theCast.characters[2], theCast.characters[0]);
			

		}
		
		[Test]
		public function testToXML():void {
			var testString:String = "<Relationships>\n<Relationship type=\"friends\" from=\"Robert\" to=\"Lily\" />\n<Relationship type=\"dating\" from=\"Robert\" to=\"Karen\" />\n<Relationship type=\"enemies\" from=\"Karen\" to=\"Lily\" />\n</Relationships>"; 
			//Debug.debug(this, "the RelationNetwork.toXMLString():\n" + relationNet.toXMLString());
			//Debug.debug(this, "the test string:\n" + testString);
			Assert.assertTrue(testString == relationNet.toXMLString());
			
		}
	}

}