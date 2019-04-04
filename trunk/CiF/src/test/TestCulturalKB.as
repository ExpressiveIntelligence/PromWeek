package test 
{
	import CiF.*;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestCulturalKB
	{

		public var cif:CiFSingleton;

		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
		}
		
		[Test]
		public function findItemTest():void {
			var items:Vector.<String>;
			items = cif.ckb.findItem("Doug");
			//Debug.debug(this, "findItemTest() all entries with Doug. items.length: " + items.length);
			
		}
		
	}

}