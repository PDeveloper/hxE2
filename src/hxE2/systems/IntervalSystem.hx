package hxE2.systems;
import hxE2.EntitySystem;

/**
 * Will process entities in time intervals!
 * @author PDeveloper
 */

class IntervalSystem extends EntitySystem
{
	
	private var accumulatedTime:Float;
	private var interval:Float;

	public function new(interval:Float) 
	{
		super();
		
		this.interval = interval;
		this.accumulatedTime = 0.0;
	}
	
	override public function checkProcessing(timeStep:Float):Bool 
	{
		accumulatedTime += timeStep;
		
		if (accumulatedTime > interval)
		{
			accumulatedTime -= interval;
			return true;
		}
		
		return false;
	}
	
}