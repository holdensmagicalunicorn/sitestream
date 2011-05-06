package org.tbyrne.siteStream.xmlTest.objectTests
{
	import org.tbyrne.siteStream.xmlTest.AbstractXmlReaderTest;
	import org.tbyrne.siteStream.TestObject;

	public class TypedObjectLiteralTest extends AbstractXmlReaderTest
	{
		public function TypedObjectLiteralTest(){
			var includeClass:Class = TestObject;
		}
		
		override public function get xml():XML{
			return <test:TestObject xmlns:test="org.tbyrne.siteStream" sprite="{x:10}"/>;
		}
		
		override public function checkObject():Boolean{
			return true;
		}
		override public function testObject(object:*):Boolean{
			return (object.sprite && object.sprite.x==10);
		}
	}
}