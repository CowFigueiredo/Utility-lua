--!strict

-- Adaptado por Cow.

export type Map<K, V> = {
	size: number,
	table: {[K]: V},

	Clear: (self: Map<K, V>) -> (),
	Clone: (self: Map<K, V>) -> Map<K, V>,
	Contains: (self: Map<K, V>, key: K) -> boolean,
	ContainsAll: (self: Map<K, V>, ...K) -> boolean,
	Find: (self: Map<K, V>, value: V) -> K?,
	Get: (self: Map<K, V>, key: K) -> V?,
	Keys: (self: Map<K, V>) -> {K},
	Put: (self: Map<K, V>, key: K, value: V) -> boolean,
	PutAll: (self: Map<K, V>, map: {[K]: V}) -> (),
	Remove: (self: Map<K, V>, key: K) -> V?,
	Values: (self: Map<K, V>) -> {V}
}

local Map = {}
(Map :: any).__index = Map

function Map.new<K, V>(): Map<K, V>
	return setmetatable({
		size = 0,
		table = {}
	}, Map) :: any
end

function Map.Clear<K, V>(self: Map<K, V>)
	self.size = 0
	table.clear(self.table)
end

function Map.Clone<K, V>(self: Map<K, V>): Map<K, V>
	return setmetatable({
		size = self.size,
		table = table.clone(self.table)
	}, Map) :: any
end

function Map.Contains<K, V>(self: Map<K, V>, key: K): boolean
	return self.table[key] ~= nil
end

function Map.ContainsAll<K, V>(self: Map<K, V>, ...: K): boolean
	for _, k in {...} do
		if self.table[k] == nil then
			return false
		end
	end

	return true
end

function Map.Find<K, V>(self: Map<K, V>, value: V): K?
	if self.size > 0 then
		for k, v in self.table do
			if v == value then
				return k
			end
		end
	end

	return nil
end

function Map.Get<K, V>(self: Map<K, V>, key: K): V?
	return self.table[key]
end

function Map.Keys<K, V>(self: Map<K, V>): {K}
	local keys = table.create(self.size)

	for k in self.table do
		keys[#keys + 1] = k
	end

	return keys
end

function Map.Put<K, V>(self: Map<K, V>, key: K, value: V): boolean
	local wasEmpty = self.table[key] == nil
	self.table[key] = value

	if wasEmpty then
		self.size += 1
	end

	return wasEmpty
end

function Map.PutAll<K, V>(self: Map<K, V>, map: {[K]: V})
	for k, v in map do
		if self.table[k] == nil then
			self.size += 1
		end

		self.table[k] = v
	end
end

function Map.Remove<K, V>(self: Map<K, V>, key: K): V?
	local prev = self.table[key]
	self.table[key] = nil

	if prev ~= nil then
		self.size -= 1
	end

	return prev
end

function Map.Values<K, V>(self: Map<K, V>): {V}
	local values = table.create(self.size)

	for _, v in self.table do
		values[#values + 1] = v
	end

	return values
end

return Map
