package com.crowdstar.cs.classes.game_objects
{
	import com.crowdstar.cs.classes.Game;
	import com.crowdstar.cs.classes.components.SpriteComponent;
	import com.crowdstar.cs.classes.components.UpdateComponent;
	
	import flash.geom.Matrix;
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
		
		/**This matrix determines how the world is rendered to the stage. The coordinate space of the world
		 * is mapped to a 2 dimensional vector for each coordinate axis.*/
		private var m_worldToStageTransform:Matrix;
		
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
		
		public function setWorldToStageTransform(a:Number, b:Number, c:Number, d:Number, tx:Number = 0, ty:Number = 0):void
		{
			if (m_worldToStageTransform)
			{
				m_worldToStageTransform.setTo(a,b,c,d,tx,ty);
			}
			else
			{
				m_worldToStageTransform = new Matrix(a,b,c,d,tx,ty);
			}
		}
		public function setWorldToStageTransformWithMatrix(transform:Matrix):void
		{
			m_worldToStageTransform = transform;
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
				var cameraPositionInPixels:Point = getStagePosition(cameraPosition);
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
		
		public function getStagePosition(worldPosition:Point):Point
		{
			return new Point(
				worldPosition.x * m_worldToStageTransform.a + worldPosition.y * m_worldToStageTransform.b + m_worldToStageTransform.tx,
				worldPosition.x * m_worldToStageTransform.c + worldPosition.y * m_worldToStageTransform.d + m_worldToStageTransform.ty
			);
		}
		
		public function getWorldPositionFromStagePosition(stagePosition:Point):Point
		{
			var x:Number = 0;
			var y:Number = 0;
			if (a * d - b * c != 0)
			{
				var a:Number = m_worldToStageTransform.a;
				var b:Number = m_worldToStageTransform.b;
				var c:Number = m_worldToStageTransform.c;
				var d:Number = m_worldToStageTransform.d;
				var tx:Number = m_worldToStageTransform.tx;
				var ty:Number = m_worldToStageTransform.ty;
				x = (d * stagePosition.x - b * stagePosition.y) / (a * d - b * c);
				y = (-c * stagePosition.x + a * stagePosition.y) / (a * d - b * c);
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
				m_worldToStageTransform = null;
				m_camera = null;
			}
			return true;
		}
	}
}