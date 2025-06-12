--!strict

-- Adaptado por Cow.

local Task = require(script.Parent.Task)

export type Listener<T...> = {
	signal: Signal<T...>?,
	Disconnect: (self: Listener<T...>) -> ()
}

export type Signal<T...> = {
	listeners: {[Listener<T...>]: (T...) -> ()},
	threads: {thread},

	Connect: (self: Signal<T...>, callback: (T...) -> ()) -> Listener<T...>,
	Fire: (self: Signal<T...>, T...) -> (),
	Wait: (self: Signal<T...>) -> T...
}

local MapListener = {}
MapListener.__index = MapListener

function MapListener.Disconnect<T...>(self: Listener<T...>)
	if self.signal then
		self.signal.listeners[self] = nil
		self.signal = nil
	end
end

local MapSignal = {}
MapSignal.__index = MapSignal

function MapSignal.new<T...>(): Signal<T...>
	return setmetatable({listeners = {}, threads = {}}, MapSignal) :: any
end

function MapSignal.Connect<T...>(self: Signal<T...>, callback: (T...) -> ()): Listener<T...>
	local listener: Listener<T...> = setmetatable({signal = self}, MapListener) :: any
	self.listeners[listener] = callback

	return listener
end

function MapSignal.Fire<T...>(self: Signal<T...>, ...: T...)
	for _, callback in pairs(self.listeners) do
		Task.Defer(callback, ...)
	end

	for _, thread in pairs(self.threads) do
		task.defer(thread, ...)
	end

	table.clear(self.threads)
end

function MapSignal.Wait<T...>(self: Signal<T...>): T...
	table.insert(self.threads, coroutine.running())
	return coroutine.yield()
end

return table.freeze(MapSignal)
