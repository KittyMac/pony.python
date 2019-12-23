use "path:/usr/lib" if osx
use "lib:python"

use @Py_SetProgramName[None](name:Pointer[U8] tag)
use @Py_GetProgramName[Pointer[U8]]()
use @Py_SetPythonHome[None](name:Pointer[U8] tag)
use @Py_GetPythonHome[Pointer[U8]]()

use @Py_Initialize[None]()
use @Py_Finalize[None]()
use @Py_IsInitialized[I32]()

use @PyRun_SimpleStringFlags[I32](script:Pointer[U8] tag, flags:Pointer[PyCompilerFlags])

primitive PyCompilerFlags

primitive Python
	
	fun stop() =>
		@Py_Finalize()
	
	fun start() =>
		@Py_SetProgramName("PonyPython".cstring())
		@Py_Initialize()
	
	fun run(script:String) =>
		@PyRun_SimpleStringFlags(script.cstring(), Pointer[PyCompilerFlags])
		
		
	

