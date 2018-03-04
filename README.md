gm_example
=====

An OTP application

Build
-----

    $ rebar3 compile

-----

这里写个比较有趣的GM模块的例子。

缘起：以前做项目，都有GM命令的模块，添加一条GM命令就需要去某一个地方，添加一个注释，让其他同事知道增加的命令。但这样做其实及其繁琐，加上人类总是懒惰的，就导致可能我们对应的GM命令的文档里面不齐全，缺失部分命令（因为可能某些原因导致某一同事加一个命令的时候忘记去修改对应的文档）。
	
目的：这个example的最终目的是让服务端程序可以每次加命令的时候不需要去维护额外的文档。
	
服务端实现：客户端发一条协议来请求GM命令列表，服务端收到命令之后执行一个脚本，收集这些命令，并把收集到的命令按照给定的格式返回给客户端。

客户端实现：收到服务端返回的GM命令列表，我们按照协议的内容弄一个界面表现出来，这个界面里面可以做些按钮点击效果，
一点击就发送对应的GM命令给服务端。

如此，后面如果增加一个命令，客户端的界面会自动显示出来。其他部门的同事不需要再去记相应的命令。

windows环境，执行dev.bat，在erlang终端运行 gm_example_sup:acceptRequest(). 可以看到大致效果。
