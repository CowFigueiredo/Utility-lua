--!strict

-- Adaptado por Cow.

local threads: {thread} = {}

local function Call<T...>(functionOrThread: (T...) -> (), ...: T...)
	functionOrThread(...)
	table.insert(threads, coroutine.running())
end

local function Thread()
	while true do
		Call(coroutine.yield())
	end
end

local function Task(method: <A..., R...>((A...) -> (R...) | thread, A...) -> ())
	return function<A...>(functionOrThread: (A...) -> () | thread, ...: A...)
		method(table.remove(threads) or task.spawn(Thread), functionOrThread, ...)
	end
end

return table.freeze({
	Spawn = Task(task.spawn),
	Defer = Task(task.defer),

	Delay = function<A...>(duration: number?, functionOrThread: (A...) -> () | thread, ...: A...)
		return task.delay(duration, table.remove(threads) or task.spawn(Thread), functionOrThread, ...)
	end
})
