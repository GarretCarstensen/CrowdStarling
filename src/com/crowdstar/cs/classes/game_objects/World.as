package com.crowdstar.cs.classes.game_objects
{
	import com.crowdstar.cs.classes.Game;
	import com.crowdstar.cs.classes.components.SpriteComponent;
	import com.crowdstar.cs.classes.components.UpdateComponent;
	
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
		// Cell grid
		private var m_cells:Vector.<WorldCell>;
		private var m_widthInCells:uint;
		private var m_heightInCells:uint;
		private var m_worldToStageMap:WorldToStageMap;
		
		// Components
		private var m_updateCmp:UpdateComponent;
		private var m_spriteCmp:SpriteComponent;
		
		// Camera properties
		/** WorldCamera used to display the world such that a certain world coordinate is centered on screen.*/
		private var m_camera:WorldCamera;
		
		/**
		 * Constructs a world object by creating a grid of cells. This grid begins
		 * at a given "x" and "y" (world coordinates).  It contains a number of cells
		 * equal to the given "widthInCells" in the horizontal direction, and a number of
		 * cells equal to the "heightInCells" in the vertical direction.  The height and width
		 * (world coordinates) of each cell is equall to the given "cellSize".
		 * */
		public function World(x:Number = 0, y:Number = 0, widthInCells:uint = 1, heightInCells:uint = 1, cellSize:Number = 1)
		{
			super();
			
			// Set the width and height in cells to at least 1
			m_widthInCells = Math.max(widthInCells, 1);
			m_heightInCells = Math.max(heightInCells, 1);
			
			// Construct the list of cells
			m_cells = new Vector.<WorldCell>();
			for (var j:int = 0; j < heightInCells; j++)
			{
				for (var i:int = 0; i < widthInCells; i++)
				{
					m_cells.push(new WorldCell(this, x + i * cellSize, y + j * cellSize));
				}
			}
			
			m_updateCmp = new UpdateComponent(this, update);
			m_spriteCmp = new SpriteComponent(this);
			
			Game.getInstance().setWorld(this);
		}
		
		public function getWidthInCells():uint { return m_widthInCells; }
		public function getHeightInCells():uint { return m_heightInCells; }
		public function getCells():Vector.<WorldCell> { return m_cells; }
		
		public function setWorldToStageMap(xi:Number, xj:Number, yi:Number, yj:Number):void
		{
			m_worldToStageMap = new WorldToStageMap(xi, xj, yi, yj);
		}
		
		public function getCamera():WorldCamera { return m_camera; }
		public function setCamera(camera:WorldCamera):void
		{
			m_camera = camera;
		}
		
		private function update(dt:int):Boolean
		{
			for (var i:int = 0; i < m_cells.length; i++)
			{
				m_cells[i].update(dt);
			}
			
			if (m_camera && m_camera.getTarget())
			{
				var cameraPosition:Point = m_camera.getWorldObjectCmp().getPosition();
				var cameraPositionInPixels:Point = getPositionInPixels(cameraPosition);
				var cameraRelativScreenPosition:Point = m_camera.getRelativeScreenPosition();
				var worldSprite:Sprite = m_spriteCmp.getSprite();
				worldSprite.x = worldSprite.stage.stageWidth * cameraRelativScreenPosition.x - cameraPositionInPixels.x;
				worldSprite.y = worldSprite.stage.stageHeight * cameraRelativScreenPosition.y - cameraPositionInPixels.y;
			}
			
			return true;
		}
		
		public function getSprite():Sprite { return m_spriteCmp.getSprite(); }
		
		public function addSprite(sprite:Sprite):void
		{
			m_spriteCmp.getSprite().addChild(sprite);
		}
		
		public function getPositionInPixels(worldPosition:Point):Point
		{
			return new Point(
				worldPosition.x * m_worldToStageMap.xi + worldPosition.y * m_worldToStageMap.yi,
				worldPosition.x * m_worldToStageMap.xj + worldPosition.y * m_worldToStageMap.yj
			);
		}
		
		public function getWorldPositionFromStagePosition(stagePosition:Point):Point
		{
			var x:Number = 0;
			var y:Number = 0;
			
			if (m_worldToStageMap.xi != 0)
			{
				x += stagePosition.x / m_worldToStageMap.xi;
			}
			if (m_worldToStageMap.yi != 0)
			{
				x += stagePosition.y / m_worldToStageMap.yi;
			}
			if (m_worldToStageMap.xj != 0)
			{
				y += stagePosition.x / m_worldToStageMap.xj;
			}
			if (m_worldToStageMap.yj != 0)
			{
				y += stagePosition.y / m_worldToStageMap.yj;
			}
			return new Point(x, y);
		}
		
		override public function dispose(disposeComponents:Boolean = true):Boolean
		{
			if (super.dispose(disposeComponents))
			{
				while(m_cells.length)
				{
					var cell:WorldCell = m_cells.pop();
					cell.dispose(true);
				}
				m_worldToStageMap = null;
				m_camera = null;
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