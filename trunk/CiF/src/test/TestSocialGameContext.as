package test 
{
	import CiF.CiFSingleton;
	import CiF.CulturalKB;
	import CiF.Debug;
	import CiF.Predicate;
	import CiF.SocialGameContext;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestSocialGameContext
	{
		
		public var cif:CiFSingleton;
		public var sgc:SocialGameContext;
		public var sgc2:SocialGameContext;
		public var predicate:Predicate;


		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			this.sgc = new SocialGameContext();
			this.sgc2 = new SocialGameContext();
			this.predicate = new Predicate();
		
			sgc.gameName = "conversational flirt";
			sgc.initiator = "edward";
			sgc.responder = "karen";
			sgc.other = "";
			sgc.initiatorScore = 80;
			sgc.responderScore = 40;
			sgc.time = 4;
			sgc.effectID = 2;
			sgc.chosenItemCKB = "black nail polish";
			sgc.referenceSFDB = 2;
			
			predicate.type = Predicate.CKBENTRY
			predicate.first = "initiator";
			predicate.second = "responder";
			predicate.firstSubjectiveLink = "disagree";
			predicate.secondSubjectiveLink = "disagree";
			predicate.truthLabel = "romantic";
			predicate.isSFDB = false;
	
			sgc.queryCKB = predicate;
		}
		
		[Test]
		public function testXMLString():void {
			var baseLine:String = "<SocialGameContext gameName=\"conversational flirt\" " +
			"initiator=\"edward\" " +
			"responder=\"karen\" " +
			"other=\"\" " +
			"initiatorScore=\"80\" " +
			"responderScore=\"40\" " +
			"time=\"4\" " +
			"effectID=\"2\" " +
			"chosenItemCKB=\"black nail polish\" " +
			"socialGameContextReference=\"2\">\n" +
			"  <Predicate type=\"CKBEntry\" first=\"initiator\" second=\"responder\" firstSubjective=\"disagree\" secondSubjective=\"disagree\" label=\"romantic\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n</SocialGameContext>";
			//Debug.debug(this, "baseline:\n" + baseLine);
			//Debug.debug(this, "testXML:\n" + sgc.toXMLString());
			Assert.assertTrue(baseLine == sgc.toXMLString());
		}
		
		/*[Test]
		public function testEquals():void {
			//Debug.debug(this, "Effect Equals");
			Assert.assertTrue(Effect.equals(effect, effect));
			Assert.assertFalse(Effect.equals(effect, effect2));
		}
		
		[Test]
		public function testClone():void {
			Assert.assertTrue(Effect.equals(effect, effect.clone()));
		}*/
	}

}