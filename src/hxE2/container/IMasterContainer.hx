package hxE2.container;
import hxE2.View.IView;

/**
 * @author PDeveloper
 */

interface IMasterContainer extends IContainer
{
	
	public function getSlaveContainer(view:IView):IContainer;
	
}