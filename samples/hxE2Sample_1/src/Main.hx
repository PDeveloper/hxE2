package ;

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import haxe.Timer;
import hxE2.Component;
import hxE2.EntityWorld;
import hxE2.View;

/**
 * NOTE: This sample was used for unit testing and is not meant to represent best practices in ANY way!!!
 * @author PDeveloper
 */

class PositionComponent extends Component
{
	
	public var x:Float;
	public var y:Float;
	
	public function new(x:Float = 0.0, y:Float = 0.0):Void
	{
		super();
		this.x = x;
		this.y = y;
	}
	
}

class VelocityComponent extends Component
{
	
	public var x:Float;
	public var y:Float;
	
	public function new(x:Float = 0.0, y:Float = 0.0):Void
	{
		super();
		this.x = x;
		this.y = y;
	}
	
}

class CircleComponent extends Component
{
	
	public var radius:Float;
	
	public function new(radius:Float):Void
	{
		super();
		this.radius = radius;
	}
	
}

class RectComponent extends Component
{
	
	public var width:Float;
	public var height:Float;
	
	public function new(width:Float, height:Float):Void
	{
		super();
		this.width = width;
		this.height = height;
	}
	
}

class ColourComponent extends Component
{
	
	public var colour:Int;
	public var alpha:Float;
	
	public function new(colour:Int, alpha:Float = 1.0):Void
	{
		super();
		this.colour = colour;
		this.alpha = alpha;
	}
	
}

class Main
{
	
	private var stage:Stage;
	
	private var world:EntityWorld;
	private var container:Sprite;
	
	private var timestamp:Float;
	
	private var velocityView:View2<PositionComponent, VelocityComponent>;
	
	private var renderCircleView:View3<PositionComponent, CircleComponent, ColourComponent>;
	private var circles:Array<Shape>;
	private var renderRectView:View3<PositionComponent, RectComponent, ColourComponent>;
	private var rects:Array<Shape>;
	
	public function new(stage:Stage):Void
	{
		this.stage = stage;
		container = new Sprite();
		stage.addChild(container);
		
		world = new EntityWorld();
		
		for (i in 0...1024) createRandomEntity();
		
		velocityView = new View2(world, PositionComponent, VelocityComponent);
		renderCircleView = new View3(world, PositionComponent, CircleComponent, ColourComponent);
		circles = new Array<Shape>();
		renderRectView = new View3(world, PositionComponent, RectComponent, ColourComponent);
		rects = new Array<Shape>();
		
		timestamp = Timer.stamp();
		stage.addEventListener(Event.ENTER_FRAME, update);
	}
	
	private function update(e:Event):Void
	{
		var delta = -(timestamp - (timestamp = Timer.stamp()));
		
		velocityView.update();
		for (e in velocityView.entities)
		{
			var position = velocityView.get1(e);
			var velocity = velocityView.get2(e);
			
			position.x += velocity.x * delta;
			position.y += velocity.y * delta;
			
			if (position.x < 0.0 || position.x > stage.stageWidth)
			{
				velocity.x = -velocity.x;
				velocityView.set2(e, velocity);
			}
			if (position.y < 0.0 || position.y > stage.stageHeight)
			{
				velocity.y = -velocity.y;
				velocityView.set2(e, velocity);
			}
			
			if (position.x < 0.0) position.x = 0.0;
			else if (position.x > stage.stageWidth) position.x = stage.stageWidth;
			
			if (position.y < 0.0) position.y = 0.0;
			else if (position.y > stage.stageHeight) position.y = stage.stageHeight;
			
			velocityView.set1(e, position);
		}
		
		renderCircleView.update();
		for (e in renderCircleView.removedEntities)
		{
			var shape = circles[e.id];
			container.removeChild(shape);
		}
		for (e in renderCircleView.addedEntities)
		{
			var position = renderCircleView.get1(e);
			var circle = renderCircleView.get2(e);
			var colour = renderCircleView.get3(e);
			
			var shape = new Shape();
			drawCircle(shape, circle.radius, colour.colour, colour.alpha);
			
			circles[e.id] = shape;
			container.addChild(shape);
		}
		for (e in renderCircleView.entities)
		{
			var position = renderCircleView.get1(e);
			var circle = renderCircleView.get2(e);
			var colour = renderCircleView.get3(e);
			
			var shape = circles[e.id];
			updateShape(shape, position.x, position.y);
		}
		
		renderRectView.update();
		for (e in renderRectView.removedEntities)
		{
			var shape = rects[e.id];
			container.removeChild(shape);
		}
		for (e in renderRectView.addedEntities)
		{
			var position = renderRectView.get1(e);
			var rect = renderRectView.get2(e);
			var colour = renderRectView.get3(e);
			
			var shape = new Shape();
			drawRect(shape, rect.width, rect.height, colour.colour, colour.alpha);
			
			rects[e.id] = shape;
			container.addChild(shape);
		}
		for (e in renderRectView.entities)
		{
			var position = renderRectView.get1(e);
			var rect = renderRectView.get2(e);
			var colour = renderRectView.get3(e);
			
			var shape = rects[e.id];
			updateShape(shape, position.x, position.y);
		}
	}
	
	private function updateShape(shape:Shape, x:Float, y:Float):Void
	{
		shape.x = x;
		shape.y = y;
	}
	
	private function drawCircle(shape:Shape, radius:Float, colour:Int, alpha:Float):Void
	{
		var g = shape.graphics;
		g.clear();
		g.beginFill(colour, alpha);
		g.drawCircle(0.0, 0.0, radius);
	}
	
	private function drawRect(shape:Shape, width:Float, height:Float, colour:Int, alpha:Float):Void
	{
		var g = shape.graphics;
		g.clear();
		g.beginFill(colour, alpha);
		g.drawRect(-width * 0.5, -height * 0.5, width, height);
	}
	
	private function createRandomEntity():Void
	{
		var e = world.create();
		
		var position = new PositionComponent(Math.random() * stage.stageWidth, Math.random() * stage.stageHeight);
		e.setComponent(position);
		
		var velocity = new VelocityComponent(Math.random() * 128.0 - 64.0, Math.random() * 128.0 - 64.0);
		e.setComponent(velocity);
		
		var choice = Math.random();
		if (choice < 0.55)
		{
			var circle = new CircleComponent(6.0 + Math.random() * 16.0);
			e.setComponent(circle);
		}
		else if (choice > 0.45)
		{
			var rect = new RectComponent(6.0 + Math.random() * 16.0, 6.0 + Math.random() * 16.0);
			e.setComponent(rect);
		}
		var colour = new ColourComponent(Std.int(Math.random() * 0xFFFFFF));
		e.setComponent(colour);
	}
	
	static function main():Void
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// entry point
		
		var main = new Main(stage);
	}
	
}