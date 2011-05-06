package org.tbyrne.siteStream.xmlTest.objectTests
{
	import org.tbyrne.siteStream.xmlTest.AbstractXmlReaderTest;
	import org.tbyrne.siteStream.TestObject;

	public class TypedVectorTest1 extends AbstractXmlReaderTest
	{
		public function TypedVectorTest1(){
			var includeClass:TestObject;
		}
		override public function get xml():XML{
			return 	<test:TestObject xmlns:test="org.tbyrne.siteStream">
						<vector>
							<test:TestObject property="0"/>
							<test:TestObject property="1"/>
						</vector>
					</test>;
		}
		
		override public function checkObject():Boolean{
			return true;
		}
		override public function testObject(object:*):Boolean{
			return (object.vector && object.vector.length==2 && object.vector[0].property==0 && object.vector[1].property==1);
		}
	}
}