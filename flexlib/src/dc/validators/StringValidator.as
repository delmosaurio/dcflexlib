package dc.validators
{
	import mx.validators.StringValidator;
	
	public class StringValidator extends mx.validators.StringValidator
	{
		public function StringValidator() {
			super();
			this.requiredFieldError = "*";
		}
	}
}