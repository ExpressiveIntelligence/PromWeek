package test 
{
	import CiF.CiFSingleton;
	import CiF.CulturalKB;
	import CiF.Debug;
	import CiF.Proposition;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestProposition
	{
		
		public var cif:CiFSingleton;
		public var testProposition:Proposition;
		public var testProposition2:Proposition;
		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			this.testProposition = new Proposition();
			this.testProposition2 = new Proposition();
			this.testProposition.type = "subjective";
			this.testProposition.head = "edward";
			this.testProposition.connection = "likes";
			this.testProposition.tail = "pirates";

		}
		
		[Test]
		public function testXMLString():void {
			var baseLine:String = "<Proposition type=\"subjective\" head=\"edward\" connection=\"likes\" tail=\"pirates\" />";
			//Debug.debug(this, "baseline:\n" + baseLine);
			//Debug.debug(this, "testXML:\n" + testProposition.toXMLString());
			Assert.assertTrue(baseLine == testProposition.toXMLString());
		}
		
		[Test]
		public function testEquals():void {
			//Debug.debug(this, "Proposition Equals");
			Assert.assertTrue(Proposition.equals(testProposition, testProposition));
			Assert.assertFalse(Proposition.equals(testProposition, testProposition2));
		}
		
		[Test]
		public function testClone():void {
			Assert.assertTrue(Proposition.equals(testProposition, testProposition.clone()));
		}
		
	}

}