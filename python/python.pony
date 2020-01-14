use "path:/usr/lib" if osx
use "lib:python"

use @realpath[Pointer[U8]](filePath:Pointer[U8] tag, outputPath:Pointer[U8] tag)

use @Py_SetProgramName[None](name:Pointer[U8] tag)
use @Py_GetProgramName[Pointer[U8]]()
use @Py_SetPythonHome[None](name:Pointer[U8] tag)
use @Py_GetPythonHome[Pointer[U8]]()

use @Py_Initialize[None]()
use @Py_Finalize[None]()
use @Py_IsInitialized[I32]()

use @PyImport_AddModule[Pointer[PyObject]](name:Pointer[U8] tag)
use @PyEval_GetGlobals[Pointer[PyObject]]()
use @PyObject_GetAttrString[Pointer[PyObject]](module:Pointer[PyObject], name:Pointer[U8] tag)
use @PyObject_SetAttrString[I32](module:Pointer[PyObject], name:Pointer[U8] tag, value:Pointer[PyObject])

use @PyInt_FromLong[Pointer[PyObject]](value:I32)
use @PyInt_AsLong[I32](obj:Pointer[PyObject])

use @PyString_FromString[Pointer[PyObject]](name:Pointer[U8] tag)
use @PyString_AsString[Pointer[U8]](obj:Pointer[PyObject])


use @Py_DecRef[None](obj:Pointer[PyObject])

use @PyRun_SimpleStringFlags[I32](script:Pointer[U8] tag, flags:Pointer[PyCompilerFlags])

primitive PyCompilerFlags
primitive PyObject

primitive Python

	fun stop() =>
		@Py_Finalize()
	
	fun start() =>
		@Py_Initialize()
	
	fun addModuleSearchPath(dirPath:String) =>
		try run("import os\nimport sys\nsys.path.insert(0, os.path.realpath(\"./" + dirPath + "\"))")? end
	
	fun run(script:String box)? =>
		if @PyRun_SimpleStringFlags(script.cstring(), Pointer[PyCompilerFlags]) != 0 then
			error
		end
	
	fun getInt(name:String):I32 =>
		let m = @PyImport_AddModule("__main__".cstring())
		let v = @PyObject_GetAttrString(m, name.cstring())

		let value = @PyInt_AsLong(v).i32()
		@Py_DecRef(v)
		value
	
	fun setInt(name:String, value:I32) =>
		let m = @PyImport_AddModule("__main__".cstring())
		let v = @PyInt_FromLong(value)
		@PyObject_SetAttrString[I32](m, name.cstring(), v)
		@Py_DecRef(v)
	
	fun getString(name:String):String ref =>
		let m = @PyImport_AddModule("__main__".cstring())
		let v = @PyObject_GetAttrString(m, name.cstring())

		let cpointer = @PyString_AsString(v)
		let value = String.from_cstring(cpointer)
		@Py_DecRef(v)
		value

	fun setString(name:String, value:String) =>
		let m = @PyImport_AddModule("__main__".cstring())
		let v = @PyString_FromString(value.cstring())
		@PyObject_SetAttrString[I32](m, name.cstring(), v)
		@Py_DecRef(v)
		
		