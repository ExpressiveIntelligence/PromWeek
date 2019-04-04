package test 
{
	import CiF.*;
	import org.flexunit.Assert;
	/**
	 * ...
	 */
	public class TestCiFSingleton
	{
		public var cif:CiFSingleton;
		
		[Before]
		public function setUp():void {
			cif = CiFSingleton.getInstance();
			cif.defaultState();
		}
		
		[Test]
		public function willBeTrue():void {
			Assert.assertTrue(true);
		}
		
	}

}