/**
 *	Combinator class used to generate all combinations of items in array.
 * 
 *	@author Tomas Lehuta (lharp@lharp.net)
 *	@version 1.0
 */
package UI
{
	public class Combinator
	{
		private var $n:Number;
		private var $k:Number;
		
		private var $data:Array;
		private var $comb:Array;
		private var $total:Number;
		private var $left:Number;
		
		/**
		 *	Combinator constructor
		 *
		 * 	@param	data	Data array to combine
		 * 	@param	size	Size of combination arrays
		 */
		public function Combinator(data:Array, size:Number)
		{
			$data = data;
			
			init(size);
		}
		
		/**
		 *	Returns the number of combinations left
		 *	
		 *	@return	Number of combinations
		 */
		public function get left():Number
		{
			return $left;
		}
		
		/**
		 *	Returns the number of total combinations
		 *	
		 *	@return	Number of combinations
		 */
		public function get total():Number
		{
			return $total;
		}
		
		/**
		 *	Initializes combinator with given combination number.
		 *	
		 *	@param	k	Combination number that defines the number of items
		 */
		public function init(k:Number):void
		{
			$n = $data.length;
			$k = (k != -1 && k <= $n) ? k : $n;
			
			$comb = new Array($k);
			$total = factorial($n) / (factorial($k) * factorial($n - $k));
			
			reset();
		}
		
		/**
		 * 	Resets combinator.
		 */
		public function reset():void
		{
			var len:Number = $comb.length;
			for (var i:Number = 0; i < len; i++) {
				$comb[i] = i;
			}
			$left = $total;
		}
		
		/**
		 * 	Checks if combinator has some more combinations.
		 * 	
		 * 	@return	True or false
		 */
		public function hasMore():Boolean
		{
			return $left > 0;
		}
		
		/**
		 * 	Returns current combination.
		 * 	
		 * 	@return	Current combination array
		 */
		public function current():Array
		{
			// create current data combination
			var data:Array = new Array($k);
			for (var i:Number = 0; i < $k; i++) {
				data[i] = $data[$comb[i]];
			}
			return data;
		}
		
		/**
		 * 	Returns next combination.
		 * 	
		 * 	@return	Next combination array
		 */
		public function next():Array
		{
			if ($left > 0) {
				if ($left-- < $total) {
					var p:Number = $k - 1;
					while ($comb[p] == $n - $k + p) p--;
					$comb[p]++;
					
					for (var r:Number = p + 1; r < $k; r++) {
						$comb[r] = $comb[p] + r - p;
					}
				}
				return current();
			}
			return new Array();
		}
		
		/**
		 * 	Generates all combinations of given data with given length.
		 * 	
		 * 	@param	data	Data array to combine
		 * 	@param	size	Size of combination arrays
		 * 	@return	Array of all combinations
		 */
		public static function generate(data:Array, size:Number):Array
		{
			var result:Array = new Array();
			var c:Combinator = new Combinator(data, size);
			while (c.hasMore()) {
				result.push(c.next());
			}
			return result;
		}
		
		/**
		 *	Calculates factorial value of given number.
		 *	
		 *	@param	n	Number value
		 *	@return	Factorial value
		 */
		private static function factorial(n:Number):Number
		{
			var val:Number = 1;
			for (var i:Number = n; i > 1; i--) val *= i;
			return val;
		}
		
	}
}