package test 
{
	import CiF.Cast;
	import CiF.Character;
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.Trait;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestCast
	{
		

		public var theCast:Cast;
		public var cif:CiFSingleton;

		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			this.cif.defaultState();
			this.theCast = Cast.getInstance(); //Cast is initialized in cif.clear();
			
			
			//Give the cast members some traits to test!
			theCast.characters[0].setNetworkID(0);
			theCast.characters[0].setName("Robert");
			theCast.characters[0].setTrait(Trait.WEAKLING);
			theCast.characters[0].setTrait(Trait.SEX_MAGNET);
			theCast.characters[0].setTrait(Trait.CONFIDENT);
			
			theCast.characters[1].setNetworkID(1);
			theCast.characters[1].setName("Karen");
			theCast.characters[1].setTrait(Trait.FORGIVING);
			theCast.characters[1].setTrait(Trait.CONFIDENT);
			
			theCast.characters[2].setNetworkID(2);
			theCast.characters[2].setName("Lily");
			theCast.characters[2].setTrait(Trait.DOMINEERING);
			theCast.characters[2].setTrait(Trait.AFRAID_OF_COMMITMENT);
			
		}
		
		[Test]
		public function testXMLString():void {
			this.theCast = Cast.getInstance();
			var baseLine:String = "<Cast>\n  <Character name=\"Robert\" networkID=\"0\">\n    <Trait type=\"weakling\"/>\n    <Trait type=\"sex magnet\"/>\n    <Trait type=\"confident\"/>\n  </Character>\n  <Character name=\"Karen\" networkID=\"1\">\n    <Trait type=\"forgiving\"/>\n    <Trait type=\"confident\"/>\n  </Character>\n  <Character name=\"Lily\" networkID=\"2\">\n    <Trait type=\"domineering\"/>\n    <Trait type=\"afraid of commitment\"/>\n  </Character>\n</Cast>";
			//Debug.debug(this, "baseline:\n" + baseLine);
			//Debug.debug(this, "testXML:\n" + theCast.toXMLString());
			Assert.assertTrue(baseLine == theCast.toXMLString());
		}
		
		/*[Test]
		public function testEquals():void {
			Assert.assertTrue(Cast.equals(theCast, theCast));
			//Assert.assertFalse(Cast.equals(theCast, theCast));
		}
		
		[Test]
		public function testClone():void {
			//Assert.assertTrue(Cast.equals(theCast, theCast.clone()));
		}*/

	}

}