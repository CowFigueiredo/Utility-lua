--!strict

-- Adaptado por Cow.

export type Set<E> = {
	table: {E},

	Add: (self: Set<E>, element: E) -> boolean,
	Clear: (self: Set<E>) -> (),
	Clone: (self: Set<E>) -> Set<E>,
	Contains: (self: Set<E>, element: E) -> boolean,
	IndexOf: (self: Set<E>, element: E) -> number,
	Remove: (self: Set<E>, element: E) -> boolean,
	RemoveAt: (self: Set<E>, index: number) -> E?
}

local Set = {}
(Set :: any).__index = Set

function Set.new<E>(): Set<E>
	return setmetatable({table = {}}, Set) :: any
end

function Set.Add<E>(self: Set<E>, element: E): boolean
	local i = table.find(self.table, element)
	local empty = i == nil

	if empty then
		self.table[#self.table + 1] = element
	end

	return empty
end

function Set.Clear<E>(self: Set<E>)
	table.clear(self.table)
end

function Set.Clone<E>(self: Set<E>): Set<E>
	return setmetatable({table = table.clone(self.table)}, Set) :: any
end

function Set.Contains<E>(self: Set<E>, element: E): boolean
	return table.find(self.table, element) ~= nil
end

function Set.IndexOf<E>(self: Set<E>, element: E): number
	return table.find(self.table, element) or -1
end

function Set.Remove<E>(self: Set<E>, element: E): boolean
	local i = table.find(self.table, element)
	local exists = i ~= nil

	if exists then
		table.remove(self.table, i)
	end

	return exists
end

function Set.RemoveAt<E>(self: Set<E>, index: number): E?
	return table.remove(self.table, index)
end

return Set
