package org.tbyrne.siteStream.xmlTest.objectTests
{
	import flash.display.Sprite;
	
	import org.tbyrne.siteStream.xmlTest.AbstractXmlReaderTest;

	public class AbsReferenceTest2 extends AbstractXmlReaderTest
	{
		public function AbsReferenceTest2(){
		}
		override public function get xml():XML{
			return <Object xmlns:s="http://www.tbyrne.org/sitestream" s:path="root">
			
						<Object s:path="node" s:id="child1">
							<reference>(//root/node.child)</reference>
							<Object s:id="child2">
							</Object>
						</Object>
					</Object>
		}
								
		override public function checkObject():Boolean{
			return true;
		}
		override public function testObject(object:*):Boolean{
			return (object.child1.reference && object.child1.child2==object.child1.reference);
		}
	}
}