package test 
{
	import CiF.*;
	import org.flexunit.Assert;
	
	/**
	 * To make current:
	 * load a new authoring cut (state and library)
	 */
	public class TestPredicate {
		
		public var cif:CiFSingleton;
		
		[Before]
		public function setUp():void {
			cif = CiFSingleton.getInstance();
		}
		
		[Test]
		public function testEvalIsSFDB():void {
			/*
			 * This needs some TLC. It looks like a deep, thorough trace of the Predicate.EvalIsSFDB() pipeline
			 * needs to be done.
			 */
			var result:Boolean;
			var pred:Predicate = new Predicate();
			pred.setNetworkPredicate("responder", "initiator", "+", 20, SocialNetwork.BUDDY);
			pred.window = 2;
			pred.isSFDB = true;
			
			result = pred.evaluate(cif.cast.getCharByName("Zack"), cif.cast.getCharByName("Monica"));
			
			var sgc:SocialGameContext = this.cif.sfdb.getLatestSocialGameContext()
			var r:Rule = sgc.getChange();
			
			Debug.debug(this, "testEvalIsSFDB() latest SG: " + sgc.toXMLString());
			Debug.debug(this, "testEvalIsSFDB() latest SG's change: " + r);
			Debug.debug(this, "testEvalIsSFDB() result: " + result);
			Assert.assertTrue(result);
		}
	} 
}