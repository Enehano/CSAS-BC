@IsTest
class JNApexTest {
	@IsTest
	static void test() {
		String a = JNApex.str();

		System.assertEquals('1', a, 'Wrong value');
	}
}
