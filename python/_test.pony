use "ponytest"
use "files"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
		test(_TestPython1)
	
 	fun @runtime_override_defaults(rto: RuntimeOptions) =>
		//rto.ponyanalysis = true
		rto.ponyminthreads = 2
		rto.ponynoblock = true
		rto.ponygcinitial = 0
		rto.ponygcfactor = 1.0


class iso _TestPython1 is UnitTest
	fun name(): String => "execute simple python script"

	fun apply(h: TestHelper) =>		
		Python.start()
		Python.run("print('hello world from python')")
		Python.stop()

		h.complete(true)

