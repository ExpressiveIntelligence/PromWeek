package  
{
	/**
	 * ...
	 * @author ...
	 */
	public class Utility 
	{
		
		public function Utility() 
		{
			
		}
		
		public static function sortXMLList(list:XMLList, fieldName:Object, options:Object = null):XMLList
		{
			 var arr:Array = new Array();
			 var ch:XML;
			 for each(ch in list)
			 {
				   arr.push(ch);
			 }
			 var resultArr:Array = fieldName==null ?
				   options==null ? arr.sort() :arr.sort(options)
				   : arr.sortOn(fieldName, options);
			
			 var result:XMLList = new XMLList();
			 for(var i:int=0; i<resultArr.length; i++)
			 {
				   result += resultArr[i];
			 }
			 return result;
		}
		
	}

}