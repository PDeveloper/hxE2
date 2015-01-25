package hxE2.container;

/**
 * @author PDeveloper
 */

interface IContainer
{
	
	public function has(e:Entity):Bool;
	public function remove(e:Entity):Void;
	
	public function setComponent(e:Entity, c:Component):Void;
	public function getComponent(e:Entity ):Component;
	
}