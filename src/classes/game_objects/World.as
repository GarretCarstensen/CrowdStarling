package classes.game_objects
{
	import classes.Game;
	import classes.components.SpriteComponent;
	import classes.components.UpdateComponent;
	
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
		public function getWorldToStageMap():WorldToStageMap { return m_worldToStageMap; }
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
	public function WorldToStageMap(xi:Number, xj:Number, yi:Number, yj:Number)
	{
		
	}
}