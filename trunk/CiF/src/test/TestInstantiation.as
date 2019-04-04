package test 
{
	import CiF.*;
	import org.flexunit.Assert;
	
	/**
	 * ...
	 * @author Travis
	 */
	public class TestInstantiation {
		public var inst:Instantiation;
		public var inst2:Instantiation;

		public var line:LineOfDialogue;
		
		[Before]
		public function setUp():void {
			inst = new Instantiation();
			inst2 = new Instantiation();
			line = new LineOfDialogue();
			
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
			
			inst.id = 3;
			inst.name = "test1";
			inst2.id = 2;
			inst2.name = "test2";
			inst.lines.push(line);
			inst.lines.push(line);
			inst2.lines.push(line);

		}
		//toString testing
		
		[Test]
		public function testInstantiation():void {
			var baseline:String = "1\ninitiator:initiator's line\naccuse\nhappy\naccuse\nhappy\naccuse\nhappy\n5\nfalse\nfalse\nresponder\nfalse\n1\ninitiator:initiator's line\naccuse\nhappy\naccuse\nhappy\naccuse\nhappy\n5\nfalse\nfalse\nresponder\nfalse\n";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "testToString():\n" + inst.toString());
			Assert.assertTrue( baseline == inst.toString());
		}
		
		/**
		 * TODO: XML string from LineOfDialogue needs to be updated with a line for each role and a primary speaker.
		 */
		[Test]
		public function testXMLInstantiation():void {
			var baseline:String = "<Instantiation id=\"3\" name=\"test1\">\n";
			baseline += "<LineOfDialogue lineNumber=\"1\" initiatorLine=\"initiator's line\" responderLine=\"responder's line\" otherLine=\"other's line\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />\n";
			baseline += "<LineOfDialogue lineNumber=\"1\" initiatorLine=\"initiator's line\" responderLine=\"responder's line\" otherLine=\"other's line\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />\n";
			baseline += "<ToC1>null</ToC1>\n";
			baseline += "<ToC2>null</ToC2>\n";
			baseline += "<ToC3>null</ToC3>\n";
			baseline += "</Instantiation>\n";
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "testtoXMLString():\n" + inst.toXMLString());
			Assert.assertTrue(baseline == inst.toXMLString());
		}

		[Test]
		public function testInstantiationEquals():void {
			Assert.assertTrue(Instantiation.equals(inst, inst));
			Assert.assertFalse(Instantiation.equals(inst, inst2));
		}
		
		[Test]
		public function testInstantiationClone():void {
			Assert.assertTrue(Instantiation.equals(inst, inst.clone()));
		}
	}

}