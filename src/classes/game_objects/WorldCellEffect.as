package classes.game_objects
{
	public class WorldCellEffect extends GameObject
	{
		private var m_cell:WorldCell;
		
		public function WorldCellEffect(cell:WorldCell = null)
		{
			super();
			
			m_cell = cell;
		}
		
		public function setCell(cell:WorldCell):void
		{
			m_cell = cell;
		}
		
	}
}