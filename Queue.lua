--!strict

-- Adaptado por Cow.

export type Queue<E> = {
	size: number,
	table: {E},

	AddFirst: (self: Queue<E>, element: E) -> (),
	AddLast: (self: Queue<E>, element: E) -> (),
	Clear: (self: Queue<E>) -> (),
	Clone: (self: Queue<E>) -> Queue<E>,
	Remove: (self: Queue<E>, element: E) -> boolean,
	RemoveAt: (self: Queue<E>, index: number) -> E?,
	RemoveFirst: (self: Queue<E>) -> E?,
	RemoveLast: (self: Queue<E>) -> E?
}

local Queue = {}
(Queue :: any).__index = Queue

function Queue.new<E>(): Queue<E>
	return setmetatable({size = 0, table = {}}, Queue) :: any
end

function Queue.AddFirst<E>(self: Queue<E>, element: E)
	table.insert(self.table, 1, element)
	self.size += 1
end

function Queue.AddLast<E>(self: Queue<E>, element: E)
	self.table[#self.table + 1] = element
	self.size += 1
end

function Queue.Clear<E>(self: Queue<E>)
	self.size = 0
	table.clear(self.table)
end

function Queue.Clone<E>(self: Queue<E>): Queue<E>
	return setmetatable({
		size = self.size,
		table = table.clone(self.table)
	}, Queue) :: any
end

function Queue.Remove<E>(self: Queue<E>, element: E): boolean
	local i = table.find(self.table, element)

	if i ~= nil then
		self.size -= 1
		table.remove(self.table, i)
		return true
	end

	return false
end

function Queue.RemoveAt<E>(self: Queue<E>, index: number): E?
	local e = table.remove(self.table, index)

	if e ~= nil then
		self.size -= 1
	end

	return e
end

function Queue.RemoveFirst<E>(self: Queue<E>): E?
	return self:RemoveAt(1)
end

function Queue.RemoveLast<E>(self: Queue<E>): E?
	return self:RemoveAt(self.size)
end

return Queue
