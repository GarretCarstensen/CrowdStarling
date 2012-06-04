package com.crowdstar.cs.classes.game_objects
{
	public class WorldTopDown extends World
	{
		public function WorldTopDown(x:Number = 0, y:Number = 0, widthInCells:uint=1, heightInCells:uint=1, cellSize:Number = 1, pixelsPerCell:Number = 32)
		{
			super(x, y, widthInCells, heightInCells, cellSize);
			setWorldToStageMap(pixelsPerCell, 0, 0, pixelsPerCell);
		}
	}
}