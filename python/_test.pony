use "ponytest"
use "files"

actor Main is TestList
	new create(env: Env) => PonyTest(env, this)
	new make() => None

	fun tag tests(test: PonyTest) =>
	test(_TestPython)
		
	
 	fun @runtime_override_defaults(rto: RuntimeOptions) =>
		//rto.ponyanalysis = true
		rto.ponyminthreads = 2
		rto.ponynoblock = true
		rto.ponygcinitial = 0
		rto.ponygcfactor = 1.0


class iso _TestPython is UnitTest
	fun name(): String => "all python tests in one"

	fun apply(h: TestHelper) =>
		try
			Python.start()
			Python.run("print('hello world from python')")?
			Python.stop()
			
			
			Python.start()
			Python.setInt("y", 10)
			Python.run("x = y + 25")?
			let x = Python.getInt("x")
			
			Python.setString("s1", "hello")
			Python.setString("s2", "world")
			Python.run("s3 = s1 + ' ' + s2")?
			let s3 = Python.getString("s3")
			
			Python.stop()
						
			h.complete((x == 35) and (s3 == "hello world"))
		else
			h.complete(false)
		end

