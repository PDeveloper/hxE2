package hxE2.core;

/**
 * ...
 * @author PDeveloper
 */

class EntityId
{
	
	private var _id:Int;
	
	public function new(id:Int):Void
	{
		_id = id;
	}
	
	function get_id():Int
	{
		return _id;
	}
	
	public var id(get_id, null):Int;
	
}