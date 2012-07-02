package{
	import com.netease.core.algorithm.CDelaunay;
	
	import mx.core.UIComponent;
	
	/**
	 *
	 *@author heyaolong
	 *
	 *2012-7-1
	 */
	public class DelaunayTest extends UIComponent{
		
		public function DelaunayTest()
		{
			CDelaunay.createDelaunay(null);
		}
	}
}