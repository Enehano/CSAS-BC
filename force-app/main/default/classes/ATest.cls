@IsTest
class ATest {
	@IsTest
	static void tst() {
		String a = A.tst();
		System.assertEquals('1', a, 'w');
	}
}
