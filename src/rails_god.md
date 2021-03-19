#Rails god後臺進程管理監控框架

**god**是使用ruby編寫的一個管理監控**後臺服務進程**的框架。它的主要作用就是對後臺的服務進程進行監控，並且
在一定程度上進行管理和維護，當然這個後臺服務進程可以是一個rails服務進程。god的監控功能，來源於它可以時時的
反應的當前後臺服務進程的狀態；而其管理功能則來源於god可以編寫自己的**命令腳本**對後臺服務進程進行一些操作。

在god出現之前，這裏也有許許多多的方法來管理和監控後臺服務進程，普遍被採用的方法是編寫後臺服務
進程的**shell**型的命令腳本，或者是**crontab**型的命令腳本。(crontab是指crontab文件，這個文件包含cron服務命令，它的
作用是在Unix或者類Unix的系統中在後臺**週期性**的執行被包含在文件中的命令，它的本質就是Linux中內置的**計
劃任務**服務)有關於crontab的更多詳情請參考：

    http://baike.baidu.com/link?url=iYF1tptR31skjI2BtL5mlUpUMJ9eULeu3WORjnTqo0m4brTZN-5QAxD9jUhB6gmlSL4PYvH40VaCuFpyCCFsHq
    http://baike.baidu.com/link?url=6ZhysWXsdAaRTTWBalNT6L0FPktKUBJ806D3xUKMLvo6dYjWtpa2Ddr7gTZb3l3q0ftG6glXCLx_Y-MGwV6To_

除了編寫腳本命令之外，還有一個方法就是爲後臺服務設置一個進程crush失敗通知郵件方法，但是這個方
法完全沒有任何實際意義；因爲我們要做的就是防止這種情況的發生，而不是當這種情況發生了我們只是被
通知而已。除此之外，這些方法還有許許多多的缺點，比如說：我們的命令腳本很多時候並不總是那麼完美，它們
或多或少的都有一些毛病；更重要的一點是這些我們自己寫的腳本很可惜的往往只能針對一個應用進程，毫無可移植性。

god應運而生的目的就是解決這些傳統方法的問題。因爲它使用ruby編寫，這使得它十分簡單和靈活，並且更加有效。
首先因爲ruby語言的靈活性，我們能編寫許多屬於自己需要的條件的功能；其次god不僅支
持**poll()**函數也支持**事件驅動**。(poll()函數是Unix/Linux系統的一個回調函數，其本身也是基於事件驅動的。
詳情請訪問：http://www.tutorialspoint.com/unix_system_calls/poll.htm )

另外，god有一個強大的集成系統通知，對於每一個notofication都有其詳盡的描述；而且對於**非守護進程**，god同
樣能編寫命令對其有一個很好的控制。god的最終目的就是爲了讓後臺進程服務管理監控更加簡便和自動化，安裝god也
十分簡單，因爲god是使用ruby編寫的，即也可以使用ruby gem來安裝。

```
$ sudo gem install god
```

god的使用方法也很簡單，網上有許多資源可以參考，這裏便不再贅述。以下是一些參考，對於大家瞭解和使用god很有幫助：

① 關於god的本質和基礎教程：http://godrb.com/

② god的實際運用：http://www.synbioz.com/blog/monitoring_server_processes_with_god

③ god在github上的開源項目：https://github.com/mojombo/god/

**TODO：請使用一個簡單的rails例子來說明god的工作機制。**
