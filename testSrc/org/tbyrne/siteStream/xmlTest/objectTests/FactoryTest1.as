package org.tbyrne.siteStream.xmlTest.objectTests
{
	import org.tbyrne.siteStream.TestObject;
	import org.tbyrne.siteStream.TestObjectFactory;
	import org.tbyrne.siteStream.xmlTest.AbstractXmlReaderTest;

	public class FactoryTest1 extends AbstractXmlReaderTest
	{
		public function FactoryTest1()
		{
			super();
			TestObject;
			TestObjectFactory;
		}
		override public function get xml():XML{
			return <Object xmlns:test="org.tbyrne.siteStream" xmlns:s="http://www.tbyrne.org/sitestream">
						<s:TestObjectFactory s:id="testFactory" sprite="{x:20}"/>
			
						<s:pools>
							<s:ObjectPool classpath="org.tbyrne.siteStream.TestObject" create="testFactory.createTestObject" destroy="testFactory.returnTestObject"/>
						</s:pools>

						<s:TestObject s:id="test1"/>;
						<s:TestObject s:id="test2"/>;
					</Object>
			
		}
		
		override public function checkObject():Boolean{
			return true; 
		}
		override public function testObject(object:*):Boolean{
			return (object.test1 && object.test1.sprite && object.test1.sprite==object.test2.sprite && object.test1.sprite.x==20);
		}
	}
}