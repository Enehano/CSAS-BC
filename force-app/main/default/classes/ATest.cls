@IsTest
class ATest {
	@IsTest
	static void aa() {
		String a = A.aa();
		System.assertEquals('a', a, 'a');
	}
}
