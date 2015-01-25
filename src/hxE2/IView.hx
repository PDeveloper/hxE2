package hxE2;
import hxE2.bits.BitFlag;

/**
 * @author PDeveloper
 */

interface IView
{
	
	private var includeFlag:BitFlag;
	private var excludeFlag:BitFlag;
	
	@:allow(hxE2.container.SlaveContainer)
	@:allow(hxE2.EntityWorld)
	private function push(e:Entity):Void;
	
	public function update():Void;
	public function dispose():Void;
	
}