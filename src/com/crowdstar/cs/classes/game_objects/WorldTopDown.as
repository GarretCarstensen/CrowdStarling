package com.crowdstar.cs.classes.game_objects
{
	public class WorldTopDown extends World
	{
		public function WorldTopDown(width:uint=1, height:uint=1)
		{
			super(width, height);
			setWorldToStageMap(32, 0, 0, 32);
		}
	}
}