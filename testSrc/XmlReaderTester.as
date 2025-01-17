package 
{
	import flash.display.Sprite;
	
	import org.tbyrne.debug.logging.TraceLogger;
	import org.tbyrne.siteStream.core.IPendingSSResult;
	import org.tbyrne.siteStream.core.ISSNodeDetails;
	import org.tbyrne.siteStream.core.ISSNodeSummary;
	import org.tbyrne.siteStream.xml.*;
	import org.tbyrne.siteStream.xmlTests.IXmlReaderTest;
	import org.tbyrne.siteStream.xmlTests.detailsTests.*;
	import org.tbyrne.siteStream.xmlTests.objectTests.*;
	import org.tbyrne.siteStream.xmlTests.summaryTests.*;
	import org.tbyrne.utils.methodClosure;
	
	public class XmlReaderTester extends Sprite
	{
		private var xmlReader:XmlReader;
		
		private var tests:Vector.<IXmlReaderTest>;
		private var currentTest:int = 0;
		private var failedTests:int = 0;
		
		public function XmlReaderTester(){
			super();
			
			Log.setLogger(new TraceLogger());
			
			xmlReader = new XmlReader(true);
			xmlReader.metadataNamespace = "http://www.tbyrne.org/sitestream";
			
			tests = Vector.<IXmlReaderTest>([	
												// summary tests
												new PathIdTest(),
												new UrlTest(),
												
												// details tests
												new LibraryLiteralTest(),
												new LibraryNodeTest1(),
												new NestedNodeTest(),
												
												// object tests
												new NativeObjectNodeTest(),
												new ObjectLiteralTest(),
												new ArrayLiteralTest(),
												new NumberLiteralTest(),
												new SetInterfaceTest(),
												new ClassNodeTest(),
												new ClassAttributeTest(),
												new PropertySetterTest(),
												new TypedObjectLiteralTest(),
												new TypedArrayTest1(),
												new TypedArrayTest2(),
												new TypedVectorTest1(),
												new TypedVectorTest2(),
												new TypedMethodSetterTest1(),
												new UntypedMethodSetterTest1(),
												new UntypedMethodSetterTest2(),
												new UntypedMethodSetterTest3(),
												new ConstructorTest1(),
												new ConstructorTest2(),
												new FactoryTest1(),
												new AbsReferenceTest1(),
												new AbsReferenceTest2(),
												/*new RelReferenceTest1(),
												new RelReferenceTest2(),
												new ReferenceMethodTest1(),
												new ReferenceMethodTest2(),
												new TypedReferenceMethodTest1(),
												new TypedReferenceMethodTest2(),*/
												
												]);
			
			doNextTest();
		}
		
		private function doNextTest():void{
			if(currentTest<tests.length){
				var test:IXmlReaderTest = tests[currentTest];
				doTest(test);
			}else{
				if(failedTests){
					Log.log(Log.DEV_INFO, "Tests finished, "+failedTests+" tests failed");
				}else{
					Log.log(Log.DEV_INFO, "Tests finished successfully");
				}
			}
		}
		private function doTest(test:IXmlReaderTest):void{
			var result:IPendingSSResult;
			var summary:ISSNodeSummary = xmlReader.readRootNode(test.xml);
			if(!test.testSummary(summary)){
				Log.error("Summary test failed: "+test);
				++failedTests;
			}
			if(!test.checkDetails() && !test.checkObject()){
				testFinished();
				return;
			}
			
			// load xml
			result = xmlReader.readNodeDetails(test.xml,summary);
			result.succeeded.addHandler(methodClosure(onDetailsSuccess,test));
			result.failed.addHandler(onDetailsFault);
			result.begin();
		}
		protected function onDetailsSuccess(from:IPendingSSResult, test:IXmlReaderTest):void{
			var details:ISSNodeDetails = (from.result as ISSNodeDetails);
			var result:IPendingSSResult;
			if(!test.testDetails(from.result as ISSNodeDetails)){
				Log.error("Details test failed: "+test);
				++failedTests;
			}
			if(!test.checkObject()){
				testFinished();
				return;
			}
			// load swfs
			result = xmlReader.readObject(details,null);
			result.succeeded.addHandler(methodClosure(onObjectSuccess,test));
			result.failed.addHandler(onObjectFault);
			result.begin();
		}
		protected function onDetailsFault(from:IPendingSSResult):void{
			Log.error("Details failed");
			testFinished();
		}
		protected function onObjectSuccess(from:IPendingSSResult, test:IXmlReaderTest):void{
			if(!test.testObject(from.result)){
				Log.error("Object test failed: "+test);
				++failedTests;
			}
			testFinished();
		}
		protected function onObjectFault(from:IPendingSSResult):void{
			Log.error("Parse failed");
			testFinished();
		}
		
		private function testFinished():void{
			++currentTest;
			doNextTest();
		}
		
	}
}