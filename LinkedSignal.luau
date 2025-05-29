--!strict

-- Adaptado por Cow.

export type LinkedListener<T...> = {
	callback: (T...) -> ()?,
	thread: thread?,

	previous: LinkedListener<T...>,
	next: LinkedListener<T...>,

	Disconnect: (self: LinkedListener<T...>) -> ()
}

export type LinkedSignal<T...> = {
	previous: LinkedListener<T...>,
	next: LinkedListener<T...>,

	Connect: (self: LinkedSignal<T...>, callback: (T...) -> ()) -> LinkedListener<T...>,
	Fire: (self: LinkedSignal<T...>, T...) -> (),
	Wait: (self: LinkedSignal<T...>) -> T...
}

local LinkedListener = {}
(LinkedListener :: any).__index = LinkedListener

function LinkedListener.Disconnect<T...>(self: LinkedListener<T...>)
	self.previous.next = self.next
	self.next.previous = self.previous
end

local LinkedSignal = {}
(LinkedSignal :: any).__index = LinkedSignal

function LinkedSignal.new<T...>(): LinkedSignal<T...>
	local self: LinkedSignal<T...> = setmetatable({}, LinkedSignal) :: any
	self.previous, self.next = self :: any, self :: any

	return self
end

function LinkedSignal.Connect<T...>(self: LinkedSignal<T...>, callback: (T...) -> ()): LinkedListener<T...>
	local listener: LinkedListener<T...> = setmetatable({
		callback = callback,
		previous = self.previous,
		next = self
	}, LinkedListener) :: any

	self.previous.next = listener
	self.previous = listener

	return listener
end

function LinkedSignal.Fire<T...>(self: LinkedSignal<T...>, ...: T...)
	local listener = self.next

	while listener ~= self do
		if listener.callback then
			task.defer(listener.callback, ...)
		elseif listener.thread then
			task.defer(listener.thread, ...)
		end

		listener = listener.next
	end
end

function LinkedSignal.Wait<T...>(self: LinkedSignal<T...>): T...
	local listener = setmetatable({
		previous = self.previous,
		next = self,
		thread = coroutine.running()
	}, LinkedListener) :: any

	self.previous.next = listener
	self.previous = listener

	return coroutine.yield()
end

return LinkedSignal
