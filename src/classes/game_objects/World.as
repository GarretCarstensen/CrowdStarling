package classes.game_objects
{
	import classes.Game;
	import classes.components.SpriteComponent;
	import classes.components.UpdateComponent;
	
	import flash.geom.Point;
	
	import starling.display.Sprite;
	
	/**
	 * The world class comprises of cells to perform game logic operation
	 * via a cellular modulation update process.  Each frame, the world
	 * runs the update method on each of its cells.  Each cell stores its
	 * state as well as operations on it which occured during the update
	 * process.
	 * */
	public class World extends GameObject
	{
		private var m_cells:Vector.<WorldCell>;
		private var m_width:uint;
		private var m_height:uint;
		private var m_worldToStageMap:WorldToStageMap;
		
		private var m_update:UpdateComponent;
		private var m_sprite:SpriteComponent;
		
		public function World(width:uint = 1, height:uint = 1)
		{
			super();
			
			m_width = Math.max(width, 1);
			m_height = Math.max(height, 1);
			
			m_cells = new Vector.<WorldCell>();
			for (var y:int = 1; y <= height; y++)
			{
				for (var x:int = 1; x <= width; x++)
				{
					m_cells.push(new WorldCell(x,y));
				}
			}
			
			m_update = new UpdateComponent(this, update);
			m_sprite = new SpriteComponent(this);
			
			getGame().setWorld(this);
		}
		
		public function getWidth():uint { return m_width; }
		public function getHeight():uint { return m_height; }
		
		public function setWorldToStageMap(xi:Number, xj:Number, yi:Number, yj:Number):void
		{
			m_worldToStageMap = new WorldToStageMap(xi, xj, yi, yj);
		}
		
		private function update(dt:int):Boolean
		{
			for (var i:int = 0; i < m_cells.length; i++)
			{
				m_cells[i].update(dt);
			}
			return true;
		}
		
		public function getSprite():Sprite { return m_sprite.getSprite(); }
		
		public function addSprite(sprite:Sprite):void
		{
			m_sprite.getSprite().addChild(sprite);
		}
		
		public function getStagePosition(worldPosition:Point):Point
		{
			return new Point(
				worldPosition.x * m_worldToStageMap.xi + worldPosition.y * m_worldToStageMap.yi,
				worldPosition.x * m_worldToStageMap.xj + worldPosition.y * m_worldToStageMap.yj
			);
		}
		
		override public function dispose():Boolean
		{
			while(m_cells.length)
			{
				var cell:WorldCell = m_cells.pop();
				cell.dispose();
			}
			return true;
		}
	}
}

/**
 * This map determines how the world is rendered to the stage. The coordinate space of the world
 * is mapped to a 2 dimensional vector for each coordinate axis. For example, each unit in the
 * x direction in the world coordinate space is mapped to xi points horizontally on the stage and
 * xj units vertically on the stage.
 * */
class WorldToStageMap
{
	private var m_xi:Number;
	private var m_xj:Number;
	private var m_yi:Number;
	private var m_yj:Number;
	
	public function get xi():Number { return m_xi; }
	public function get xj():Number { return m_xj; }
	public function get yi():Number { return m_yi; }
	public function get yj():Number { return m_yj; }
	
	public function WorldToStageMap(xi:Number = 1, xj:Number = 1, yi:Number = 1, yj:Number = 1)
	{
		m_xi = xi;
		m_xj = xj;
		m_yi = yi;
		m_yj = yj;
	}
}