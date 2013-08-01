package dc.mvc
{
	import mx.core.IVisualElement;

	public interface IRequestController	{
		
		function load(params:*) : void;
		
		function postBack(params:*) : void;
		
		function get getView() : IVisualElement;
		
	}
}