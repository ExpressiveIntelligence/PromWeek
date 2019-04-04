package test 
{
	import CiF.*;
	import org.flexunit.Assert;
	
	/**
	 * ...
	 * @author Travis
	 */
	public class TestLineOfDialogue {
		public var line:LineOfDialogue;
		public var line2:LineOfDialogue;
		public var cif:CiFSingleton;
		
		[Before]
		public function setUp():void {
			cif = CiFSingleton.getInstance();
			cif.clear();
			line = new LineOfDialogue();
			line2 = new LineOfDialogue();
			line.lineNumber = 1;
			line.initiatorLine = "initiator's line";
			line.responderLine = "responder's line";
			line.otherLine = "other's line";
			line.primarySpeaker = "initiator";
			line.initiatorBodyAnimation = "accuse";
			line.initiatorFaceAnimation = "happy";
			line.responderBodyAnimation = "accuse";
			line.responderFaceAnimation = "happy";
			line.otherBodyAnimation = "accuse";
			line.otherFaceAnimation = "happy";
			line.time = 5;
			line.initiatorIsThought = false;
			line.responderIsThought = false;
			line.otherIsThought = false;
			line.initiatorIsPicture = false;
			line.responderIsPicture = false;
			line.otherIsPicture = false;
			line.initiatorAddressing = "responder";
			line.responderAddressing = "initiator";
			line.otherAddressing = "initiator";
			line.isOtherChorus = false;
			
		}
		//toString testing
		
		[Test]
		public function testLineOfDialogue():void {
			//trace(line.toString());
			var baseline:String = "1\ninitiator:initiator's line\naccuse\nhappy\naccuse\nhappy\naccuse\nhappy\n5\nfalse\nfalse\nresponder\nfalse";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "toString:\n" + line.toString());
			Assert.assertTrue(baseline == line.toString());
		}
		
		[Test]
		public function testXMLLineOfDialogue():void {
			//trace(line.toXMLString());
			var baseline:String = "<LineOfDialogue lineNumber=\"1\" initiatorLine=\"initiator's line\" responderLine=\"responder's line\" otherLine=\"other's line\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "toXMLString():\n" + line.toXMLString());
			Assert.assertTrue(baseline == line.toXMLString());
		}
		
		[Test]
		public function testEquals():void {
			Assert.assertTrue(LineOfDialogue.equals(line, line));
			Assert.assertFalse(LineOfDialogue.equals(line, line2));
		}
		
		[Test]
		public function testClone():void {
			Assert.assertTrue(LineOfDialogue.equals(line, line.clone()));
		}

	}

}