package test 
{
	import CiF.CiFSingleton;
	import CiF.Debug;
	import CiF.Predicate;
	import CiF.Status;
	import CiF.StatusContext;
	//import CiF.StatusNetwork;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestStatusContext
	{
		
		public var cif:CiFSingleton;
		public var testSC:StatusContext;
		public var predicate:Predicate;

		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			this.testSC = new StatusContext();
			this.predicate = new Predicate();
			
			testSC.time = 20;
			predicate.type = Predicate.STATUS;
			predicate.first = "edward";
			predicate.second = "karen";
			predicate.status = Status.ANGRY_AT
			predicate.isSFDB = false;
			testSC.predicate = predicate;
			predicate.negated = false;

		}
		
		[Test]
		public function testXMLString():void {
			var baseLine:String = "<StatusContext time=\"20\">\n  <Predicate type=\"status\" status=\"angry at\" first=\"edward\" second=\"karen\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n</StatusContext>";
			//Debug.debug(this, "baseline:\n" + baseLine);
			//Debug.debug(this, "testXML:\n" + testSC.toXMLString());
			Assert.assertTrue(baseLine == testSC.toXMLString());
		}
		
	}

}